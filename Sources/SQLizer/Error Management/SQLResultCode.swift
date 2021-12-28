//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

internal typealias SQLResultCode = Int32

internal extension SQLResultCode {
    
    var isValidSQLResult: Bool {
        self == SQLITE_OK
    }
    
    func throwIfNotOK(_ type: SQLErrorType, _ db: SQLDatabaseID) throws {
        guard isValidSQLResult else {
            throw SQLError(type, db: db)
        }
    }
}
