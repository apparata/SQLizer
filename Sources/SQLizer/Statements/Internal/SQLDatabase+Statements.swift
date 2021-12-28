//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

internal extension SQLDatabase {
    
    @SQLActor
    struct Statements {
        
        let beginTransaction: SQLStatement
        let rollbackTransaction: SQLStatement
        let commitTransaction: SQLStatement

        let vacuum: SQLStatement
        
        let fetchSchemaVersion: SQLStatement
        let updateSchemaVersion: SQLStatement
        
        init(_ manager: SQLStatementManager, schemaVersion: Int) throws {
            beginTransaction = try manager.prepareStatement("BEGIN EXCLUSIVE")
            rollbackTransaction = try manager.prepareStatement("ROLLBACK")
            commitTransaction = try manager.prepareStatement("COMMIT")
            
            vacuum = try manager.prepareStatement("VACUUM")
            
            fetchSchemaVersion = try manager.prepareStatement("PRAGMA user_version")
            updateSchemaVersion = try manager.prepareUncheckedStatement("PRAGMA user_version = \(schemaVersion)")
        }
    }
}
