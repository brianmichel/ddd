//
//  ItemView.swift
//  ddd
//
//  Created by Brian Michel on 11/20/22.
//

import DDDCore
import SwiftUI

struct ItemView: View {
    @State private var expanded = false

    let item: Item

    var showMetaData = false

    var body: some View {
        VStack {
            HStack {
                HStack(spacing: 2) {
                    if showMetaData || expanded {
                        Image(systemName: "octagon.fill")
                            .opacity(item.important ? 1.0 : 0.2)
                        Image(systemName: "clock.badge.exclamationmark")
                            .opacity(item.urgent ? 1.0 : 0.2)
                    }
                }
                Text(item.title)
                Spacer()
            }
            if expanded {
                Spacer()
            }
        }
        .frame(height: height)
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .opacity(expanded ? 1.0 : 0.0)
                .foregroundColor(.accentColor)
        )
        .onTapGesture(count: 2) {
            withAnimation(.easeInOut(duration: 0.2)) {
                expanded.toggle()
            }
        }
    }

    var height: Double {
        expanded ? 50 : 10
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(Items.State.mock.items) { item in
                ItemView(item: item)
            }
        }
    }
}
