//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

internal typealias SQLStatementID = OpaquePointer

@SQLActor
public class SQLStatement {
    
    private enum StepResult {
        case done
        case row(SQLRow)
    }
    
    internal struct Iteration: Equatable {
        private var iteration: Int = 0
        
        mutating func markNew() {
            iteration += 1
        }
    }
    
    private let id: SQLStatementID
    
    private let db: SQLDatabaseID
    
    /// Changes when statement is reset.
    internal private(set) var iteration = Iteration()
        
    internal init(id: SQLStatementID, db: SQLDatabaseID) {
        self.id = id
        self.db = db
    }
    
    deinit {
        let status = sqlite3_finalize(id)
        guard status == SQLITE_OK else {
            logger.error(db)
            return
        }
    }
    
    // MARK: - Execute
    
    internal func execute() throws {
        try reset()
        try step()
    }
    
    internal func execute(values: [SQLValue]) throws {
        try reset()
        try bind(values: values)
        try step()
    }

    internal func execute(values: [SQLColumnCompatibleType?]) throws {
        try reset()
        try bind(values: values)
        try step()
    }

    internal func execute(namesAndValues: [String: SQLColumnCompatibleType?]) throws {
        try reset()
        try bind(namesAndValues: namesAndValues)
        try step()
    }
    
    internal func execute<T: SQLRowRepresentable>(object: T) throws {
        try reset()
        try bind(object: object)
        try step()
    }
    
    // MARK: - Fetch Row
    
    internal func fetchRow() throws -> SQLRow? {
        try reset()
        return try nextRow()
    }

    internal func fetchRow(values: [SQLValue]) throws -> SQLRow? {
        try reset()
        try bind(values: values)
        return try nextRow()
    }

    internal func fetchRow(values: [SQLColumnCompatibleType?]) throws -> SQLRow? {
        try reset()
        try bind(values: values)
        return try nextRow()
    }
    
    internal func fetchRow(namesAndValues: [String: SQLColumnCompatibleType?]) throws -> SQLRow? {
        try reset()
        try bind(namesAndValues: namesAndValues)
        return try nextRow()
    }
    
    // MARK: - Fetch Row Object
    
    internal func fetchObject<T: SQLRowRepresentable>() throws -> T? {
        try reset()
        return try nextRow().map(T.init)
    }

    internal func fetchObject<T: SQLRowRepresentable>(values: [SQLValue]) throws -> T? {
        try reset()
        try bind(values: values)
        return try nextRow().map(T.init)
    }

    internal func fetchObject<T: SQLRowRepresentable>(values: [SQLColumnCompatibleType?]) throws -> T? {
        try reset()
        try bind(values: values)
        return try nextRow().map(T.init)
    }

    internal func fetchObject<T: SQLRowRepresentable>(namesAndValues: [String: SQLColumnCompatibleType?]) throws -> T? {
        try reset()
        try bind(namesAndValues: namesAndValues)
        return try nextRow().map(T.init)
    }
    
    // MARK: - Fetch All Rows

    internal func fetchAllRows() throws -> [SQLRow] {
        try reset()
        return try allRows()
    }

    internal func fetchAllRows(values: [SQLValue]) throws -> [SQLRow] {
        try reset()
        try bind(values: values)
        return try allRows()
    }

    internal func fetchAllRows(values: [SQLColumnCompatibleType?]) throws -> [SQLRow] {
        try reset()
        try bind(values: values)
        return try allRows()
    }

    internal func fetchAllRows(namesAndValues: [String: SQLColumnCompatibleType?]) throws -> [SQLRow] {
        try reset()
        try bind(namesAndValues: namesAndValues)
        return try allRows()
    }

    
    // MARK: - Fetch All Row Objects

    internal func fetchAllObjects<T: SQLRowRepresentable>() throws -> [T] {
        try reset()
        return try allRowObjects()
    }

    internal func fetchAllObjects<T: SQLRowRepresentable>(values: [SQLValue]) throws -> [T] {
        try reset()
        try bind(values: values)
        return try allRowObjects()
    }

