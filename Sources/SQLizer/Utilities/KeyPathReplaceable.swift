//
//  Copyright © 2020 Apparata AB. All rights reserved.
//

import Foundation

func replacing<T, U>(_ keyPath: WritableKeyPath<T, U>, on object: T, with value: U) -> T {
    var newObject = object
    newObject[keyPath: keyPath] = value
    return newObject
}

protocol KeyPathReplaceable {
    
    /// Example:
    ///
    /// ```
    /// struct User: KeyPathReplaceable {
    ///     var name: String
    ///     var email: String
    /// }
    ///
    /// let user = User(name: "Luke", email: "luke@mailinator.com")
    /// let updatedUser = user.replacing(\.email, with: "luke1337@mailinator.com")
    /// ```
    func replacing<LeafType>(_ keyPath: WritableKeyPath<Self, LeafType>, with value: LeafType) -> Self
}

extension KeyPathReplaceable {
    func replacing<LeafType>(_ keyPath: WritableKeyPath<Self, LeafType>, with value: LeafType) -> Self {
        SQLizer.replacing(keyPath, on: self, with: value)
    }
}
