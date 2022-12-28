//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
    
    // MARK: - Execute
    
    public func execute(_ sql: SQL) throws {
        try execute(prepare(sql))
    }

    public func execute(_ sql: SQL, values: SQLValue...) throws {
        try execute(prepare(sql), values: values)
    }

    public func execute(_ sql: SQL, values: [SQLValue]) throws {
        try execute(prepare(sql), values: values)
    }

    public func execute(_ sql: SQL, values: [SQLColumnCompatibleType?]) throws {
        try execute(prepare(sql), values: values)
    }

    public func execute(_ sql: SQL, values: [String: SQLColumnCompatibleType?]) throws {
        try execute(prepare(sql), values: values)
    }
    
    // MARK: - Execute Statement
    
    public func execute(_ statement: SQLStatement) throws {
        try statement.execute()
    }

    public func execute(_ statement: SQLStatement, values: SQLValue...) throws {
        try execute(statement, values: values)
    }
    
    public func execute(_ statement: SQLStatement, values: [SQLValue]) throws {
        try statement.execute(values: values)
    }
    
    public func execute(_ statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws {
        try statement.execute(values: values)
    }

    public func execute(_ statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws {
        try statement.execute(namesAndValues: values)
    }

}
