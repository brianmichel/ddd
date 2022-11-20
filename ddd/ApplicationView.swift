//
//  ApplicationView.swift
//  DDD
//
//  Created by Brian Michel on 11/20/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

struct ApplicationView: View {
    let store: StoreOf<Application>

    let menuItems = [
        SidebarMenuItem(section: .do, title: "Do", image: "lasso.and.sparkles"),
        SidebarMenuItem(section: .delegate, title: "Delegate", image: "arrowshape.turn.up.forward"),
        SidebarMenuItem(section: .dontCare, title: "Don't Care", image: "xmark.bin"),
        SidebarMenuItem(section: .divider, title: "", image: ""),
        SidebarMenuItem(section: .allItems, title: "All Items", image: "squareshape.split.2x2"),
        SidebarMenuItem(section: .schedule, title: "Schedule", image: "calendar")
    ]

    @State private var selectedItem: SidebarMenuItem?

    var body: some View {
        NavigationSplitView {
            List(selection: $selectedItem) {
                ForEach(menuItems, id: \.self) { item in
                    item.body
                }
            }.listStyle(.sidebar)
        } detail: {
            if let selected = selectedItem, let filter = selected.section.filter {
                let scoped = store.scope(state: \.items, action: Application.Action.items)

                switch selected.section {
                case .allItems:
                    GridView(store: scoped)
                case .divider:
                    EmptyView()
                default:
                    FilteredItemsView(store: scoped,
                                      title: selected.title,
                                      filter: filter)
                }
            }
        }
        .onAppear() {
            selectedItem = menuItems.first
        }
    }
}

struct ApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        ApplicationView(store: .init(initialState: .init(),
                                     reducer: Application()))
    }
}
