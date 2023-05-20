import Foundation

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
