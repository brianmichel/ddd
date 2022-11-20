import ComposableArchitecture

public struct Application: ReducerProtocol {
    public init() {}

    public enum Action: Equatable {
        case items(Items.Action)
    }

    public struct State: Equatable {
        public var items: Items.State

        public init(items: Items.State = .init(items: .init())) {
            self.items = items
        }
    }

    public var body: some ReducerProtocolOf<Self> {
        Scope(state: \.items, action: /Action.items) {
            Items()
        }
    }
}
