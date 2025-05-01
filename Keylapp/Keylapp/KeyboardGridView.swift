//
//  KeyboardGridView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout
    @Binding var selectedComparisonLayoutIndex: Int
    var onBack: (() -> Void)? = nil  // NEW
    
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
            
            ZStack(alignment: .leading) {
                // Main keyboard grid content
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(Array(keys.enumerated()), id: \.offset) { index, row in
                        HStack {
                            ForEach(Array(row.enumerated()), id: \.offset) { colIndex, key in
                                let keyParts = key.split(separator: "_")
                                let keyChar = String(keyParts[0])
                                let keyColor = layout.keyColors[key] ?? .gray
                                let displayChar = comparisonKeys[keyChar] ?? keyChar
                                
                                Button(action: {
                                    handleKeyPress(index: index, colIndex: colIndex, rowCount: row.count, keyChar: keyChar)
                                }) {
                                    VStack {
                                        if showComparison {
                                            Text(keyChar)
                                                .font(.system(size: buttonSize / 2, weight: .bold))
                                                .foregroundColor(.white)
                                            Text(displayChar.split(separator: "/").last ?? "")
                                                .font(.system(size: buttonSize / 4))
                                                .foregroundColor(Color.logoJeans)
                                        } else {
                                            Text(keyChar)
                                                .font(.system(size: buttonSize / 2, weight: .bold))
                                                .foregroundColor(.white)
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
                
                // Custom back button
                VStack {
                    Spacer()
                    Button(action: {
                        onBack?()  // UPDATED
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .frame(width: 44)
                .padding(.leading)
            }
            .sheet(isPresented: $showLayoutInfo) {
                LayoutInfoView()
            }
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
            selectedChartLayout1 = KeyboardLayoutStats.loadSampleData().first(where: { $0.name == layout.name })
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
