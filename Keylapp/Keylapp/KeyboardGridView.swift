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
            let screenWidth = geometry.size.width
            let screenHeight = geometry.size.height
            let keySize = min(screenWidth / 10, screenHeight / 4) // Ensure keys fit within the screen

            VStack(spacing: 10) {
                ForEach(0..<keys.count, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(0..<keys[rowIndex].count, id: \.self) { columnIndex in
                            Button(action: {
                                print("\(keys[rowIndex][columnIndex]) tapped")
                            }) {
                                Text(keys[rowIndex][columnIndex])
                                    .font(.system(size: keySize * 0.4, weight: .bold)) // Larger and bold text
                                    .frame(width: keySize, height: keySize)
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


struct KeyboardGridView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardGridView(layout: KeyboardLayout(id: "001", name: "QWERTY", firstRow: "qwfpbjluy;", secondRow: "arstgmneio", thirdRow: "zxcdvkh,./", fourthRow: "", keyColors: ["s": .blue,]))
    }
}

