//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

@SQLActor
extension SQLDB {
        
    public func fetchSchemaVersion() throws -> Int {
        if let row = try prepareStatement("PRAGMA user_version").fetchRow() {
            if let value = try row.value(at: 0, as: Int.self) {
                return value
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
}
