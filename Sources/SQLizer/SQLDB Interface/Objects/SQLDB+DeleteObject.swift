//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    public func deleteObject<T: SQLRowRepresentable>(_ object: T) throws {
        try execute(SQL.deleteObject(ofType: T.self), object: object)
    }

    public func deleteObject<T: SQLRowRepresentable>(_ object: T, identifiedBy columns: [SQLTableColumn]) throws {
        try execute(SQL.deleteObject(ofType: T.self, identifiedBy: columns), object: object)
    }

    public func deleteObject<T: SQLRowRepresentable>(_ object: T, identifiedBy columnNames: [String]) throws {
        try execute(SQL.deleteObject(ofType: T.self, identifiedBy: columnNames), object: object)
    }
}
