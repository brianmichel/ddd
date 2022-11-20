//
//  ItemsView.swift
//  ddd
//
//  Created by Brian Michel on 11/18/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

struct ItemsView: View {
    let store: StoreOf<Items>

    @State private var showCreationModal = false
    @State private var newItemName = ""
    @State private var newItemImportant = false
    @State private var newItemUrgent = false

    @State private var showMetaData = false

    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                ForEach(viewStore.items) { item in
                    ItemView(item: item, showMetaData: showMetaData)
                }
                .padding(10)
            }
            .toolbar {
                ToolbarItem {
                    Toggle(isOn: $showMetaData.animation(.easeIn(duration: 0.1))) {
                        Image(systemName: "info.circle")
                    }
                    .help("Show the metadata associated with an item in the list.")
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showCreationModal.toggle()
                    } label: {
                        Image(systemName: "plus.app")
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
                }.padding()
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
}

struct ItemsView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(store: .init(initialState: .mock,
                               reducer: Items()))
    }
}
