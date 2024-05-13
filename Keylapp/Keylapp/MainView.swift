//
//  MainView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

// MainView.swift

import SwiftUI

struct MainView: View {
    @State private var selectedLayoutIndex = 0
    let layouts = LayoutDataManager.shared.layouts  // Directly access the layouts

    var body: some View {
        VStack {
            Picker("Select Layout", selection: $selectedLayoutIndex) {
                ForEach(0..<layouts.count, id: \.self) { index in
                    Text(layouts[index].name).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if !layouts.isEmpty {
                KeyboardGridView(layout: layouts[selectedLayoutIndex])
            }
        }
        .padding()
    }
}

// Add previews as needed
