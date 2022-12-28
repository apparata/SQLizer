//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

public typealias SQLOnUpdate = (SQLUpdateType, _ table: String?, _ rowID: Int64) -> Void

internal typealias SQLDatabaseID = OpaquePointer

@SQLActor
public class SQLDatabase {
    
    /// Specifies whether migration or creation of the database should be performed.
    public enum MigrationType {
    /// This database is being created from scratch with the specified schema version.
    case create(version: Int)
    
    /// This database is being upgraded from `fromVersion` to `toVersion`.
    case upgrade(fromVersion: Int, toVersion: Int)
    }
    
    /// The version of the schema meant to be used in this database.
    public let schemaVersion: Int
    
    /// Called whenever an entry in the table is updated.
    public var onUpdate: SQLOnUpdate? {
        set { setUpdateHook(newValue) }
        get { updateHook?.hook }
    }
    
    private let statementManager: SQLStatementManager
    
    private var updateHook: SQLUpdateHook?

    private let id: SQLDatabaseID
    
    private init(id: SQLDatabaseID, schemaVersion: Int, migration: @SQLActor (_ db: SQLDB, _ type: MigrationType) throws -> Void) throws {
        precondition(schemaVersion > 0)
        self.id = id
        self.schemaVersion = schemaVersion
        statementManager = SQLStatementManager(db: id)
        try migrateIfNecessary(migration)
    }
    
    deinit {
        sqlite3_update_hook(id, nil, nil)
        sqlite3_close_v2(id)
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

    // MARK: - Open Database in Memory
    
    /// Create a new database in memory, which is deallocated when SQLDatabase object is released.
    public static func openInMemory(creation: @SQLActor (_ db: SQLDB) throws -> Void) throws -> SQLDatabase {
        try open(at: ":memory:", schemaVersion: 1) { db, type in
            try creation(db)
        }
    }
    
    // MARK: - Open Temporary Database

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
            try statementManager.prepare(.Internal.beginTransaction).execute()
            let db = SQLDB(statementManager: statementManager)
            let result = try operations(db)
            switch result {
            case .commit:
                try statementManager.prepare(.Internal.commitTransaction).execute()
            case .rollback:
                try statementManager.prepare(.Internal.rollbackTransaction).execute()
            }
            return result
        } catch {
            try statementManager.prepare(.Internal.rollbackTransaction).execute()
            throw error
        }
    }
    
    // MARK: - Compact the database
    
    public func compact() throws {
        try statementManager.prepare(.Internal.vacuum).execute()
    }
    
    // MARK: - Backup database to file
    
    public func backup(to filePath: String) throws {
        try statementManager.prepare(.Internal.vacuumInto).execute(values: [.text(filePath)])
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
                try statementManager.prepare(.Internal.updateSchemaVersion(self.schemaVersion)).execute()
                return .commit
            }
        }
    }
    
    // MARK: - Fetch Schema Version
    
    private func fetchSchemaVersion() throws -> Int {
        guard let row = try statementManager.prepare(.Internal.fetchSchemaVersion).fetchRow() else {
            return 0
        }
        guard let version = try row.value(at: 0, as: Int.self) else {
            return 0
        }
        return version
    }
    
    // MARK: - Set Update Hook
    
    private func setUpdateHook(_ hook: (SQLOnUpdate)?) -> Void {
        if let hook = hook {
            let updateHook = SQLUpdateHook(hook)
            self.updateHook = updateHook
            sqlite3_update_hook(id, { (rawHook: UnsafeMutableRawPointer?, updateType, _, table, rowID) in
                guard let rawHook = rawHook else {
                    return
                }
                let updateHook = Unmanaged<SQLUpdateHook>.fromOpaque(rawHook).takeUnretainedValue()
                let type: SQLUpdateType
                switch updateType {
                case SQLITE_INSERT: type = .insert
                case SQLITE_UPDATE: type = .update
                case SQLITE_DELETE: type = .delete
                default: return
                }
                updateHook.call(type, table.map { String(cString: $0) }, rowID)
            }, Unmanaged<SQLUpdateHook>.passUnretained(updateHook).toOpaque())
        } else {
            sqlite3_update_hook(id, nil, nil)
        }
    }
}

// MARK: - Update Hook

private class SQLUpdateHook {
    let hook: (SQLUpdateType, _ table: String?, _ rowID: Int64) -> Void
    
    init(_ hook: @escaping (SQLUpdateType, _ table: String?, _ rowID: Int64) -> Void) {
        self.hook = hook
    }
    
    func call(_ type: SQLUpdateType, _ table: String?, _ rowID: Int64) {
        hook(type, table, rowID)
    }
}
