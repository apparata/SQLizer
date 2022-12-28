//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

@SQLActor
internal class SQLStatementManager {
        
    private let db: SQLDatabaseID
    
    private var errorMessage: String {
        return String(cString: sqlite3_errmsg(db))
    }
    
    internal init(db: SQLDatabaseID) {
        self.db = db
    }
        
    func prepare(_ sql: SQL) throws -> SQLStatement {
                
        var prepareID: SQLStatementID?
        try sqlite3_prepare_v2(db, sql.string, -1, &prepareID, nil)
            .throwIfNotOK(.failedToPrepareStatement, db)
        
        guard let statementID = prepareID else {
            throw SQLError.failedToPrepareStatement("Failed to prepare statement.")
        }

        return SQLStatement(id: statementID, db: db)
    }
    
    /// Do not use this directly unless absolutely necessary.
    func prepareUnchecked(_ sql: String) throws -> SQLStatement {

        var prepareID: SQLStatementID?
        try sqlite3_prepare_v2(db, sql, -1, &prepareID, nil)
            .throwIfNotOK(.failedToPrepareStatement, db)
        
        guard let statementID = prepareID else {
            throw SQLError.failedToPrepareStatement("Failed to prepare statement.")
        }

        return SQLStatement(id: statementID, db: db)
    }
}
