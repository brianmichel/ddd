//
//  DDDMacApplicationDelegate.swift
//  ddd
//
//  Created by Brian Michel on 11/20/22.
//

import AppKit
import ComposableArchitecture
import DDDCore
import Foundation

final class DDDMacApplicationDelegate: NSObject, NSApplicationDelegate {
    let store = Store(initialState: Application.State(items: .init(items: [])), reducer: Application())
}
