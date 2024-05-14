//
//  MainView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedLayoutIndex = 0
    let layouts = LayoutDataManager.shared.layouts  // Ensure this is populated correctly

    var body: some View {
        VStack {
            if layouts.isEmpty {
                Text("No layouts available")
                    .padding()
                    .foregroundColor(.gray)
            } else {
                // Use CarouselPicker here
                CarouselPicker(selectedLayoutIndex: $selectedLayoutIndex, layouts: layouts)
                    .frame(height: 60)  // Adjust height as needed

                KeyboardGridView(layout: layouts[selectedLayoutIndex])
            }
        }
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
