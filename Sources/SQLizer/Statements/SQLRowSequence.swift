import Foundation

public struct SQLRowSequence: AsyncSequence, AsyncIteratorProtocol {
    
    public typealias AsyncIterator = SQLRowSequence
    
    public typealias Element = SQLRow
    
    private weak var statement: SQLStatement?
    
    private var validForIteration: SQLStatement.Iteration
        
    internal init(for statement: SQLStatement, validForIteration: SQLStatement.Iteration) {
        self.statement = statement
        self.validForIteration = validForIteration
    }
    
    public func makeAsyncIterator() -> SQLRowSequence {
        self
    }
    
    /// Returns `nil` if there are no rows left or if the statement has been reset.
    public mutating func next() async throws -> SQLRow? {
        try await statement?.nextRowForIteration(validForIteration)
    }
}
