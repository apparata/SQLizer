//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    // MARK: - Fetch All Rows

    public func fetchAllRows(using sql: SQL) throws -> [SQLRow] {
        try fetchAllRows(using: prepareStatement(sql))
    }

    public func fetchAllRows(using sql: SQL, values: SQLValue...) throws -> [SQLRow] {
        try fetchAllRows(using: sql, values: values)
    }

    public func fetchAllRows(using sql: SQL, values: [SQLValue]) throws -> [SQLRow] {
        try fetchAllRows(using: prepareStatement(sql), values: values)
    }

    public func fetchAllRows(using sql: SQL, values: [SQLColumnCompatibleType?]) throws -> [SQLRow] {
        try fetchAllRows(using: prepareStatement(sql), values: values)
    }

    public func fetchAllRows(using sql: SQL, values: [String: SQLColumnCompatibleType?]) throws -> [SQLRow] {
        try fetchAllRows(using: prepareStatement(sql), values: values)
    }
    
    // MARK: - Fetch All Rows Statement

    public func fetchAllRows(using statement: SQLStatement) throws -> [SQLRow] {
        try statement.fetchAllRows()
    }

    public func fetchAllRows(using statement: SQLStatement, values: SQLValue...) throws -> [SQLRow] {
        try fetchAllRows(using: statement, values: values)
    }

    public func fetchAllRows(using statement: SQLStatement, values: [SQLValue]) throws -> [SQLRow] {
        try statement.fetchAllRows(values: values)
    }

    public func fetchAllRows(using statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws -> [SQLRow] {
        try statement.fetchAllRows(values: values)
    }

    public func fetchAllRows(using statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws -> [SQLRow] {
        try statement.fetchAllRows(namesAndValues: values)
    }
}
