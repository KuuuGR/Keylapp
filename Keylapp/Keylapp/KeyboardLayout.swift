//
//  KeyboardLayout.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardLayout {
    let id: String
    let name: String
    let firstRow: String
    let secondRow: String
    let thirdRow: String
    let fourthRow: String
    var keyColors: [String: Color]
    var comparisonKeys: [String: String] = [:]  // Add this property
}
