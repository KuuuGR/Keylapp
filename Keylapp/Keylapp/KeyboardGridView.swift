// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout
    @Binding var selectedComparisonLayoutIndex: Int
    @State private var showComparison = false
    @State private var isSoundEnabled = false
    @State private var showLayoutInfo = false
    @State private var showRadarChart = false
    @State private var selectedChartLayout1: KeyboardLayoutStats?
    @State private var selectedChartLayout2: KeyboardLayoutStats?
    
    // Load all stats for comparison
    private var allStats: [KeyboardLayoutStats] {
        KeyboardLayoutStats.loadSampleData()
    }
    
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

                            Button(action: {
                                handleKeyPress(index: index, colIndex: colIndex, rowCount: row.count, keyChar: keyChar)
                            }) {
                                Text(keyChar)
                                    .font(.system(size: buttonSize / 2, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: buttonSize, height: buttonSize)
                                    .background(keyColor)
                                    .cornerRadius(5)
                            }
                        }
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .sheet(isPresented: $showRadarChart) {
                LayoutComparisonView(
                    initialLayout1: selectedChartLayout1,
                    initialLayout2: selectedChartLayout2
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    private func handleKeyPress(index: Int, colIndex: Int, rowCount: Int, keyChar: String) {
        if index == 3 && colIndex == (rowCount - 3) {
            isSoundEnabled.toggle()
        } else if index == 3 && colIndex == rowCount - 1 {
            showLayoutInfo = true
        } else if index == 3 && colIndex == 2 {
            // Set current layout as first comparison
            selectedChartLayout1 = allStats.first(where: { $0.name == layout.name })
            showRadarChart = true
        } else if isSoundEnabled {
            SoundManager.shared.playSound(for: keyChar)
        } else if index == 3 && colIndex == 0 {
            showComparison.toggle()
        } else {
            print("\(keyChar) tapped")
        }
    }
}
