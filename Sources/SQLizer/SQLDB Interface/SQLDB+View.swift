import Foundation

@SQLActor
extension SQLDB {

    public func createView(_ view: SQLView, options: SQLCreateViewOptions = []) throws {
        try execute(SQL.createView(view, options: options))
    }
    
    public func dropView(_ view: SQLView, options: SQLDropOptions = []) throws {
        try execute(SQL.dropView(view, options: options))
    }
}
