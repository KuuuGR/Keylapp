// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout

    // Convert rows to a 2D array
    private var keys: [[String]] {
        [
            layout.firstRow.map { String($0) },
            layout.secondRow.map { String($0) },
            layout.thirdRow.map { String($0) },
            layout.fourthRow.map { String($0) }
        ]
    }

    var body: some View {
        GeometryReader { geometry in
            // Calculate the size of the keys to fit the available space
            let keyWidth = geometry.size.width / CGFloat(keys.max(by: { $0.count < $1.count })?.count ?? 10)
            let keyHeight = keyWidth // Ensuring keys are square

            VStack(spacing: 10) {
                ForEach(0..<keys.count, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(0..<keys[rowIndex].count, id: \.self) { columnIndex in
                            Button(action: {
                                print("\(keys[rowIndex][columnIndex]) tapped")
                                // Add actions here for button tap
                            }) {
                                Text(keys[rowIndex][columnIndex])
                                    .font(.system(size: keyWidth * 0.5, weight: .bold)) // Larger and bold text
                                    .frame(width: keyWidth, height: keyHeight)
                                    .background(layout.keyColors[keys[rowIndex][columnIndex], default: Color.gray])  // Use default color if specific color is not set
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}
