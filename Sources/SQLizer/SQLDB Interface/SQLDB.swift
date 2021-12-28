//
//  Copyright © 2019 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
public class SQLDB {
        
    private let statementManager: SQLStatementManager
    
    internal init(statementManager: SQLStatementManager) {
        self.statementManager = statementManager
    }
        
    // MARK: - Prepare Statement
    
    @discardableResult
    public func prepareStatement(_ sql: SQL) throws -> SQLStatement {
        try statementManager.prepareStatement(sql)
    }
}
