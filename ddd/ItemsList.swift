//
//  ItemsList.swift
//  DDD
//
//  Created by Brian Michel on 11/20/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

enum ItemsListFilter {
    case all
    case urgentAndImportant
    case urgentAndNotImportant
    case notUrgentAndImportant
    case notUrgentAndNotImportant

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
            ScrollView {
                ForEach(viewStore.items.filter({ filter.included($0) })) { item in
                    let isEditing = viewStore.editingItem == item.id
                    ItemView(item: item, showMetadata: showMetadata, expanded: isEditing)
                        .onTapGesture(count: 2) {
                            let action: Items.Action = isEditing ? .stopEditingItem : .startEditingItem(item)
                            viewStore.send(action, animation: .easeInOut(duration: 0.2))
                        }
                        .opacity(opacticyForNonEditingItems(currentEditingItem: isEditing))
                }
                .padding(10)
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
