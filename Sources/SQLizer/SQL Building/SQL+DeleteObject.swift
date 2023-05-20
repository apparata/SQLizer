import Foundation

extension SQL {
    
    public static func deleteObject<T: SQLRowRepresentable>(ofType type: T.Type) -> SQL {
        
        if let primaryKeyColumnNames = T.sqlTable.constraints.primaryKey?.columns {
            return deleteObject(ofType: type, identifiedBy: primaryKeyColumnNames)
        } else {
            return deleteObject(ofType: type, identifiedBy: T.sqlTable.columns)
        }
    }

    public static func deleteObject<T: SQLRowRepresentable>(ofType type: T.Type, identifiedBy columns: [SQLTableColumn]) -> SQL {
        deleteObject(ofType: type, identifiedBy: columns.map(\.name))
    }

    public static func deleteObject<T: SQLRowRepresentable>(ofType type: T.Type, identifiedBy columnNames: [String]) -> SQL {
                
        let whereColumns = columnNames.map { columnName in
                "\(columnName) == :\(columnName)"
            }.joined(separator: " AND ")
        
        let sql = makeSQL {
            "DELETE FROM"
            T.sqlTable.name
            "WHERE"
            whereColumns
            ";"
        }
        
        dump(sql)
        
        return sql
    }
}
