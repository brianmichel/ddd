import Dependencies
import Foundation
import GRDB
import Models

public struct ItemsDatabaseClient {
    public let writer: DatabaseWriter

    public var insert: @Sendable (Item) async throws -> Void
    public var update: @Sendable (Item) async throws -> Void
    public var delete: @Sendable (Item) async throws -> Void
    public var all: @Sendable () async throws -> [Item]
}

extension ItemsDatabaseClient: DependencyKey {
    public static var liveValue: ItemsDatabaseClient {
        let fileManager = FileManager()
        let folderURL = try! fileManager
            .url(for: .applicationSupportDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
            .appendingPathComponent("db", isDirectory: true)

        try! fileManager.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)

        let dbURL = folderURL.appendingPathComponent("db")
        let writer = try! DatabasePool(path: dbURL.path)

        // Setup the schema and perform migrations as needed.
        try! DatabaseMigrator.DDDMigrator.migrate(writer)

        return ItemsDatabaseClient(
            writer: writer,
            insert: { item in
                try writer.write { db in
                    try item.save(db)
                }
            },
            update: { item in
                try writer.write { db in
                    try item.save(db)
                }
            },
            delete: { item in
                try writer.write { db in
                    _ = try item.delete(db)
                }
            },
            all: {
                try writer.read({ db in
                    let items = try Item.all(db: db)
                    return items
                })
            }
        )
    }
}

extension ItemsDatabaseClient: TestDependencyKey {
    public static var previewValue: ItemsDatabaseClient = .init(
        writer: try! DatabaseQueue(),
        insert: { _ in return },
        update: { _ in return },
        delete: { _ in return },
        all: { return [] }
    )

    public static var testValue: ItemsDatabaseClient = .previewValue
}

public extension DependencyValues {
    var itemsDB: ItemsDatabaseClient {
        get { self[ItemsDatabaseClient.self] }
        set { self[ItemsDatabaseClient.self] = newValue }
    }
}
