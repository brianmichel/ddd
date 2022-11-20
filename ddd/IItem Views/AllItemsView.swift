//
//  AllItemsView.swift
//  ddd
//
//  Created by Brian Michel on 11/18/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

struct AllItemsView: View {
    let store: StoreOf<Items>

    @State private var showCreationModal = false
    @State private var newItemName = ""
    @State private var newItemImportant = false
    @State private var newItemUrgent = false

    @State private var showMetadata = false

    var body: some View {
        WithViewStore(store) { viewStore in
            ItemsList(store: store, showMetadata: showMetadata)
                .navigationTitle("All Items")
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
                    ToolbarItem(placement: .primaryAction) {
                        Button {
                            showCreationModal.toggle()
                        } label: {
                            Label {
                                Text("Create New Item")
                            } icon: {
                                Image(systemName: "plus.app")
                            }
                        }
                        .help("Create a new item in the list.")
                    }
                }
                .sheet(isPresented: $showCreationModal) {
                    VStack {
                        TextField("Item Name", text: $newItemName)
                        HStack {
                            Toggle("Important", isOn: $newItemImportant)
                            Toggle("Urgent", isOn: $newItemUrgent)
                            Spacer()
                        }
                        Spacer().frame(height: 20)
                        HStack {
                            Spacer()
                            Button(action: {
                                showCreationModal.toggle()
                            }, label: {
                                Text("Cancel")
                            })
                            Button(action: {
                                let item = Item(id: UUID(),
                                                title: newItemName,
                                                urgent: newItemUrgent,
                                                important: newItemImportant)
                                viewStore.send(.addItem(item))
                                resetNewItemDialog()
                                showCreationModal.toggle()
                            }) {
                                Text("Create")
                            }
                            .disabled(disableCreation)
                            .keyboardShortcut(.return)
                        }.frame(width: 200)
                    }
                    .padding()
                }
        }
    }

    var disableCreation: Bool {
        return newItemName.isEmpty
    }

    func resetNewItemDialog() {
        newItemName = ""
        newItemUrgent = false
        newItemImportant = false
    }

    func opacticyForNonEditingItems(currentEditingItem: Bool) -> Double {
        let viewStore = ViewStore(store)

        if viewStore.editingItem == nil || currentEditingItem {
            return 1.0
        }

        return 0.6
    }
}

struct AllItemsView_Previews: PreviewProvider {
    static var previews: some View {
        AllItemsView(store: .init(initialState: .mock,
                               reducer: Items()))
    }
}
