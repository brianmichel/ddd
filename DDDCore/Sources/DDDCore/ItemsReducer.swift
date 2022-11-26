import ComposableArchitecture
import DatabaseClient
import Foundation
import Models

public struct Items: ReducerProtocol {
    public enum Action: Equatable {
        case fetchAll
        case fetchAllResponse(TaskResult<[Item]?>)
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

    @Dependency(\.itemsDB) var itemsDB

    public init() {}

    public var body: some ReducerProtocolOf<Self> {
        Reduce { state, action in
            switch action {
            case .fetchAll:
                return .task {
                    await .fetchAllResponse(
                        TaskResult(catching: {
                            try await itemsDB.all()
                        })
                    )
                }
            case let .fetchAllResponse(.success(result)):
                if let items = result {
                    state.items = IdentifiedArray(uniqueElements: items)
                }
                return .none
            case let .addItem(item):
                state.items.append(item)
                return .fireAndForget {
                    try? await itemsDB.insert(item)
                }
            case let .updateItem(item):
                state.items[id: item.id] = item
                return .fireAndForget {
                    try? await itemsDB.update(item)
                }
            case let .removeItem(item):
                state.items.remove(id: item.id)
                return .fireAndForget {
                    try? await itemsDB.delete(item)
                }
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
                var effects: [EffectPublisher<Items.Action, Never>] = []
                // If we were editing an new, pending item it could be the placeholder
                if let placeholder = state.placeholderItem,
                    let item = state.items[id: placeholder] {
                    // If there's an item for the placeholder and it's title is empty, delete it
                    if item.title.isEmpty {
                        state.items.remove(id: placeholder)
                    }
                    state.placeholderItem = nil
                    effects.append(.fireAndForget {
                        try? await itemsDB.insert(item)
                    })
                }
                state.editingItem = nil
                return .merge(effects)
            case .fetchAllResponse:
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
