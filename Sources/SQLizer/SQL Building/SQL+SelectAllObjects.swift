import Foundation

extension SQL {
    
    public static func selectAllObjects<T: SQLRowRepresentable>(ofType type: T.Type) -> SQL {
        
        return makeSQL {
            "SELECT * FROM"
            T.sqlTable.name
            ";"
        }
    }
}
