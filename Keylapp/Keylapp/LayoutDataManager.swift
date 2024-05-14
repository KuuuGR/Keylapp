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
            guard lines.count == 4 else { continue }
            
            let name = lines[0]
            let firstRow = lines[1].padding(toLength: 10, withPad: " ", startingAt: 0)
            let secondRow = lines[2].padding(toLength: 10, withPad: " ", startingAt: 0)
            let thirdRow = lines[3].padding(toLength: 10, withPad: " ", startingAt: 0)
            let fourthRow = lines.count > 4 ? lines[4].padding(toLength: 10, withPad: " ", startingAt: 0) : String(repeating: " ", count: 10)
            
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
