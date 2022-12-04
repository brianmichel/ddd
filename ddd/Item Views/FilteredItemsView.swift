//
//  FilteredItemsView.swift
//  DDD
//
//  Created by Brian Michel on 11/20/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

struct FilteredItemsView: View {
    let store: StoreOf<Items>
    let title: String
    let filter: ItemsListFilter

    @State private var showMetadata = false

    init(store: StoreOf<Items>, title: String, filter: ItemsListFilter = .all) {
        self.store = store
        self.title = title
        self.filter = filter
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            ItemsList(store: store, filter: filter, showMetadata: showMetadata)
                .navigationTitle(title)
                .toolbar {
                    ToolbarItem {
                        Toggle(isOn: $showMetadata.animation(.easeIn(duration: 0.2))) {
                            Label {
                                Text("Show Metadata")
                            } icon: {
                                Image(systemName: "info.circle")
                            }
                        }
                        .help("Show the metadata associated with an item in the list.")
                    }
                }
        }
    }
}

struct FilteredItemsView_Previews: PreviewProvider {
    static var previews: some View {
        FilteredItemsView(store: .init(initialState: .mock,
                                       reducer: Items()),
                          title: "Testing",
                          filter: .all)
    }
}
