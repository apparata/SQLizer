import Foundation

public typealias SQLViewName = String

// MARK: - SQLView

public struct SQLView {
                
    public let name: SQLViewName
    public let columns: [SQLTableColumn]
    public let selectStatement: SQL
    public private(set) var schemaName: String?
    
    public init(_ name: SQLTableName, as selectStatement: SQL, @SQLTableBuilder columns: () -> [SQLTableColumn]) {
        self.name = name
        self.columns = columns()
        self.selectStatement = selectStatement
    }

    public init(_ name: SQLTableName, as selectStatement: SQL) {
        self.name = name
        self.columns = []
        self.selectStatement = selectStatement
    }
    
    public func schema(_ name: String) -> SQLView {
        replacing(\.schemaName, with: name)
    }
}

// MARK: - Extensions

extension SQLView: KeyPathReplaceable { }
