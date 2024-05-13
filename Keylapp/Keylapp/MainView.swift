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
        VStack {
            if layouts.isEmpty {
                Text("No layouts available")
                    .padding()
                    .foregroundColor(.gray)
            } else {
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
        .padding()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
