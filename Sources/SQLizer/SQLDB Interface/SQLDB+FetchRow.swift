//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    // MARK: - Fetch Row
    
    public func fetchRow(using sql: SQL) throws -> SQLRow? {
        try fetchRow(using: prepareStatement(sql))
    }

    public func fetchRow(using sql: SQL, values: SQLValue...) throws -> SQLRow? {
        try fetchRow(using: sql, values: values)
    }

    public func fetchRow(using sql: SQL, values: [SQLValue]) throws -> SQLRow? {
        try fetchRow(using: prepareStatement(sql), values: values)
    }

    public func fetchRow(using sql: SQL, values: [SQLColumnCompatibleType?]) throws -> SQLRow? {
        try fetchRow(using: prepareStatement(sql), values: values)
    }

    public func fetchRow(using sql: SQL, values: [String: SQLColumnCompatibleType?]) throws -> SQLRow? {
        try fetchRow(using: prepareStatement(sql), values: values)
    }
    
    // MARK: - Fetch Row Statement
    
    public func fetchRow(using statement: SQLStatement) throws -> SQLRow? {
        try statement.fetchRow()
    }

    public func fetchRow(using statement: SQLStatement, values: SQLValue...) throws -> SQLRow? {
        try fetchRow(using: statement, values: values)
    }

    public func fetchRow(using statement: SQLStatement, values: [SQLValue]) throws -> SQLRow? {
        try statement.fetchRow(values: values)
    }

    public func fetchRow(using statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws -> SQLRow? {
        try statement.fetchRow(values: values)
    }

    public func fetchRow(using statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws -> SQLRow? {
        try statement.fetchRow(namesAndValues: values)
    }
}
