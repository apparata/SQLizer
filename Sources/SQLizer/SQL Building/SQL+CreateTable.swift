import Foundation

extension SQL {
    
    public static func createTable(_ table: SQLTable, options: SQLCreateTableOptions = []) -> SQL {
        
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
        
        func makeColumns(_ table: SQLTable) -> String {
            table.columns.map { makeColumn($0).string }.joined(separator: ",\n ")
        }
        
        return makeSQL {
            "CREATE"
            if options.contains(.temporary) { "TEMPORARY" }
            "TABLE"
            if options.contains(.ifNotExists) { "IF NOT EXISTS" }
            if let schema = table.schemaName {
                "\(schema).\(table.name)"
            } else {
                table.name
            }
            if let selectStatement = table.selectStatement {
                "AS \(selectStatement)"
            } else {
                "(\n"
                makeColumns(table)
                if let primaryKey = table.constraints.primaryKey {
                    ", \n"
                    "PRIMARY KEY ("
                    primaryKey.columns
                    ")"
                    if let onConflict = primaryKey.onConflict {
                        "ON CONFLICT"
                        onConflict
                    }
                }
                if let uniqueColumns = table.constraints.uniqueColumns {
                    ", \n"
                    "UNIQUE ("
                    uniqueColumns.columns
                    ")"
                    if let onConflict = uniqueColumns.onConflict {
                        "ON CONFLICT"
                        onConflict
                    }
                }
                if let checkExpression = table.constraints.check {
                    ", \n"
                    "CHECK ("
                    checkExpression
                    ")"
                }

                "\n)"
            }
            if options.contains(.withoutRowID) {
                "WITHOUT ROWID"
            }
            if !options.contains(.excludeSemicolon) {
                ";"
            }
        }
    }
}
