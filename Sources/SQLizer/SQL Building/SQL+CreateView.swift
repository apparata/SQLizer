import Foundation

extension SQL {
    
    public static func createView(_ view: SQLView, options: SQLCreateViewOptions = []) -> SQL {
        
        @SQLBuilder
        func makeColumn(_ column: SQLTableColumn) -> SQL {
            column
            column.dataType
            if column.notNullable {
                "NOT NULL"
                if let onConflict = column.notNullableOnConflict {
                    onConflict
                }
            }
            if let defaultTo = column.defaultToAsString {
                "DEFAULT \(defaultTo)"
            }
            if let collation = column.collationName {
                "COLLATE \(collation)"
            }
            if let generatedAs = column.generatedAsExpression {
                "GENERATED ALWAYS AS (\(generatedAs))"
                if column.generatedAsStored {
                    "STORED"
                }
            }
        }
        
        func makeColumns(_ view: SQLView) -> String {
            view.columns.map { makeColumn($0).string }.joined(separator: ",\n ")
        }
        
        return makeSQL {
            "CREATE"
            if options.contains(.temporary) { "TEMPORARY" }
            "VIEW"
            if options.contains(.ifNotExists) { "IF NOT EXISTS" }
            if let schema = view.schemaName {
                "\(schema).\(view.name)"
            } else {
                view.name
            }
            if view.columns.count > 0 {
                "(\n"
                makeColumns(view)
                "\n)"
            }
            "AS \(view.selectStatement)"
            if !options.contains(.excludeSemicolon) {
                ";"
            }
        }
    }
}
