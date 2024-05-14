// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout
    @State private var showComparison = false

    private var keys: [[String]] {
        [layout.firstRow, layout.secondRow, layout.thirdRow, layout.fourthRow].map { row in
            row.enumerated().map { (index, char) in "\(char)_\(index)" }
        }
    }

    var body: some View {
        GeometryReader { geometry in
            let buttonSize = min(geometry.size.width / 13, geometry.size.height / 4)

            VStack(alignment: .leading, spacing: 10) {
                ForEach(Array(keys.enumerated()), id: \.offset) { index, row in
                    HStack {
                        ForEach(Array(row.enumerated()), id: \.offset) { colIndex, key in
                            let keyParts = key.split(separator: "_")
                            let keyChar = String(keyParts[0])
                            let keyColor = layout.keyColors[key] ?? .gray
                            let displayChar = showComparison ? layout.comparisonKeys[keyChar] ?? keyChar : keyChar
                            
                            Button(action: {
                                if index == 3 && colIndex == 0 {
                                    showComparison.toggle()
                                } else {
                                    print("\(keyChar) tapped")
                                }
                            }) {
                                Text(displayChar)
                                    .font(.system(size: buttonSize / 2, weight: .bold))
                                    .frame(width: buttonSize, height: buttonSize)
                                    .background(keyColor)  // Use the determined key color
                                    .foregroundColor(.white)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
        }
    }
}

struct KeyboardGridView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardGridView(layout: KeyboardLayout(
            id: "001",
            name: "QWERTY",
            firstRow: "qwfpbjluy;",
            secondRow: "arstgmneio",
            thirdRow: "zxcdvkh,./",
            fourthRow: "         ",
            keyColors: ["q_0": .red, "a_0": .blue, "z_0": .black, "x_1": .black, "c_2": .black, "m_7": .black, "/_9": .black]
        ))
    }
}
