import XCTest
@testable import SQLizer

final class SQLObjectsTests: XCTestCase {
                
    func testCreateMoviesTable() async throws {
        
        let db = try await SQLDatabase.openInMemory { db in
            try db.createTable(Movie.sqlTable)
        }
        
        try await db.run { db in
            XCTAssertEqual(try db.fetchSchemaVersion(), 1)
        }
    }

    func testInsertMovie() async throws {
        
        let db = try await SQLDatabase.openInMemory { db in
            try db.createTable(Movie.sqlTable)
        }
        
        try await db.run { db in
            XCTAssertEqual(try db.fetchSchemaVersion(), 1)
        }
        
        let starWars = Movie(title: "Star Wars", releaseDate: Date(), duration: 123, rating: 5.0)
        let theMatrix = Movie(title: "The Matrix", releaseDate: Date(), duration: 135, rating: 5.0)
        
        try await db.transaction { db in
            try db.upsertObject(starWars)
            try db.upsertObject(theMatrix)
            return .commit
        }
        
        try await db.run { db in
            let movies = try db.fetchAllObjectsOfType(Movie.self)
            dump(movies)
        }
    }
}

@propertyWrapper
struct SQLColumnValue<T: SQLColumnCompatibleType> {

    let wrappedValue: T
}

// MARK: - Movie

struct Movie {
    var id: UUID
    var title: String
    var releaseDate: Date
    var duration: Int
    var rating: Double
    
    init(id: UUID = UUID(), title: String, releaseDate: Date, duration: Int, rating: Double) {
        self.id = id
        self.title = title
        self.releaseDate = releaseDate
        self.duration = duration
        self.rating = rating
    }
}

extension Movie: SQLRowRepresentable {
    
    struct Columns {
        static let id = SQLColumn("id", UUID.self).notNull()
        static let title = SQLColumn("title", String.self).notNull()
        static let releaseDate = SQLColumn("releaseDate", Date.self).notNull()
        static let duration = SQLColumn("duration", Int.self).notNull()
        static let rating = SQLColumn("rating", Double.self).notNull()
    }
        
    static var sqlTable: SQLTable {
        SQLTable("Movie") {
            Columns.id
            Columns.title
            Columns.releaseDate
            Columns.duration
            Columns.rating
        }
        .primaryKey(Columns.id, onConflict: .replace)
    }
        
    init(sqlRow: SQLRow) throws {
        id = try sqlRow.value(for: Columns.id)
        title = try sqlRow.value(for: Columns.title)
        releaseDate = try sqlRow.value(for: Columns.releaseDate)
        duration = try sqlRow.value(for: Columns.duration)
        rating = try sqlRow.value(for: Columns.rating)
    }
    
    func makeSQLNamesAndValues() throws -> [String: SQLColumnCompatibleType?] {
        return [
            Columns.id.name: id,
            Columns.title.name: title,
            Columns.releaseDate.name: releaseDate,
            Columns.duration.name: duration,
            Columns.rating.name: rating
        ]
    }
}
