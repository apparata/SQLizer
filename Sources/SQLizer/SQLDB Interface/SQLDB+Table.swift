//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {

    public func createTable(_ table: SQLTable, options: SQLCreateTableOptions = []) throws {
        try execute(SQL.createTable(table, options: options))
    }
    
    public func dropTable(_ table: SQLTable, options: SQLDropOptions = []) throws {
        try execute(SQL.dropTable(table, options: options))
    }
}
