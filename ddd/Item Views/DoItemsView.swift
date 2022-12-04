//
//  DoItemsView.swift
//  DDD
//
//  Created by Brian Michel on 11/29/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

struct DoItemsView: View {
    let store: StoreOf<Items>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 0) {
                let filter: ItemsListFilter = .urgentAndImportant
                FilteredItemsView(store: store, title: "Do", filter: filter)
                ItemsToolbar {
                    Button(action: {
                        viewStore.send(.startCreatingNewItem(filter.important, filter.urgent),
                                       animation: .easeIn(duration: 0.2))
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(2)
                    }
                    .keyboardShortcut("n")
                    .buttonStyle(.borderless)
                    Toggle(isOn: .constant(true)) {
                        Image(systemName: "info.circle")
                    }
                    .toggleStyle(.button)
                    .help("Show the metadata associated with an item in the list.")
                }
            }
        }
    }
}

struct DoItemsView_Previews: PreviewProvider {
    static var previews: some View {
        DoItemsView(store: .init(initialState: .mock,
                                 reducer: Items())
        )
    }
}
