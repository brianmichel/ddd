//
//  GridView.swift
//  DDD
//
//  Created by Brian Michel on 11/20/22.
//

import ComposableArchitecture
import DDDCore
import SwiftUI

struct GridView: View {
    let store: StoreOf<Items>

    var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                HStack {
                    Text("Urgency")
                        .rotationEffect(.degrees(-90))
                        .padding(.leading, -15)

                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .frame(height: 0.5)
                        .padding(.leading, -15)
                        .opacity(0.4)
                    Spacer()
                }
                VStack {
                    Text("Importance")
                        .padding(.top, 4)
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: 0.5)
                        .opacity(0.4)
                    Spacer()
                }
                Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
                    GridRow {
                        ItemsList(store: store, filter: .urgentAndImportant)
                        .padding(3)
                        .padding(.leading, 10)
                        ItemsList(store: store, filter: .notUrgentAndImportant)
                            .padding(3)
                    }
                    .padding(.top, 10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    GridRow {
                        ItemsList(store: store, filter: .urgentAndNotImportant)
                            .padding(3)
                            .padding(.leading, 10)

                        ItemsList(store: store, filter: .notUrgentAndNotImportant)
                            .padding(3)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .padding(3)
            }

        }
    }
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        GridView(store: .init(initialState: .mock, reducer: Items()))
    }
}
