import Foundation
import GRDB

extension DatabaseMigrator {
    static var DDDMigrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

#if DEBUG
        // Speed things up when working in DEBUG mode
        migrator.eraseDatabaseOnSchemaChange = true
#endif

        migrator.registerMigration("createItems") { db in
            try db.create(table: "item", body: { t in
                t.column("id", .text).notNull().primaryKey()
                t.column("title", .text).notNull()
                t.column("notes", .text)
                t.column("completed", .boolean).notNull()
                t.column("urgent", .boolean).notNull()
                t.column("important", .boolean).notNull()
                t.column("created", .datetime).notNull()
            })
        }

        return migrator
    }
}
