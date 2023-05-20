import Foundation

public struct SQLDropOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let ifExists = Self(rawValue: 1 << 0)
    public static let excludeSemicolon = Self(rawValue: 1 << 3)

    public static let all: Self = [.ifExists, .excludeSemicolon]
}
