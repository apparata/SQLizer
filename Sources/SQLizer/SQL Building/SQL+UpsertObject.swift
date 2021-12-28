//
//  Copyright © 2021 Apparata AB. All rights reserved.
//

import Foundation

extension SQL {
    
    public static func upsertObject<T: SQLRowRepresentable>(ofType type: T.Type) -> SQL {
        
        return makeSQL {
            "INSERT OR REPLACE INTO"
            T.sqlTable.name
            "VALUES ("
            T.sqlTable.columns
                .map { column in
                    ":" + column.name
                }
                .joined(separator: ", ")
            ");"
        }
    }
}
