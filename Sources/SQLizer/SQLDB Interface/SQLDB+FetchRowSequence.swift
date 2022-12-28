//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {

    // MARK: - Fetch Row Sequence
    
    public func fetchRowSequence(using sql: SQL) throws -> SQLRowSequence {
        try fetchRowSequence(using: prepare(sql))
    }

    public func fetchRowSequence(using sql: SQL, values: SQLValue...) throws -> SQLRowSequence {
        try fetchRowSequence(using: sql, values: values)
    }

    public func fetchRowSequence(using sql: SQL, values: [SQLValue]) throws -> SQLRowSequence {
        try fetchRowSequence(using: prepare(sql), values: values)
    }

    public func fetchRowSequence(using sql: SQL, values: [SQLColumnCompatibleType?]) throws -> SQLRowSequence {
        try fetchRowSequence(using: prepare(sql), values: values)
    }

    public func fetchRowSequence(using sql: SQL, values: [String: SQLColumnCompatibleType?]) throws -> SQLRowSequence {
        try fetchRowSequence(using: prepare(sql), values: values)
    }
    
    // MARK: - Fetch Row Sequence Statement
    
    public func fetchRowSequence(using statement: SQLStatement) throws -> SQLRowSequence {
        try statement.fetchRowSequence()
    }

    public func fetchRowSequence(using statement: SQLStatement, values: SQLValue...) throws -> SQLRowSequence {
        try fetchRowSequence(using: statement, values: values)
    }

    public func fetchRowSequence(using statement: SQLStatement, values: [SQLValue]) throws -> SQLRowSequence {
        try statement.fetchRowSequence(values: values)
    }

    public func fetchRowSequence(using statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws -> SQLRowSequence {
        try statement.fetchRowSequence(values: values)
    }

    public func fetchRowSequence(using statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws -> SQLRowSequence {
        try statement.fetchRowSequence(namesAndValues: values)
    }
}
