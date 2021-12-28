//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

public struct SQLObjectSequence<T: SQLRowRepresentable>: AsyncSequence, AsyncIteratorProtocol {
    
    public typealias AsyncIterator = SQLObjectSequence
    
    public typealias Element = T
    
    private weak var statement: SQLStatement?
    
    private var validForIteration: SQLStatement.Iteration
        
    internal init(for statement: SQLStatement, validForIteration: SQLStatement.Iteration) {
        self.statement = statement
        self.validForIteration = validForIteration
    }
    
    public func makeAsyncIterator() -> SQLObjectSequence {
        self
    }
    
    /// Returns `nil` if there are no rows left or if the statement has been reset.
    public mutating func next() async throws -> T? {
        try await statement?.nextObjectForIteration(validForIteration)
    }
}
