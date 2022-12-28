//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    // MARK: - Execute Object
    
    public func execute<T: SQLRowRepresentable>(_ sql: SQL, object: T) throws {
        try execute(prepare(sql), object: object)
    }

    // MARK: - Execute Object Statement
    
    public func execute<T: SQLRowRepresentable>(_ statement: SQLStatement, object: T) throws {
        try statement.execute(object: object)
    }
}
