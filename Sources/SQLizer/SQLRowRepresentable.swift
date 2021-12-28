//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import AppKit

public protocol SQLRowRepresentable {
    
    static var sqlTable: SQLTable { get }
        
    init(sqlRow: SQLRow) throws
    
    func makeSQLNamesAndValues() throws -> [String: SQLColumnCompatibleType?]
}

extension SQLRowRepresentable {
    var sqlTable: SQLTable {
        Self.sqlTable
    }
}
