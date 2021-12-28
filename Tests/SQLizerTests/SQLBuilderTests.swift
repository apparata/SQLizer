import XCTest
@testable import SQLizer

final class SQLBuilderTests: XCTestCase {
        
    // MARK: - Table Builder
    
    func testTableBuilder() {

        let table = SQLTable("CountryValues") {
            SQLColumn("countryID", String.self).notNull()
            SQLColumn("categoryID", Int.self).notNull()
            SQLColumn("year", Int.self).notNull()
            SQLColumn("value", Double.self).notNull()
        }
        .primaryKey("countryID", "categoryID", "year", onConflict: .replace)

        let sql: SQL = SQL.createTable(table)
        
        print(sql.string)
    }
    
    // MARK: - View Builder

    func testViewBuilder() {
        let view = SQLView("MyView", as: "SELECT countryID, year FROM CountryValues") {
            SQLColumn("myCountryID", String.self).notNull()
            SQLColumn("myYear", Int.self).notNull()
        }

        let sql: SQL = SQL.createView(view)
        
        print(sql.string)
    }

    func testViewBuilderWithoutColumns() {
        let view = SQLView("MyView", as: "SELECT countryID, year FROM CountryValues")

        let sql: SQL = SQL.createView(view)
        
        print(sql.string)
    }

}
