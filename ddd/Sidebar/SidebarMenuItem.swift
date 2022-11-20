//
//  SidebarMenuItem.swift
//  DDD
//
//  Created by Brian Michel on 11/20/22.
//

import Foundation
import SwiftUI

enum Section: Equatable {
    case `do`
    case delegate
    case dontCare
    case allItems
    case schedule
    case divider

    var filter: ItemsListFilter? {
        switch self {
        case .do:
            return .urgentAndImportant
        case .delegate:
            return .urgentAndNotImportant
        case .dontCare:
            return .notUrgentAndNotImportant
        case .allItems:
            return .all
        case .schedule:
            return .notUrgentAndImportant
        case .divider:
            return nil
        }
    }
}

struct SidebarMenuItem: Identifiable, Hashable {
    let id = UUID()

    let section: Section
    let title: String
    let image: String

    @ViewBuilder
    var body: some View {
        switch section {
        case .divider:
            Divider().disabled(true)
        default:
            Label {
                Text(title)
            } icon: {
                Image(systemName: image)
            }

        }
    }
}
