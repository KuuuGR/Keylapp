//
//  LayoutDataManager.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import Foundation

class LayoutDataManager {
    static let shared = LayoutDataManager()
    
    private init() {}

    func parseLayouts(from rawLayouts: [String]) -> [KeyboardLayout] {
        var layouts = [KeyboardLayout]()
        for i in stride(from: 0, to: rawLayouts.count, by: 2) {
            let name = rawLayouts[i].trimmingCharacters(in: .whitespacesAndNewlines)
            let keysString = rawLayouts[i + 1]
            let keyRows = keysString.split(separator: "\n").map { Array($0).map { String($0) } }
            let layout = KeyboardLayout(name: name, keys: keyRows)
            layouts.append(layout)
        }
        return layouts
    }
}
