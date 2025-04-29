// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout
    @Binding var selectedComparisonLayoutIndex: Int  // Bind to the selected index from MainView
    @State private var showComparison = false
    @State private var isSoundEnabled = false  // State variable to track sound playback
    @State private var showLayoutInfo = false  // State to control the display of the layout info view
    @State private var showRadarChart = false

    private var keys: [[String]] {
        [layout.firstRow, layout.secondRow, layout.thirdRow, layout.fourthRow].map { row in
            row.enumerated().map { (index, char) in "\(char)_\(index)" }
        }
    }

    private var comparisonKeys: [String: String] {
        let comparisonLayout = LayoutDataManager.shared.layouts[selectedComparisonLayoutIndex]
        let qwertyLayout = comparisonLayout.firstRow + comparisonLayout.secondRow + comparisonLayout.thirdRow
        let currentLayout = layout.firstRow + layout.secondRow + layout.thirdRow

        var comparison = [String: String]()
        for (index, char) in currentLayout.enumerated() {
            let qwertyChar = qwertyLayout[qwertyLayout.index(qwertyLayout.startIndex, offsetBy: index)]
            comparison[String(char)] = "\(char)/\(qwertyChar)"
        }

        return comparison
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
                            let displayChar = comparisonKeys[keyChar] ?? keyChar

                            Button(action: {
                                if index == 3 && colIndex == (row.count - 3) {  // Third from the end column key in fourth row
                                    isSoundEnabled.toggle()
                                } else if index == 3 && colIndex == row.count - 1 {
                                    showLayoutInfo = true  // Toggle to show the layout info view
                                } else if isSoundEnabled {
                                    SoundManager.shared.playSound(for: keyChar)  // Play sound only if enabled
                                } else if index == 3 && colIndex == 2 {
                                    showRadarChart = true
                                    //showLayoutInfo = true
                                }
                                if index == 3 && colIndex == 0 {
                                    showComparison.toggle()
                                } else {
                                    print("\(keyChar) tapped")
                                }
                            }) {
                                VStack {
                                    if showComparison {
                                        Text(keyChar)
                                            .font(.system(size: buttonSize / 2, weight: .bold))
                                            .foregroundColor(.white)
                                            .background(keyColor)
                                            .cornerRadius(5)

                                        Text(displayChar.split(separator: "").last ?? "")
                                            .font(.system(size: buttonSize / 4))
                                            .foregroundColor(Color.logoJeans)  // Different color for QWERTY comparison
                                    } else {
                                        Text(keyChar)
                                            .font(.system(size: buttonSize / 2, weight: .bold))
                                            .foregroundColor(.white)
                                            .background(keyColor)
                                            .cornerRadius(5)
                                    }
                                }
                                .frame(width: buttonSize, height: buttonSize)
                                .background(keyColor)
                                .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .sheet(isPresented: $showLayoutInfo) {
                LayoutInfoView()  // Present the layout info view
            }
            .sheet(isPresented: $showRadarChart) {
                RadarChartScreen(
                    layout: layout,
                    comparisonLayout: LayoutDataManager.shared.layouts[selectedComparisonLayoutIndex]
                )
            }
        }
    }
}

//struct KeyboardGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        KeyboardGridView(
//            layout: KeyboardLayout(
//                id: "001",
//                name: "QWERTY",
//                firstRow: "qwfpbjluy;",
//                secondRow: "arstgmneio",
//                thirdRow: "zxcdvkh,./",
//                fourthRow: "          ",
//                keyColors: ["q_0": .red, "a_0": .blue, "z_0": .black, "x_1": .black, "c_2": .black, "m_7": .black, "/_9": .black]
//            ),
//            selectedComparisonLayoutIndex: .constant(0)  // Provide a constant for the preview
//        )
//    }
//}
