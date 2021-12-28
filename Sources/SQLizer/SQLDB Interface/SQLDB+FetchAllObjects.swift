//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    // MARK: - Fetch All Objects

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL) throws -> [T] {
        try fetchAllObjects(as: type, using: prepareStatement(sql))
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: SQLValue...) throws -> [T] {
        try fetchAllObjects(as: type, using: sql, values: values)
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: [SQLValue]) throws -> [T] {
        try fetchAllObjects(as: type, using: prepareStatement(sql), values: values)
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: [SQLColumnCompatibleType?]) throws -> [T] {
        try fetchAllObjects(as: type, using: prepareStatement(sql), values: values)
    }
    
    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using sql: SQL, values: [String: SQLColumnCompatibleType?]) throws -> [T] {
        try fetchAllObjects(as: type, using: prepareStatement(sql), values: values)
    }
    
    // MARK: - Fetch All Objects Statement

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement) throws -> [T] {
        try statement.fetchAllObjects()
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement, values: SQLValue...) throws -> [T] {
        try fetchAllObjects(as: type, using: statement, values: values)
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement, values: [SQLValue]) throws -> [T] {
        try statement.fetchAllObjects(values: values)
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws -> [T] {
        try statement.fetchAllObjects(values: values)
    }

    public func fetchAllObjects<T: SQLRowRepresentable>(as type: T.Type, using statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws -> [T] {
        try statement.fetchAllObjects(namesAndValues: values)
    }
}
