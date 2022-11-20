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
            ApplicationView(store: delegate.store)
        }
    }
}
