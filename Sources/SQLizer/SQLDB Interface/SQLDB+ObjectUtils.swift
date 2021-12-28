//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    public func upsertObject<T: SQLRowRepresentable>(_ object: T) throws {
        try execute(SQL.upsertObject(ofType: T.self), object: object)
    }
        
    public func fetchAllObjectsOfType<T: SQLRowRepresentable>(_ type: T.Type) throws -> [T] {
        try fetchAllObjects(as: type, using: SQL.selectAllObjects(ofType: type))
    }
}
