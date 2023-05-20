import Foundation

/// The SQLDB is the context the client of SQLizer will have access to for performing queries.
///
/// The idea is that the SQLDB object only exists for as long as the ``SQLDatabase/run(_:)`` or
/// ``SQLDatabase/transaction(_:)`` scope exists. It can thus safely cache prepared statements.
///
@SQLActor
public class SQLDB {
        
    private let statementManager: SQLStatementManager
    
    private var statementCache: [SQL: SQLStatement] = [:]
    
    internal init(statementManager: SQLStatementManager) {
        self.statementManager = statementManager
    }
        
    // MARK: - Prepare Statement
    
    public func prepare(_ sql: SQL) throws -> SQLStatement {
        if let cachedStatement = statementCache[sql] {
            return cachedStatement
        }
        let statement = try statementManager.prepare(sql)
        statementCache[sql] = statement
        return statement
    }
}
