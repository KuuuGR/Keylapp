//
//  LayoutDataManager.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import Foundation

class LayoutDataManager {
    static let shared = LayoutDataManager()

    var layouts: [KeyboardLayout] {
        return keyboardLayouts
    }

    private init() {}
}
