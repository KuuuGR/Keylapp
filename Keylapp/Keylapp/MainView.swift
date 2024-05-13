//
//  MainView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct MainView: View {
    @State private var selectedLayoutIndex = 0
    let layouts: [KeyboardLayout] = LayoutDataManager.shared.parseLayouts()

    var body: some View {
        VStack {
            Picker("Select Layout", selection: $selectedLayoutIndex) {
                ForEach(0..<layouts.count, id: \.self) { index in
                    Text(layouts[index].name).tag(index)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            KeyboardGridView(layout: layouts[selectedLayoutIndex])
        }
    }
}


#Preview {
    MainView()
}
