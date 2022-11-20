//
//  ItemView.swift
//  ddd
//
//  Created by Brian Michel on 11/20/22.
//

import DDDCore
import SwiftUI

struct ItemView: View {
    enum FocusedField {
        case title
        case description
    }

    let item: Item
    var showMetadata = false
    var expanded = false

    @State private var itemDescription = ""
    @FocusState private var focusedField: FocusedField?

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 2) {
                    if showMetadata || expanded {
                        Image(systemName: "octagon.fill")
                            .help(importantHelpText)
                            .opacity(item.important ? 1.0 : 0.2)
                        Image(systemName: "clock.badge.exclamationmark")
                            .help(urgentHelpText)
                            .opacity(item.urgent ? 1.0 : 0.2)
                    }
                }
                .foregroundColor(.primary)
                Text(item.title)
                    .font(.body.bold())
                    .foregroundColor(.primary)
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
            self.focusedField = newValue ? .description : nil
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
            ForEach(Items.State.mock.items) { item in
                ItemView(item: item, showMetadata: true)
                ItemView(item: item, showMetadata: false)
                ItemView(item: item, expanded: true)
            }
        }
    }
}

extension NSColor {
    var color: Color {
        return Color(self)
    }
}
