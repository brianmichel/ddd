//
//  dddApp.swift
//  ddd
//
//  Created by Brian Michel on 11/18/22.
//

import DDDCore
import SwiftUI

@main
struct dddApp: App {
    @NSApplicationDelegateAdaptor(DDDMacApplicationDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ItemsView(store: delegate.store.scope(state: \.items,
                                                  action: Application.Action.items))
        }
    }
}
