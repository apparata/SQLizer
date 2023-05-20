import Foundation

@SQLActor
extension SQLDB {
    
    public func fetchAllObjectsOfType<T: SQLRowRepresentable>(_ type: T.Type) throws -> [T] {
        try fetchAllObjects(as: type, using: SQL.selectAllObjects(ofType: type))
    }
}
