import ComposableArchitecture
import Foundation

public struct Item: Equatable, Identifiable, Hashable {
    public var id: UUID

    public var title: String
    public var notes: String
    public var urgent: Bool
    public var important: Bool
    public var created: Date = Date()

    public init(id: UUID, title: String, notes: String = "Test Notes", urgent: Bool, important: Bool) {
        self.id = id
        self.title = title
        self.notes = notes
        self.urgent = urgent
        self.important = important
    }
}

public struct Items: ReducerProtocol {
    public enum Action: Equatable {
        case addItem(Item)
        case updateItem(Item)
        case removeItem(Item)
        case startEditingItem(Item)
        case stopEditingItem(Item)
        case closeEditingItem
        case startCreatingNewItem(Bool, Bool)
    }

    public struct State: Equatable {
        public var items: IdentifiedArrayOf<Item> = []

        public var editingItem: UUID?
        public var placeholderItem: UUID?

        public init(items: IdentifiedArrayOf<Item>) {
            self.items = items
        }
    }

    public init() {}

    public var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case let .addItem(item):
                state.items.append(item)
                return .none
            case let .updateItem(item):
                state.items[id: item.id] = item
                return .none
            case let .removeItem(item):
                state.items.remove(id: item.id)
                return .none
            case let .startEditingItem(item):
                state.editingItem = item.id
                return .none
            case let .stopEditingItem(item):
                if item.id == state.placeholderItem {
                    // Clean up placeholder item by removing it
                    state.items.remove(id: item.id)
                    state.placeholderItem = nil
                }
                state.editingItem = nil
                return .none
            case let .startCreatingNewItem(important, urgent):
                guard state.editingItem == nil else { return .none }
                let item = Item(id: UUID(), title: "", urgent: urgent, important: important)
                state.placeholderItem = item.id
                state.editingItem = item.id

                state.items.append(item)

                return .none
            case .closeEditingItem:
                if let placeholder = state.placeholderItem {
                    let item = state.items[id: placeholder]
                    if let item = state.items[id: placeholder], item.title.isEmpty {
                        state.items.remove(id: placeholder)
                    }
                    state.placeholderItem = nil
                }
                state.editingItem = nil
                return .none
            }
        }
    }
}

public extension Items.State {
    static var mock: Self {
        return .init(items: [
            Item(id: UUID(),
                 title: "Urgent & Important",
                 urgent: true,
                 important: true),
            Item(id: UUID(),
                 title: "Urgent & Not Important",
                 urgent: true,
                 important: false),
            Item(id: UUID(),
                 title: "Important & Not Urgent",
                 urgent: false,
                 important: true),
            Item(id: UUID(),
                 title: "Not Important & Not Urgent",
                 urgent: false,
                 important: false)
        ])
    }
}
