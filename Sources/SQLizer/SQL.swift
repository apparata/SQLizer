import Foundation

/// Represents a textual description of an SQL statement.
public struct SQL: ExpressibleByStringLiteral {

    internal let string: String
    
    public init(stringLiteral string: StaticString) {
        self.string = "\(string)"
    }
    
    /// This is for internal use by builders, and such, only. Do not make public.
    internal init(_ string: String) {
        self.string = string
    }
}

extension SQL: Identifiable {
    
    public var id: String {
        return string
    }
}

extension SQL: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(string)
    }
    
    public static func == (lhs: SQL, rhs: SQL) -> Bool {
        return lhs.string == rhs.string
    }
}

extension SQL {
    internal static func makeSQL(@SQLBuilder _ sql: () -> SQL) -> SQL {
        return sql()
    }
}
