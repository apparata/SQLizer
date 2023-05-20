import Foundation

@SQLActor
extension SQLDB {
    
    public func upsertObject<T: SQLRowRepresentable>(_ object: T) throws {
        try execute(SQL.upsertObject(ofType: T.self), object: object)
    }
}
