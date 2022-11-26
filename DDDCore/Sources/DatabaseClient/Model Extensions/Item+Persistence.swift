import Foundation
import GRDB
import Models

extension Item: PersistableRecord, FetchableRecord {
    static func all(db: Database) throws -> [Item] {
        return try Item
            .order(Column("created").desc)
            .fetchAll(db)
    }
}
