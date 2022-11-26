//
//  ItemsList.swift
//  DDD
//
//  Created by Brian Michel on 11/20/22.
//

import ComposableArchitecture
import DDDCore
import Models
import SwiftUI

enum ItemsListFilter {
    case all
    case urgentAndImportant
    case urgentAndNotImportant
    case notUrgentAndImportant
    case notUrgentAndNotImportant

    var important: Bool {
        switch self {
        case .all, .urgentAndImportant, .notUrgentAndImportant:
            return true
        default:
            return false
        }
    }

    var urgent: Bool {
        switch self {
        case .all, .urgentAndImportant, .urgentAndNotImportant:
            return true
        default:
            return false
        }
    }

    func included(_ item: Item) -> Bool {
        switch self {
        case .all:
            return true
        case .urgentAndImportant:
            return item.urgent && item.important
        case .urgentAndNotImportant:
            return item.urgent && !item.important
        case .notUrgentAndImportant:
            return !item.urgent && item.important
        case .notUrgentAndNotImportant:
            return !item.urgent && !item.important
        }
    }
}

struct ItemsList: View {
    let store: StoreOf<Items>
    var filter: ItemsListFilter = .all

    var showMetadata = false

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                ScrollView {
                    ForEach(viewStore.items.filter({ filter.included($0) })) { item in
                        let isEditing = viewStore.editingItem == item.id
                        ItemView(item: item, viewStore: viewStore, showMetadata: showMetadata, expanded: isEditing)
                            .onTapGesture(count: 2) {
                                let action: Items.Action = isEditing ? .stopEditingItem(item) : .startEditingItem(item)
                                viewStore.send(action, animation: .easeInOut(duration: 0.2))
                            }
                            .opacity(opacticyForNonEditingItems(currentEditingItem: isEditing))
                    }
                    .padding(10)
                }
            }
            .onTapGesture(count: 2) {
                viewStore.send(.startCreatingNewItem(filter.important, filter.urgent), animation: .easeIn(duration: 0.2))
            }
            .onTapGesture(count: 1) {
                viewStore.send(.closeEditingItem, animation: .easeIn(duration: 0.2))
            }
        }
    }

    func opacticyForNonEditingItems(currentEditingItem: Bool) -> Double {
        let viewStore = ViewStore(store)

        if viewStore.editingItem == nil || currentEditingItem {
            return 1.0
        }

        return 0.6
    }
}

struct ItemsList_Previews: PreviewProvider {
    static var previews: some View {
        ItemsList(store: .init(initialState: .mock,
                               reducer: Items()))
    }
}
