//
//  MainView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var selectedLayoutIndex = 0
    @State private var selectedComparisonLayoutIndex = 0

    let layouts = LayoutDataManager.shared.layouts

    var body: some View {
        GeometryReader { geometry in
            let keySize = min(geometry.size.width / 10, geometry.size.height / 4)

            VStack(spacing: 0) {
                CarouselPicker(
                    selectedIndex: $selectedLayoutIndex,
                    items: layouts.map { $0.name },
                    keySize: keySize,
                    backgroundColor: .logoJeans,
                    selectedBackgroundColor: .logoRed,
                    textColor: .white
                )
                .padding(.top, 5)

                if !layouts.isEmpty {
                    KeyboardGridView(
                        layout: layouts[selectedLayoutIndex],
                        selectedComparisonLayoutIndex: $selectedComparisonLayoutIndex,
                        onBack: {
                            withAnimation {
                                viewRouter.currentView = .welcome
                            }
                        }
                    )
                    .frame(maxHeight: .infinity)
                    .padding(.vertical, 10)
                } else {
                    Text("No layouts available")
                        .padding()
                        .foregroundColor(.gray)
                }

                CarouselPicker(
                    selectedIndex: $selectedComparisonLayoutIndex,
                    items: layouts.map { $0.name },
                    keySize: keySize / 2,
                    backgroundColor: .logoJeans,
                    selectedBackgroundColor: .logoBlue,
                    textColor: .white
                )
                .padding(.bottom, 5)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
