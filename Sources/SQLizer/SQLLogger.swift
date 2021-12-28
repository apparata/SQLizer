//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import os
import libsqlite3

let logger = Logger(subsystem: "io.apparata.sqlitekit", category: "Database")

extension Logger {
    
    func error(_ db: SQLDatabaseID) {
        let message = String(cString: sqlite3_errmsg(db))
        logger.error("Error: \(message)")
    }
}
