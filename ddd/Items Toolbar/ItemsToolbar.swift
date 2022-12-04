//
//  ItemsToolbar.swift
//  DDD
//
//  Created by Brian Michel on 12/4/22.
//

import SwiftUI

struct ItemsToolbar<Content>: View where Content: View {
    private var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        ZStack {
            VStack {
                Rectangle()
                    .foregroundColor(Color(nsColor: .separatorColor))
                    .frame(height: 0.5)
                Spacer()
            }
            HStack {
                content
                .padding()
            }
        }
        .frame(height: 40)
    }
}

struct ItemsToolbar_Previews: PreviewProvider {
    static var previews: some View {
        ItemsToolbar {
            Button(action: {}) {
                Image(systemName: "plus")
            }
            .buttonStyle(.borderless)
            Button(action: {}) {
                Image(systemName: "minus")
            }
            .buttonStyle(.borderless)

            Button(action: {}) {
                Image(systemName: "gauge")
            }
            .buttonStyle(.borderless)

            Button(action: {}) {
                Image(systemName: "info")
            }
            .buttonStyle(.borderless)
        }
    }
}
