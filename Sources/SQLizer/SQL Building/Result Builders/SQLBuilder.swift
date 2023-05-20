import Foundation

@resultBuilder
public struct SQLBuilder {

    public static func buildExpression(_ expression: JoinedSequence<[String]>) -> [String] {
        [String(expression)]
    }
    
    public static func buildExpression(_ expression: String) -> [String] {
        [expression]
    }
    
    public static func buildExpression(_ expression: SQL) -> [String] {
        [expression.string]
    }

    public static func buildExpression(_ table: SQLTable) -> [String] {
        [table.name]
    }

    public static func buildExpression(_ column: SQLTableColumn) -> [String] {
        [column.name]
    }
    
    public static func buildExpression(_ columns: [SQLTableColumn]) -> [String] {
        [columns.map { $0.name }.joined(separator: ", ")]
    }

    public static func buildExpression(_ onConflict: SQLConflictResolutionType?) -> [String] {
        if let onConflict = onConflict {
            return [onConflict.forQueryString]
        } else {
            return []
        }
    }

    public static func buildExpression(_ columnType: SQLColumnCompatibleType.Type) -> [String] {
        return [columnType.queryStringType]
    }
    
    public static func buildExpression(_ columnValue: SQLColumnCompatibleType) -> [String] {
        return [columnValue.queryStringValue]
    }
    
    public static func buildExpression(_ names: [String]) -> [String] {
        [names.joined(separator: ", ")]
    }
    
    public static func buildBlock() -> [String] { [] }
    
    public static func buildBlock(_ component: [String]...) -> [String] {
        component.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [String]?) -> [String] {
        component ?? []
    }
    
    public static func buildEither(first component: [String]) -> [String] {
        component
    }

    public static func buildEither(second component: [String]) -> [String] {
        component
    }
    
    /// Needed for `for` loop support.
    public static func buildArray(_ components: [[String]]) -> [String] {
        return components.flatMap { $0 }
    }
    
    public static func buildFinalResult(_ component: [String]) -> SQL {
        return SQL(component.joined(separator: " "))
    }
}
