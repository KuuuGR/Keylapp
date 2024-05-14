// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout

    private var keys: [[String]] {
        [layout.firstRow, layout.secondRow, layout.thirdRow].map { row in
            row.map { String($0) }
        } + [[]]  // Keep the empty row
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(keys.enumerated()), id: \.offset) { index, row in
                    HStack {
                        ForEach(Array(row.enumerated()), id: \.offset) { colIndex, key in
                            Button(action: {
                                print("\(key) tapped")
                                // Add actions here for button tap
                            }) {
                                Text(key)
                                    .frame(width: 40, height: 40)
                                    .background(layout.keyColors[key, default: Color.gray])  // Use default color if specific color is not set
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
        }
    }
}
