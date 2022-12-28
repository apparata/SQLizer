//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {

    // MARK: - Fetch Object Sequence
    
    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using sql: SQL) throws -> SQLObjectSequence<T> {
        try fetchObjectSequence(type: type, using: prepare(sql))
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using sql: SQL, values: SQLValue...) throws -> SQLObjectSequence<T> {
        try fetchObjectSequence(type: type, using: sql, values: values)
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using sql: SQL, values: [SQLValue]) throws -> SQLObjectSequence<T> {
        try fetchObjectSequence(type: type, using: prepare(sql), values: values)
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using sql: SQL, values: [SQLColumnCompatibleType?]) throws -> SQLObjectSequence<T> {
        try fetchObjectSequence(type: type, using: prepare(sql), values: values)
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using sql: SQL, values: [String: SQLColumnCompatibleType?]) throws -> SQLObjectSequence<T> {
        try fetchObjectSequence(type: type, using: prepare(sql), values: values)
    }
    
    // MARK: - Fetch Object Sequence Statement
    
    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using statement: SQLStatement) throws -> SQLObjectSequence<T> {
        try statement.fetchObjectSequence()
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using statement: SQLStatement, values: SQLValue...) throws -> SQLObjectSequence<T> {
        try fetchObjectSequence(type: type, using: statement, values: values)
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using statement: SQLStatement, values: [SQLValue]) throws -> SQLObjectSequence<T> {
        try statement.fetchObjectSequence(values: values)
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using statement: SQLStatement, values: [SQLColumnCompatibleType?]) throws -> SQLObjectSequence<T> {
        try statement.fetchObjectSequence(values: values)
    }

    public func fetchObjectSequence<T: SQLRowRepresentable>(type: T.Type, using statement: SQLStatement, values: [String: SQLColumnCompatibleType?]) throws -> SQLObjectSequence<T> {
        try statement.fetchObjectSequence(namesAndValues: values)
    }
}
