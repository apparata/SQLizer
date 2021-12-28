//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation
import libsqlite3

public typealias SQLErrorCode = Int32

public enum SQLErrorType {
    case failedToOpenDatabase
    case cannotToMigrateToEarlierSchemaVersion
    case failedToPrepareStatement
    case failedToStepStatement
    case failedToBindValueToStatement
    case failedToResetStatement
    case failedToExecute
    case noValueForColumn
    case valueForColumnIsNull
}

public struct SQLError: Error {
    public let type: SQLErrorType
    public let code: SQLErrorCode
    public let message: String
    
    internal init(_ type: SQLErrorType, db: SQLDatabaseID) {
        self.type = type
        self.code = sqlite3_errcode(db)
        self.message = String(cString: sqlite3_errmsg(db))
    }
    
    private init(_ type: SQLErrorType, message: String) {
        self.type = type
        self.code = SQLITE_INTERNAL
        self.message = message
    }

    // MARK: - Errors
    
    static func failedToOpenDatabase(_ db: SQLDatabaseID) -> Self {
        return Self(.failedToOpenDatabase, db: db)
    }

    static func failedToOpenDatabase(at path: String) -> Self {
        return Self(.failedToOpenDatabase, message: "Failed to open database at \(path)")
    }

    static func cannotMigrateToEarlierSchemaVersion() -> Self {
        return Self(.cannotToMigrateToEarlierSchemaVersion, message: "Database format is from a more recent version.")
    }
    
    static func failedToPrepareStatement(_ db: SQLDatabaseID) -> Self {
        return Self(.failedToPrepareStatement, db: db)
    }

    static func failedToPrepareStatement(_ message: String) -> Self {
        return Self(.failedToPrepareStatement, message: message)
    }
    
    static func failedToStepStatement(_ db: SQLDatabaseID) -> Self {
        return Self(.failedToPrepareStatement, db: db)
    }

    static func failedToBindValueToStatement(_ db: SQLDatabaseID) -> Self {
        return Self(.failedToPrepareStatement, db: db)
    }

    static func failedToBindValueToStatementAsThereIsNoParameterNamed(_ name: String) -> Self {
        return Self(.failedToPrepareStatement, message: "There is no matching parameter '\(name)'.")
    }
    
    static func noValueForColumn(_ column: String) -> Self {
        return Self(.noValueForColumn, message: "There is no value for the column '\(column)'.")
    }

    static func valueForColumnIsNull(_ column: String) -> Self {
        return Self(.valueForColumnIsNull, message: "The value for the column '\(column)' is <null>.")
    }

    static func valueForColumnIsNull(_ columnIndex: Int) -> Self {
        return Self(.valueForColumnIsNull, message: "The value for the column at index \(columnIndex) is <null>.")
    }
}
