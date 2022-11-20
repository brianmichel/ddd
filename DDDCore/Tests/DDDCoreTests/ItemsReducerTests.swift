import XCTest
import ComposableArchitecture
@testable import DDDCore

@MainActor
final class ItemsReducerTests: XCTestCase {
    
    func test_addingItemAddsItem() async {
        let state: ItemsReducer.State = .init(items: [])
        let store = TestStore(initialState: state, reducer: ItemsReducer())

        let item = Item(id: UUID(), title: "Hello", urgent: false, important: false)
        await store.send(.addItem(item)) {
            $0.items.append(item)
        }

        XCTAssert(store.state.items.count == 1, "The store should have 1 item in it.")
    }

    func test_removingItemsRemovesItem() async {
        let state: ItemsReducer.State = .init(items: [])
        let store = TestStore(initialState: state, reducer: ItemsReducer())

        let item = Item(id: UUID(), title: "Hello", urgent: false, important: false)

        await store.send(.addItem(item)) {
            $0.items.append(item)
        }

        await store.send(.removeItem(item)) {
            $0.items.remove(id: item.id)
        }

        XCTAssert(store.state.items.count == 0, "There should be no items in the store.")
    }

    func test_updatingItemsShouldUpdateThem() async {
        let state: ItemsReducer.State = .init(items: [])
        let store = TestStore(initialState: state, reducer: ItemsReducer())

        var item = Item(id: UUID(), title: "Hello", urgent: false, important: false)

        await store.send(.addItem(item)) {
            $0.items.append(item)
        }

        XCTAssertFalse(store.state.items.first!.important, "The item should start off as false")

        item.important = true

        await store.send(.updateItem(item)) {
            $0.items[id: item.id] = item
        }

        XCTAssertTrue(store.state.items.first!.important, "The item should end as true")
    }

}
