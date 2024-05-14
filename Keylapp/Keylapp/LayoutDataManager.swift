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
            let fourthRow = String(repeating: " ", count: 10)  // Ensuring fourthRow always has 10 characters

            // Get the fourth character and the fourth-from-end character from the second row
            let startIdx = secondRow.index(secondRow.startIndex, offsetBy: 3)
            let endIdx = secondRow.index(secondRow.endIndex, offsetBy: -4)

            let startChar = String(secondRow[startIdx])
            let endChar = String(secondRow[endIdx])

            // Set colors for the specified keys in the second row
            var keyColors: [String: Color] = [
                "\(startChar)_3": .red,
                "\(endChar)_6": .blue
            ]

            // Add colors for the first three and last three keys in the fourth row
            let fourthRowChars = Array(fourthRow)
            if fourthRowChars.count >= 10 {
                for i in 0..<4 {
                    keyColors["\(fourthRowChars[i])_\(i)"] = .graphiteGray
                    keyColors["\(fourthRowChars[9 - i])_\(9 - i)"] = .graphiteGray
                }
                keyColors["\(fourthRowChars[4])_4"] = .gray
                keyColors["\(fourthRowChars[5])_5"] = .gray
            }

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
