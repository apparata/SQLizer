import Foundation

public typealias SQLTableName = String

// MARK: - SQLTable

public struct SQLTable {
                
    public let name: SQLTableName
    public let columns: [SQLTableColumn]
    public let selectStatement: String?
    public private(set) var schemaName: String?
    public private(set) var constraints: Constraints
    
    /// This SQLTable will be based on columns.
    public init(_ name: SQLTableName, @SQLTableBuilder columns: () -> [SQLTableColumn]) {
        self.name = name
        self.columns = columns()
        selectStatement = nil
        constraints = Constraints()
    }
    
    /// This SQLTable will be based on a select statement.
    public init(_ name: SQLTableName, as selectStatement: String) {
        self.name = name
        columns = []
        self.selectStatement = selectStatement
        constraints = Constraints()
    }
    
    public func schema(_ name: String) -> SQLTable {
        replacing(\.schemaName, with: name)
    }
        
    public func primaryKey(_ columnNames: [SQLColumnName],
                           onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        let primaryKey = PrimaryKey(columns: columnNames, onConflict: onConflict)
        return replacingConstraint(\.primaryKey, with: primaryKey)
    }
    
    public func primaryKey(_ columnNames: SQLColumnName...,
                           onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        primaryKey(columnNames, onConflict: onConflict)
    }

    public func primaryKey(_ columns: [SQLTableColumn],
                           onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        let primaryKey = PrimaryKey(columns: columns, onConflict: onConflict)
        return replacingConstraint(\.primaryKey, with: primaryKey)
    }
    
    public func primaryKey(_ columns: SQLTableColumn...,
                           onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        primaryKey(columns, onConflict: onConflict)
    }

    public func unique(_ columnNames: [SQLColumnName],
                       onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        let uniqueColumns = UniqueColumns(columns: columnNames, onConflict: onConflict)
        return replacingConstraint(\.uniqueColumns, with: uniqueColumns)
    }
    
    public func unique(_ columnNames: SQLColumnName...,
                       onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        unique(columnNames, onConflict: onConflict)
    }

    public func unique(_ columns: [SQLTableColumn],
                       onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        let uniqueColumns = UniqueColumns(columns: columns, onConflict: onConflict)
        return replacingConstraint(\.uniqueColumns, with: uniqueColumns)
    }
    
    public func unique(_ columns: SQLTableColumn...,
                       onConflict: SQLConflictResolutionType? = nil) -> SQLTable {
        unique(columns, onConflict: onConflict)
    }

    
    public func check(_ expression: SQL) -> SQLTable {
        replacingConstraint(\.check, with: expression)
    }
}

// MARK: - Constraints

extension SQLTable {
    public struct Constraints {
        public var primaryKey: PrimaryKey?
        public var uniqueColumns: UniqueColumns?
        public var check: SQL?
    }
}

extension SQLTable {
    public struct PrimaryKey {
        public let columns: [SQLColumnName]
        public let onConflict: SQLConflictResolutionType?
        
        init(columns: [SQLColumnName], onConflict: SQLConflictResolutionType?) {
            self.columns = columns
            self.onConflict = onConflict
        }

        init(columns: [SQLTableColumn], onConflict: SQLConflictResolutionType?) {
            self.columns = columns.map { $0.name }
            self.onConflict = onConflict
        }
    }
}

extension SQLTable {
    public struct UniqueColumns {
        public let columns: [SQLColumnName]
        public let onConflict: SQLConflictResolutionType?

        init(columns: [SQLColumnName], onConflict: SQLConflictResolutionType?) {
            self.columns = columns
            self.onConflict = onConflict
        }

        init(columns: [SQLTableColumn], onConflict: SQLConflictResolutionType?) {
            self.columns = columns.map { $0.name }
            self.onConflict = onConflict
        }
    }
}

// MARK: - Extensions

extension SQLTable: KeyPathReplaceable {
    func replacingConstraint<LeafType>(_ keyPath: WritableKeyPath<Constraints, LeafType>, with value: LeafType) -> SQLTable {
        replacing(\.constraints, with: constraints.replacing(keyPath, with: value))
    }
}

extension SQLTable.Constraints: KeyPathReplaceable { }
