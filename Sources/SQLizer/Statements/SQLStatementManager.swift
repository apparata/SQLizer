//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

@SQLActor
internal class SQLStatementManager {
    
    private var statements: [SQL: SQLStatementID] = [:]
    
    private let db: SQLDatabaseID
    
    private var errorMessage: String {
        return String(cString: sqlite3_errmsg(db))
    }
    
    internal init(db: SQLDatabaseID) {
        self.db = db
    }
    
    deinit {
        for statementID in statements.values {
            let status = sqlite3_finalize(statementID)
            guard status == SQLITE_OK else {
                logger.error(db)
                continue
            }
        }
    }
    
    func prepareStatement(_ sql: SQL) throws -> SQLStatement {
        
        if let statementID = statements[sql] {
            return SQLStatement(id: statementID, db: db)
        }
        
        var prepareID: SQLStatementID?
        try sqlite3_prepare_v2(db, sql.string, -1, &prepareID, nil)
            .throwIfNotOK(.failedToPrepareStatement, db)
        
        guard let statementID = prepareID else {
            throw SQLError.failedToPrepareStatement("Failed to prepare statement.")
        }

        return SQLStatement(id: statementID, db: db)
    }
    
    /// Do not use this directly unless absolutely necessary.
    func prepareUncheckedStatement(_ sql: String) throws -> SQLStatement {

        var prepareID: SQLStatementID?
        try sqlite3_prepare_v2(db, sql, -1, &prepareID, nil)
            .throwIfNotOK(.failedToPrepareStatement, db)
        
        guard let statementID = prepareID else {
            throw SQLError.failedToPrepareStatement("Failed to prepare statement.")
        }

        return SQLStatement(id: statementID, db: db)

    }
}
