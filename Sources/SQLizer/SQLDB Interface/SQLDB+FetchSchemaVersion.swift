import Foundation

@SQLActor
extension SQLDB {
        
    public func fetchSchemaVersion() throws -> Int {
        if let row = try prepare(.Internal.fetchSchemaVersion).fetchRow() {
            if let value = try row.value(at: 0, as: Int.self) {
                return value
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
}
