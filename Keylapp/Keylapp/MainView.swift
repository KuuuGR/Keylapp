//
//  MainView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedLayoutIndex = 0
    let layouts = LayoutDataManager.shared.layouts  // Directly access the layouts

    var body: some View {
        GeometryReader { geometry in
            let keySize = min(geometry.size.width / 10, geometry.size.height / 4) // Ensure keys fit within the screen

            VStack {
                // CarouselPicker at the top
                CarouselPicker(
                    selectedIndex: $selectedLayoutIndex,
                    items: layouts.map { $0.name },
                    keySize: keySize
                )
                .padding(.top, 10)  // Add some top padding

                // Display the selected keyboard layout
                if !layouts.isEmpty {
                    KeyboardGridView(layout: layouts[selectedLayoutIndex])
                        .frame(maxHeight: .infinity)
                        .padding(.top, 20)  // Add some top padding
                } else {
                    Text("No layouts available")
                        .padding()
                        .foregroundColor(.gray)
                }
            }
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
