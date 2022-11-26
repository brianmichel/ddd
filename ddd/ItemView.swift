//
//  ItemView.swift
//  ddd
//
//  Created by Brian Michel on 11/20/22.
//

import ComposableArchitecture
import DDDCore
import Models
import SwiftUI

struct ItemView: View {
    enum FocusedField {
        case title
        case description
    }

    let item: Item
    let viewStore: ViewStoreOf<Items>
    var showMetadata = false
    var expanded = false

    @State private var itemDescription = ""
    @State private var itemTitle = ""
    @FocusState private var focusedField: FocusedField?

    init(item: Item, viewStore: ViewStoreOf<Items>, showMetadata: Bool = false, expanded: Bool = false) {
        self.item = item
        self.viewStore = viewStore
        self.showMetadata = showMetadata
        self.expanded = expanded

        _itemTitle = State(initialValue: item.title)
        _itemDescription = State(initialValue: item.notes ?? "")
    }

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 2) {
                    if showMetadata || expanded {
                        Button {
                            var newItem = item
                            newItem.important.toggle()
                            viewStore.send(.updateItem(newItem), animation: .easeInOut(duration: 0.2))
                        } label: {
                            Image(systemName: "octagon.fill")
                                .opacity(item.important ? 1.0 : 0.2)
                        }
                        .help(importantHelpText)
                        .buttonStyle(.plain)

                        Button {
                            var newItem = item
                            newItem.urgent.toggle()
                            viewStore.send(.updateItem(newItem), animation: .easeInOut(duration: 0.2))
                        } label: {
                            Image(systemName: "clock.badge.exclamationmark")
                                .opacity(item.urgent ? 1.0 : 0.2)
                        }
                        .help(urgentHelpText)
                        .buttonStyle(.plain)
                    }
                }
                .foregroundColor(.primary)
                if expanded {
                    TextField(text: $itemTitle, prompt: nil) {
                        Text(item.title.isEmpty ? "New Item" : item.title)
                    }
                    .font(.body.bold())
                    .textFieldStyle(.plain)
                    .foregroundColor(.primary)
                    .focused($focusedField, equals: .title)
                } else {
                    Text(item.title)
                        .font(.body.bold())
                        .foregroundColor(.primary)
                }

                Spacer()
            }
            if expanded {
                Spacer()
                TextEditor(text: $itemDescription)
                    .foregroundColor(.primary)
                    .scrollContentBackground(.hidden)
                    .font(.body)
                    .background(.clear)
                    .focused($focusedField, equals: .description)
            }
        }
        .frame(height: height)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .opacity(expanded ? 1.0 : 0.0)
                .foregroundColor(NSColor.windowBackgroundColor.color)
                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 0)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.primary.opacity(0.3), lineWidth: 0.5)
                .opacity(expanded ? 1.0 : 0.0)
        )
        .onChange(of: expanded) { newValue in
            self.focusedField = newValue ? .title : nil
        }
        .onChange(of: itemTitle) { newValue in
            guard !newValue.isEmpty else { return }

            var newItem = item
            newItem.title = newValue
            viewStore.send(.updateItem(newItem))
        }
        .onSubmit {
            viewStore.send(.closeEditingItem, animation: .easeIn(duration: 0.2))
        }
    }

    var height: Double {
        expanded ? 100 : 10
    }

    var importantHelpText: String {
        item.important ? "This item is important." : "This item is unimportant."
    }

    var urgentHelpText: String {
        item.urgent ? "This item is urgent." : "This item is not urgent."
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let viewStore = ViewStore(.init(initialState: .mock, reducer: Items()))
            ForEach(Items.State.mock.items) { item in
                ItemView(item: item, viewStore: viewStore, showMetadata: true)
                ItemView(item: item, viewStore: viewStore, showMetadata: false)
                ItemView(item: item, viewStore: viewStore, expanded: true)
            }
        }
    }
}

extension NSColor {
    var color: Color {
        return Color(self)
    }
}
