//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

internal extension SQL {
        
    struct Internal {
        static let beginTransaction: SQL = "BEGIN EXCLUSIVE;"
        static let rollbackTransaction: SQL = "ROLLBACK;"
        static let commitTransaction: SQL = "COMMIT;"
        
        static let vacuum: SQL = "VACUUM;"
        static let vacuumInto: SQL = "VACUUM main INTO ?;"
        
        static let fetchSchemaVersion: SQL = "PRAGMA user_version;"
        static func updateSchemaVersion(_ schemaVersion: Int) -> SQL {
            return SQL("PRAGMA user_version = \(schemaVersion);")
        }
    }
}
