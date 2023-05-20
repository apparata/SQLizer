import Foundation
import libsqlite3

private let SQLITE_STATIC = unsafeBitCast(0, to: sqlite3_destructor_type.self)
private let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

internal extension SQLStatement {
        
    struct Binder {
    
        private let id: SQLStatementID
        private let db: SQLDatabaseID

        init(id: SQLStatementID, db: SQLDatabaseID) {
            self.id = id
            self.db = db
        }
        
        // MARK: - Indexed Parameters
    
        func bindText(_ text: String, at index: Int) throws {
            try sqlite3_bind_text(id, oneBased(from: index), text, -1, SQLITE_TRANSIENT)
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }

        func bindInt(_ value: Int, at index: Int) throws {
            try sqlite3_bind_int64(id, oneBased(from: index), Int64(value))
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }
        
        func bindDouble(_ value: Double, at index: Int) throws {
            try sqlite3_bind_double(id, oneBased(from: index), value)
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }
        
        func bindBlob(_ data: Data, at index: Int) throws {
            _ = try data.withUnsafeBytes { (bytes) -> Bool in
                try sqlite3_bind_blob(id, oneBased(from: index), bytes.baseAddress, Int32(data.count), SQLITE_TRANSIENT)
                    .throwIfNotOK(.failedToBindValueToStatement, db)
                return true
            }
        }
        
        func bindNull(at index: Int) throws {
            try sqlite3_bind_null(id, oneBased(from: index))
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }

        // MARK: - Named Parameters
        
        func bindText(_ text: String, to parameterName: String, isOptional: Bool = false) throws {
            let index: Int32
            if isOptional {
                guard let optionalIndex = indexOfOptionalParameterNamed(parameterName) else {
                    return
                }
                index = optionalIndex
            } else {
                index = try indexOfParameterNamed(parameterName)
            }
            try sqlite3_bind_text(id, index, text, -1, SQLITE_TRANSIENT)
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }

        func bindInt(_ value: Int, to parameterName: String, isOptional: Bool = false) throws {
            let index: Int32
            if isOptional {
                guard let optionalIndex = indexOfOptionalParameterNamed(parameterName) else {
                    return
                }
                index = optionalIndex
            } else {
                index = try indexOfParameterNamed(parameterName)
            }
            try sqlite3_bind_int64(id, index, Int64(value))
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }
        
        func bindDouble(_ value: Double, to parameterName: String, isOptional: Bool = false) throws {
            let index: Int32
            if isOptional {
                guard let optionalIndex = indexOfOptionalParameterNamed(parameterName) else {
                    return
                }
                index = optionalIndex
            } else {
                index = try indexOfParameterNamed(parameterName)
            }
            try sqlite3_bind_double(id, index, value)
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }
        
        func bindBlob(_ data: Data, to parameterName: String, isOptional: Bool = false) throws {
            let index: Int32
            if isOptional {
                guard let optionalIndex = indexOfOptionalParameterNamed(parameterName) else {
                    return
                }
                index = optionalIndex
            } else {
                index = try indexOfParameterNamed(parameterName)
            }
            _ = try data.withUnsafeBytes { (bytes) -> Bool in
                try sqlite3_bind_blob(id, index, bytes.baseAddress, Int32(data.count), SQLITE_TRANSIENT)
                    .throwIfNotOK(.failedToBindValueToStatement, db)
                return true
            }
        }
        
        func bindNull(to parameterName: String, isOptional: Bool = false) throws {
            let index: Int32
            if isOptional {
                guard let optionalIndex = indexOfOptionalParameterNamed(parameterName) else {
                    return
                }
                index = optionalIndex
            } else {
                index = try indexOfParameterNamed(parameterName)
            }
            try sqlite3_bind_null(id, index)
                .throwIfNotOK(.failedToBindValueToStatement, db)
        }
        
        // MARK: - Helpers
        
        private func indexOfParameterNamed(_ name: String) throws -> Int32 {
            let index = sqlite3_bind_parameter_index(id, ":" + name)
            guard index > 0 else {
                throw SQLError.failedToBindValueToStatementAsThereIsNoParameterNamed(name)
            }
            return index
        }

        private func indexOfOptionalParameterNamed(_ name: String) -> Int32? {
            let index = sqlite3_bind_parameter_index(id, ":" + name)
            guard index > 0 else {
                return nil
            }
            return index
        }
        
        private func oneBased(from zeroBasedIndex: Int) -> Int32 {
            return Int32(zeroBasedIndex + 1)
        }
    }
}
