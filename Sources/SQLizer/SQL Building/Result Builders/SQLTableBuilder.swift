import Foundation

@resultBuilder
public struct SQLTableBuilder {
    
    public static func buildExpression(_ expression: SQLTableColumn) -> [SQLTableColumn] {
        [expression]
    }
    
    public static func buildBlock() -> [SQLTableColumn] { [] }
    
    public static func buildBlock(_ component: [SQLTableColumn]...) -> [SQLTableColumn] {
        component.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [SQLTableColumn]?) -> [SQLTableColumn] {
        component ?? []
    }
    
    public static func buildEither(first component: [SQLTableColumn]) -> [SQLTableColumn] {
        component
    }

    public static func buildEither(second component: [SQLTableColumn]) -> [SQLTableColumn] {
        component
    }
    
    /// Needed for `for` loop support.
    public static func buildArray(_ components: [[SQLTableColumn]]) -> [SQLTableColumn] {
        return components.flatMap { $0 }
    }
    
    public static func buildFinalResult(_ component: [SQLTableColumn]) -> [SQLTableColumn] {
        return component
    }
}
