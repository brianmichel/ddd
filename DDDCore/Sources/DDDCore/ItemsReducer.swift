import ComposableArchitecture
import Foundation

public struct Item: Equatable, Identifiable, Hashable {
    public var id: UUID

    public var title: String
    public var urgent: Bool
    public var important: Bool

    public init(id: UUID, title: String, urgent: Bool, important: Bool) {
        self.id = id
        self.title = title
        self.urgent = urgent
        self.important = important
    }
}

public struct Items: ReducerProtocol {
    public enum Action: Equatable {
        case addItem(Item)
        case updateItem(Item)
        case removeItem(Item)
    }

    public struct State: Equatable {
        public var items: IdentifiedArrayOf<Item>

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
            }
        }
    }
}

public extension Items.State {
    static var mock: Self {
        return .init(items: [
            Item(id: UUID(), title: "Urgent & Important", urgent: true, important: true),
            Item(id: UUID(), title: "Urgent & Not Important", urgent: true, important: false),
            Item(id: UUID(), title: "Important & Not Urgent", urgent: false, important: true),
            Item(id: UUID(), title: "Not Important & Not Urgent", urgent: false, important: false)
        ])
    }
}
