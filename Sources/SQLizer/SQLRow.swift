//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

public struct SQLRow {
    
    public var columnCount: Int {
        return columns.count
    }
    
    internal typealias ColumnIndex = Int32
    
    internal var columnsByName = [SQLColumnName: ColumnIndex]()
    internal var columns = [SQLValue]()
    
    internal mutating func addColumn(name: SQLColumnName, index: ColumnIndex, value: SQLValue) {
        columnsByName[name] = index
        columns.append(value)
    }
    
    public subscript(_ index: Int) -> SQLValue {
        return columns[index]
    }
    
    public subscript(_ columnName: SQLColumnName) -> SQLValue? {
        if let index = columnsByName[columnName],
            Int(index) < columns.count {
            return columns[Int(index)]
        } else {
            return nil
        }
    }

    public func optionalValue<T: SQLColumnCompatibleType>(at index: Int, as type: T.Type) -> T? {
        return T(sqlValue: columns[index])
    }
    
    public func value<T: SQLColumnCompatibleType>(at index: Int, as type: T.Type) throws -> T? {
        guard let value = T(sqlValue: columns[index]) else {
            throw SQLError.valueForColumnIsNull(index)
        }
        return value
    }

    public func optionalValue<T: SQLColumnCompatibleType>(name: SQLColumnName, as type: T.Type) -> T? {
        
        guard let columnValue = self[name] else {
            return nil
        }
        
        return T(sqlValue: columnValue)
    }

    public func optionalValue<T: SQLColumnCompatibleType>(name: SQLColumnName) -> T? {
        
        guard let columnValue = self[name] else {
            return nil
        }
        
        return T(sqlValue: columnValue)
    }

    public func optionalValue<T: SQLColumnCompatibleType>(for column: SQLColumn<T>, as type: T.Type) -> T? {
        
        guard let columnValue = self[column.name] else {
            return nil
        }
        
        return T(sqlValue: columnValue)
    }
    
    public func optionalValue<T: SQLColumnCompatibleType>(for column: SQLColumn<T>) -> T? {
        
        guard let columnValue = self[column.name] else {
            return nil
        }
        
        return T(sqlValue: columnValue)
    }
    
    public func value<T: SQLColumnCompatibleType>(name: SQLColumnName, as type: T.Type) throws -> T {
        
        guard let columnValue = self[name] else {
            throw SQLError.noValueForColumn(name)
        }
        
        guard let value = T(sqlValue: columnValue) else {
            throw SQLError.valueForColumnIsNull(name)
        }
        
        return value
    }
    
    public func value<T: SQLColumnCompatibleType>(name: SQLColumnName) throws -> T {
        
        guard let columnValue = self[name] else {
            throw SQLError.noValueForColumn(name)
        }
        
        guard let value = T(sqlValue: columnValue) else {
            throw SQLError.valueForColumnIsNull(name)
        }
        
        return value
    }
    
    public func value<T: SQLColumnCompatibleType>(for column: SQLColumn<T>, as type: T.Type) throws -> T {
        
        guard let columnValue = self[column.name] else {
            throw SQLError.noValueForColumn(column.name)
        }
        
        guard let value = T(sqlValue: columnValue) else {
            throw SQLError.valueForColumnIsNull(column.name)
        }
        
        return value
    }

    public func value<T: SQLColumnCompatibleType>(for column: SQLColumn<T>) throws -> T {
        
        guard let columnValue = self[column.name] else {
            throw SQLError.noValueForColumn(column.name)
        }
        
        guard let value = T(sqlValue: columnValue) else {
            throw SQLError.valueForColumnIsNull(column.name)
        }
        
        return value
    }

}

extension SQLRow: CustomStringConvertible {
    
    public var description: String {
        var string: String = "{ "
        for (columnName, columnIndex) in columnsByName {
            let value = columns[Int(columnIndex)]
            string += "\(columnName)=\(value) "
        }
        string += "}"
        return string
    }
}
