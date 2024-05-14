//
//  LayoutDataManager.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import Foundation
import SwiftUI

class LayoutDataManager {
    static let shared = LayoutDataManager()

    var layouts: [KeyboardLayout] {
        return keyboardLayouts
    }

    private init() {}
    
    func parseRawLayouts(_ rawLayouts: [String]) -> [KeyboardLayout] {
        var keyboardLayouts: [KeyboardLayout] = []

        for (index, layout) in rawLayouts.enumerated() {
            let lines = layout.split(separator: "\n").map { String($0) }
            if lines.count < 4 { continue }
            
            let name = lines[0]
            let firstRow = lines[1]
            let secondRow = lines[2]
            let thirdRow = lines[3]
            
            // Get the 4th character from the start and end of the second row
            let startIdx = secondRow.index(secondRow.startIndex, offsetBy: 3)
            let endIdx = secondRow.index(secondRow.endIndex, offsetBy: -4)
            
            let startChar = secondRow[startIdx]
            let endChar = secondRow[endIdx]
            
            let keyColors: [String: Color] = [
                String(startChar): .red,
                String(endChar): .blue
            ]
            
            let keyboardLayout = KeyboardLayout(
                id: String(format: "%03d", index + 1),
                name: name,
                firstRow: firstRow,
                secondRow: secondRow,
                thirdRow: thirdRow,
                keyColors: keyColors
            )
            
            keyboardLayouts.append(keyboardLayout)
        }
        
        return keyboardLayouts
    }
}
