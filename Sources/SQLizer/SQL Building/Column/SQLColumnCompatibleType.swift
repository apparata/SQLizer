
import Foundation

// MARK: - SQLColumnCompatibleType

public protocol SQLColumnCompatibleType {
    static var queryStringType: String { get }
    var queryStringValue: String { get }
    var asSQLValue: SQLValue { get }
    init?(sqlValue: SQLValue?)
}

// MARK: - String

extension String: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "TEXT"
    }
    
    public var queryStringValue: String {
        return "\"\(self)\""
    }
    
    public var asSQLValue: SQLValue {
        return .text(self)
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.stringValue else {
            return nil
        }
        self = value
    }
}

// MARK: - Int

extension Int: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "INTEGER"
    }
    
    public var queryStringValue: String {
        return String(self)
    }
    
    public var asSQLValue: SQLValue {
        return .int(self)
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.intValue else {
            return nil
        }
        self = value
    }
}

// MARK: - Double

extension Double: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "REAL"
    }
    
    public var queryStringValue: String {
        return String(self)
    }
    
    public var asSQLValue: SQLValue {
        return .double(self)
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.doubleValue else {
            return nil
        }
        self = value
    }
}

// MARK: - Data

extension Data: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "BLOB"
    }
    
    public var queryStringValue: String {
        return "X'\(map { String(format: "%02hhx", $0) }.joined())'"
    }
    
    public var asSQLValue: SQLValue {
        return .blob(self)
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.dataValue else {
            return nil
        }
        self = value
    }
}

// MARK: - Float

extension Float: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "REAL"
    }
    
    public var queryStringValue: String {
        return String(Double(self))
    }
    
    public var asSQLValue: SQLValue {
        return .double(Double(self))
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.doubleValue else {
            return nil
        }
        self = Float(value)
    }
}

// MARK: - Date

extension Date: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "REAL"
    }
    
    public var queryStringValue: String {
        return String(Double(timeIntervalSinceReferenceDate))
    }
    
    public var asSQLValue: SQLValue {
        return .double(Double(timeIntervalSinceReferenceDate))
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.doubleValue else {
            return nil
        }
        self = Date(timeIntervalSinceReferenceDate: value)
    }
}

// MARK: - URL

extension URL: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "TEXT"
    }
    
    public var queryStringValue: String {
        return "\"\(self.absoluteString)\""
    }
    
    public var asSQLValue: SQLValue {
        return .text(self.absoluteString)
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.stringValue else {
            return nil
        }
        guard let value = URL(string: value) else {
            return nil
        }
        self = value
    }
}

// MARK: - UUID

extension UUID: SQLColumnCompatibleType {
    public static var queryStringType: String {
        return "TEXT"
    }
    
    public var queryStringValue: String {
        return "\"\(self.uuidString)\""
    }
    
    public var asSQLValue: SQLValue {
        return .text(self.uuidString)
    }
    
    public init?(sqlValue: SQLValue?) {
        guard let value = sqlValue?.stringValue else {
            return nil
        }
        guard let value = UUID(uuidString: value) else {
            return nil
        }
        self = value
    }
}