    internal func fetchAllObjects<T: SQLRowRepresentable>(values: [SQLColumnCompatibleType?]) throws -> [T] {
        try reset()
        try bind(values: values)
        return try allRowObjects()
    }
    
    internal func fetchAllObjects<T: SQLRowRepresentable>(namesAndValues: [String: SQLColumnCompatibleType?]) throws -> [T] {
        try reset()
        try bind(namesAndValues: namesAndValues)
        return try allRowObjects()
    }
    
    // MARK: - Fetch Rows Sequence
    
    internal func fetchRowSequence() throws -> SQLRowSequence {
        try reset()
        return try rows()
    }

    internal func fetchRowSequence(values: [SQLValue]) throws -> SQLRowSequence {
        try reset()
        try bind(values: values)
        return try rows()
    }

    internal func fetchRowSequence(values: [SQLColumnCompatibleType?]) throws -> SQLRowSequence {
        try reset()
        try bind(values: values)
        return try rows()
    }

    internal func fetchRowSequence(namesAndValues: [String: SQLColumnCompatibleType?]) throws -> SQLRowSequence {
        try reset()
        try bind(namesAndValues: namesAndValues)
        return try rows()
    }
    
    // MARK: - Fetch Objects Sequence
    
    internal func fetchObjectSequence<T: SQLRowRepresentable>() throws -> SQLObjectSequence<T> {
        try reset()
        return try rowObjects()
    }

    internal func fetchObjectSequence<T: SQLRowRepresentable>(values: [SQLValue]) throws -> SQLObjectSequence<T> {
        try reset()
        try bind(values: values)
        return try rowObjects()
    }

    internal func fetchObjectSequence<T: SQLRowRepresentable>(values: [SQLColumnCompatibleType?]) throws -> SQLObjectSequence<T> {
        try reset()
        try bind(values: values)
        return try rowObjects()
    }

    internal func fetchObjectSequence<T: SQLRowRepresentable>(namesAndValues: [String: SQLColumnCompatibleType?]) throws -> SQLObjectSequence<T> {
        try reset()
        try bind(namesAndValues: namesAndValues)
        return try rowObjects()
    }
    
    // MARK: - Next Row
    
    internal func nextRow() throws -> SQLRow? {
        switch try step() {
        case .done: return nil
        case .row(let row): return row
        }
    }
    
    internal func nextRowForIteration(_ iteration: Iteration) throws -> SQLRow? {
        guard self.iteration == iteration else {
            return nil
        }
        switch try step() {
        case .done: return nil
        case .row(let row): return row
        }
    }

    // MARK: - Next Object
    
    internal func nextObject<T: SQLRowRepresentable>() throws -> T? {
        switch try step() {
        case .done: return nil
        case .row(let row): return try T(sqlRow: row)
        }
    }
    
    internal func nextObjectForIteration<T: SQLRowRepresentable>(_ iteration: Iteration) throws -> T? {
        guard self.iteration == iteration else {
            return nil
        }
        switch try step() {
        case .done: return nil
        case .row(let row): return try T(sqlRow: row)
        }
    }

    
    // MARK: - All Rows
    
    private func allRows() throws -> [SQLRow] {
        return try stepAllRows()
    }

    // MARK: - All Row Objects
    
    private func allRowObjects<T: SQLRowRepresentable>() throws -> [T] {
        return try stepAllRows().compactMap(T.init)
    }
    
    // MARK: - Rows as Sequence
    
    private func rows() throws -> SQLRowSequence {
        SQLRowSequence(for: self, validForIteration: iteration)
    }

    // MARK: - Rows as Object Sequence
    
    private func rowObjects<T: SQLRowRepresentable>() throws -> SQLObjectSequence<T> {
        SQLObjectSequence(for: self, validForIteration: iteration)
    }
    
    // MARK: - Reset
    
    private func reset() throws {
        iteration.markNew()
        try sqlite3_reset(id)
            .throwIfNotOK(.failedToResetStatement, db)
    }
    
    // MARK: - Bind
        
    private func bind(values: [SQLValue]) throws {
        let binder = Binder(id: id, db: db)
        for index in 0..<values.count {
            switch values[index] {
            case .text(let text): try binder.bindText(text, at: index)
            case .int(let value): try binder.bindInt(value, at: index)
            case .double(let value): try binder.bindDouble(value, at: index)
            case .blob(let data): try binder.bindBlob(data, at: index)
            case .null: try binder.bindNull(at: index)
            }
        }
    }
    
