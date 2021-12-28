//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

public protocol SQLTableColumn {
    var name: String { get }
    var dataType: SQLColumnCompatibleType.Type { get }
    var notNullable: Bool { get }
    var notNullableOnConflict: SQLConflictResolutionType? { get }
    var defaultToAsString: String? { get }
    var collationName: String? { get }
    var generatedAsExpression: SQL? { get }
    var generatedAsStored: Bool { get }
}

// MARK: - SQLColumn

public struct SQLColumn<T: SQLColumnCompatibleType> {
    
    public let name: SQLColumnName
    public let type: T.Type
    public private(set) var constraints: Constraints
    
    public init(_ name: SQLColumnName, _ type: T.Type) {
        self.name = name
        self.type = type
        self.constraints = Constraints()
    }
    
    public func notNull(onConflict: SQLConflictResolutionType? = nil) -> SQLColumn {
        let notNullable = NotNullable(onConflict: onConflict)
        let newConstraints = constraints.replacing(\.notNull, with: notNullable)
        return replacing(\.constraints, with: newConstraints)
    }
        
    public func defaultTo(_ value: T) -> SQLColumn {
        replacingConstraint(\.defaultTo, with: .value(value))
    }
    
    public func defaultTo(_ expression: SQL) -> SQLColumn {
        replacingConstraint(\.defaultTo, with: .expression(expression))
    }
        
    public func collateUsing(_ collationName: String) -> SQLColumn {
        replacingConstraint(\.collationName, with: collationName)
    }
    
    public func generatedAs(_ expression: SQL, store: Bool = false) -> SQLColumn {
        let generatedAs = GeneratedAs(expression: expression, isStored: store)
        return replacingConstraint(\.generatedAs, with: generatedAs)
    }
}

extension SQLColumn: SQLTableColumn {
    public var dataType: SQLColumnCompatibleType.Type {
        type as SQLColumnCompatibleType.Type
    }
    
    public var notNullable: Bool { constraints.notNull != nil }
    public var notNullableOnConflict: SQLConflictResolutionType? { constraints.notNull?.onConflict }
    public var collationName: String? { constraints.collationName }
    public var generatedAsExpression: SQL? { constraints.generatedAs?.expression }
    public var generatedAsStored: Bool { constraints.generatedAs?.isStored ?? false }
    public var defaultToAsString: String? {
        switch constraints.defaultTo {
        case .value(let value): return value.queryStringValue
        case .expression(let expression): return "(\(expression))"
        case .none: return nil
        }
    }
}

// MARK: - Constraints

extension SQLColumn {
    public struct Constraints {
        public var notNull: NotNullable?
        public var defaultTo: DefaultTo?
        public var collationName: String?
        public var generatedAs: GeneratedAs?
    }
}

extension SQLColumn {
    public struct NotNullable {
        public let onConflict: SQLConflictResolutionType?
    }
}

extension SQLColumn {
    public enum DefaultTo {
        case value(T)
        case expression(SQL)
    }
}

extension SQLColumn {
    public struct GeneratedAs {
        public var expression: SQL
        public var isStored: Bool
    }
}

// MARK: - Extensions

extension SQLColumn: KeyPathReplaceable {
    private func replacingConstraint<LeafType>(_ keyPath: WritableKeyPath<Constraints, LeafType>, with value: LeafType) -> SQLColumn {
        replacing(\.constraints, with: constraints.replacing(keyPath, with: value))
    }
}

extension SQLColumn.Constraints: KeyPathReplaceable { }
