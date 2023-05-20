import Foundation

public enum SQLValue {
    case text(String)
    case int(Int)
    case double(Double)
    case blob(Data)
    case null
}

extension SQLValue {
    
    public var stringValue: String? {
        if case .text(let value) = self {
            return value
        } else {
            return nil
        }
    }

    public var intValue: Int? {
        if case .int(let value) = self {
            return value
        } else {
            return nil
        }
    }

    public var doubleValue: Double? {
        if case .double(let value) = self {
            return value
        } else {
            return nil
        }
    }

    public var dataValue: Data? {
        if case .blob(let value) = self {
            return value
        } else {
            return nil
        }
    }
}
