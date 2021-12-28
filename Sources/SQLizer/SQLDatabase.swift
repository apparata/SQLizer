//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

internal typealias SQLDatabaseID = OpaquePointer

@SQLActor
public class SQLDatabase {
    
    public enum MigrationType {
    case create(version: Int)
    case upgrade(fromVersion: Int, toVersion: Int)
    }
    
    private let id: SQLDatabaseID
    
    /// The version of the schema meant to be used in this database.
    public let schemaVersion: Int
    
    private let statementManager: SQLStatementManager
    
    private let statements: Statements
    
    private init(id: SQLDatabaseID, schemaVersion: Int, migration: @SQLActor (_ db: SQLDB, _ type: MigrationType) throws -> Void) throws {
        precondition(schemaVersion > 0)
        self.id = id
        self.schemaVersion = schemaVersion
        statementManager = SQLStatementManager(db: id)
        statements = try Statements(statementManager, schemaVersion: schemaVersion)
        try migrateIfNecessary(migration)
    }
    
    deinit {
        sqlite3_update_hook(id, nil, nil)
        sqlite3_close(id)
    }
    
    // MARK: - Open Database
    
    /// Open, or create, a database file at path.
    public static func open(at path: String, schemaVersion: Int, migration: @SQLActor (_ db: SQLDB, _ type: MigrationType) throws -> Void) throws -> SQLDatabase {
        var db: SQLDatabaseID? = nil
        
        guard sqlite3_open(path, &db).isValidSQLResult, let db = db else {
            if let db = db {
                sqlite3_close(db)
                throw SQLError.failedToOpenDatabase(db)
            } else {
                throw SQLError.failedToOpenDatabase(at: path)
            }
        }
        
        return try SQLDatabase(id: db, schemaVersion: schemaVersion, migration: migration)
    }

    /// Create a new database in memory, which is deallocated when SQLDatabase object is released.
    public static func openInMemory(creation: @SQLActor (_ db: SQLDB) throws -> Void) throws -> SQLDatabase {
        try open(at: ":memory:", schemaVersion: 1) { db, type in
            try creation(db)
        }
    }

    /// Create a new temporary database file, which is deleted when SQLDatabase object is released.
    ///
    /// Even though a disk file is allocated for each temporary database, in practice the temporary database
    /// usually resides in the in-memory pager cache and hence is very little difference between a pure
    /// in-memory database and a temporary database. The sole difference is that an in-memory database
    /// must remain in memory at all times whereas parts of a temporary database might be flushed to disk
    /// if database becomes large or if SQLite comes under memory pressure.
    ///
    public static func openTemporary(creation: @SQLActor (_ db: SQLDB) throws -> Void) throws -> SQLDatabase {
        try open(at: "", schemaVersion: 1) { db, type in
            try creation(db)
        }
    }
    
    // MARK: - Run SQL Operations
    
    public func run(_ operations: @SQLActor (SQLDB) throws -> Void) throws {
        let db = SQLDB(statementManager: statementManager)
        try operations(db)
    }

    // MARK: - Perform SQL Transaction
    
    @discardableResult
    public func transaction(_ operations: @SQLActor (SQLDB) throws -> SQLTransactionResult) throws -> SQLTransactionResult {
        do {
            try statements.beginTransaction.execute()
            let db = SQLDB(statementManager: statementManager)
            let result = try operations(db)
            switch result {
            case .commit: try statements.commitTransaction.execute()
            case .rollback: try statements.rollbackTransaction.execute()
            }
            return result
        } catch {
            try statements.rollbackTransaction.execute()
            throw error
        }
    }
    
    // MARK: - Compact the database
    
    public func compact() throws {
        try statements.vacuum.execute()
    }
    
    // MARK: - Check Schema Version
    
    private func migrateIfNecessary(_ migration: @SQLActor (_ db: SQLDB, _ type: MigrationType) throws -> Void) throws {
        let version = try fetchSchemaVersion()
        if version == schemaVersion {
            // This database is the correct version.
            return
        } else if version > schemaVersion {
            throw SQLError.cannotMigrateToEarlierSchemaVersion()
        } else {
            try transaction { db in
                if version == 0 {
                    try migration(db, .create(version: self.schemaVersion))
                } else {
                    try migration(db, .upgrade(fromVersion: version, toVersion: self.schemaVersion))
                }
                try self.statements.updateSchemaVersion.execute()
                return .commit
            }
        }
    }
    
    // MARK: - Fetch Schema Version
    
    private func fetchSchemaVersion() throws -> Int {
        guard let row = try statements.fetchSchemaVersion.fetchRow() else {
            return 0
        }
        guard let version = try row.value(at: 0, as: Int.self) else {
            return 0
        }
        return version
    }
}
