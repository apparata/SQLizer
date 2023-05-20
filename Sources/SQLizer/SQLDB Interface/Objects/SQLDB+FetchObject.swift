import Foundation

@SQLActor
extension SQLDB {
    
    // MARK: - Fetch Object
    
    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL) throws -> T? {
        try fetchObject(as: type, using: prepare(sql))
    }

    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: SQLValue...) throws -> T? {
        try fetchObject(as: type, using: sql, values: values)
    }

    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: [SQLValue]) throws -> T? {
        try fetchObject(as: type, using: prepare(sql), values: values)
    }

    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: [SQLColumnCompatibleType?]) throws -> T? {
        try fetchObject(as: type, using: prepare(sql), values: values)
    }

    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: [String: SQLColumnCompatibleType?]) throws -> T? {
        try fetchObject(as: type, using: prepare(sql), values: values)
    }
    
    // MARK: - Fetch Object Statement
    
    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement) throws -> T? {
        try statement.fetchObject()
    }

    public func fetchObject<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement, values: SQLValue...) throws -> T? {
        return try fetchObject(as: type, using: statement, values: values)
    }

    public func fetchObject<T: SQLRowRepresentable>(as: T.Type, using statement: SQLStatement, values: [SQLValue]) throws -> T? {
        try statement.fetchObject(values: values)
    }

    public func fetchObject<T: SQLRowRepresentable>(as: T.Type, using statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws -> T? {
        try statement.fetchObject(values: values)
    }

    public func fetchObject<T: SQLRowRepresentable>(as: T.Type, using statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws -> T? {
        try statement.fetchObject(namesAndValues: values)
    }
}