    private func bind(values: [SQLColumnCompatibleType?]) throws {
        let binder = Binder(id: id, db: db)
        for index in 0..<values.count {
            switch values[index]?.asSQLValue {
            case .text(let text): try binder.bindText(text, at: index)
            case .int(let value): try binder.bindInt(value, at: index)
            case .double(let value): try binder.bindDouble(value, at: index)
            case .blob(let data): try binder.bindBlob(data, at: index)
            case .null: try binder.bindNull(at: index)
            default: try binder.bindNull(at: index)
            }
        }
    }

    private func bind(namesAndValues: [String: SQLColumnCompatibleType?], optionalParameters: Bool = false) throws {
        let binder = Binder(id: id, db: db)
        for (name, value) in namesAndValues {
            do {
                let sqlValue = value?.asSQLValue
                switch sqlValue {
                case .text(let string): try binder.bindText(string, to: name, isOptional: optionalParameters)
                case .int(let number): try binder.bindInt(number, to: name, isOptional: optionalParameters)
                case .double(let number): try binder.bindDouble(number, to: name, isOptional: optionalParameters)
                case .blob(let data): try binder.bindBlob(data, to: name, isOptional: optionalParameters)
                case .null: try binder.bindNull(to: name, isOptional: optionalParameters)
                default: try binder.bindNull(to: name, isOptional: optionalParameters)
                }
            } catch {
                print("Failed to bind value '\(String(describing: value))' to '\(name)'")
                dump(error)
                throw error
            }
        }
    }
    
    private func bind<T: SQLRowRepresentable>(object: T) throws {
        try bind(namesAndValues: object.makeSQLNamesAndValues(), optionalParameters: true)
    }

    // MARK: - Step
    
    @discardableResult
    private func step() throws -> StepResult {
        let result = sqlite3_step(id)
        switch result {
        case SQLITE_DONE:
            return .done
        case SQLITE_ROW:
            return .row(try fetchCurrentRow())
        default:
            throw SQLError.failedToStepStatement(db)
        }
    }
    
    // MARK: - Step All Rows
    
    public func stepAllRows() throws -> [SQLRow] {
        var rows = [SQLRow]()
        
        loop: while true {
            switch try step() {
            case .done:
                break loop
            case .row(let row):
                rows.append(row)
            }
        }
        
        return rows
    }
    
    // MARK: - Fetch Current Row
    
    private func fetchCurrentRow() throws -> SQLRow {
        
        let columnCount = sqlite3_column_count(id)
        guard columnCount > 0 else {
            return SQLRow()
        }
        
        var row = SQLRow()
        
        for columnIndex in 0..<columnCount {
            let columnType = sqlite3_column_type(id, columnIndex)
            let value: SQLValue
            
            switch columnType {
            case SQLITE_INTEGER:
                value = .int(Int(sqlite3_column_int64(id, columnIndex)))
            case SQLITE_FLOAT:
                value = .double(sqlite3_column_double(id, columnIndex))
            case SQLITE_TEXT:
                if let text = sqlite3_column_text(id, columnIndex) {
                    value = .text(String(cString: text))
                } else {
                    value = .null
                }
            case SQLITE_BLOB:
                if let blob = sqlite3_column_blob(id, columnIndex) {
                    let byteCount = sqlite3_column_bytes(id, columnIndex)
                    if byteCount > 0 {
                        value = .blob(Data(bytes: blob, count: Int(byteCount)))
                    } else {
                        value = .null
                    }
                } else {
                    value = .null
                }
            case SQLITE_NULL:
                value = .null
            default:
                value = .null
            }
            
            let columnName: SQLColumnName
            if let rawColumnName = sqlite3_column_name(id, columnIndex) {
                columnName = String(cString: rawColumnName)
            } else {
                columnName = "Column \(columnIndex)"
            }
            
            row.addColumn(name: columnName, index: columnIndex, value: value)
        }
        
        return row
    }

}
