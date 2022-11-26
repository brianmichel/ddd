import Foundation

public struct Item: Codable, Equatable, Identifiable, Hashable {
    public var id: UUID

    public var title: String
    public var notes: String?
    public var completed: Bool
    public var urgent: Bool
    public var important: Bool
    public var created: Date = Date()

    public init(id: UUID, title: String, notes: String? = nil, completed: Bool = false, urgent: Bool, important: Bool, created: Date = Date()) {
        self.id = id
        self.title = title
        self.notes = notes
        self.completed = completed
        self.urgent = urgent
        self.important = important
        self.created = created
    }
}
