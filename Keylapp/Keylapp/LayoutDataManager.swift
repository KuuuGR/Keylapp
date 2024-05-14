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
            let fourthRow = lines.count > 4 ? lines[4] : ""  // Handle fourth row if available
            
            let keyColors: [String: Color] = [
                String(firstRow.first ?? " "): .red,  // Example color assignment
                String(thirdRow.last ?? " "): .blue   // Example color assignment
            ]
            
            let keyboardLayout = KeyboardLayout(
                id: String(format: "%03d", index + 1),
                name: name,
                firstRow: firstRow,
                secondRow: secondRow,
                thirdRow: thirdRow,
                fourthRow: fourthRow,
                keyColors: keyColors
            )
            
            keyboardLayouts.append(keyboardLayout)
        }
        
        return keyboardLayouts
    }
}
