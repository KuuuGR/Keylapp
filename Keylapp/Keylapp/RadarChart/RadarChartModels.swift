//
//  RadarChartModels.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import SwiftUI

enum RayCase: String, CaseIterable, Identifiable {
    case efficiency = "Efficiency"
    case comfort = "Comfort"
    case speed = "Speed"
    case memorability = "Memorability"
    case ergonomics = "Ergonomics"
    case customizability = "Customizability"
    
    var id: String { self.rawValue }
}

struct Ray: Identifiable {
    let id = UUID()
    let name: String
    let maxValue: Double
    let rayCase: RayCase
    
    init(maxValue: Double, rayCase: RayCase) {
        self.maxValue = maxValue
        self.rayCase = rayCase
        self.name = rayCase.rawValue
    }
}

struct RayEntry {
    let rayCase: RayCase
    let value: Double
    
    static func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * .pi / 180)
    }
    
    static func angleFromFraction(numerator: Int, denominator: Int) -> Double {
        return Double(numerator) * 360.0 / Double(denominator)
    }
    
    static func radAngleFromFraction(numerator: Int, denominator: Int) -> CGFloat {
        return degreesToRadians(angleFromFraction(numerator: numerator, denominator: denominator))
    }
}

struct DataPoint: Identifiable {
    let id = UUID()
    let entries: [RayEntry]
    let color: Color
    let label: String
    
    init(values: [RayCase: Double], color: Color, label: String) {
        self.entries = RayCase.allCases.map { RayEntry(rayCase: $0, value: values[$0] ?? 0) }
        self.color = color
        self.label = label
    }
}
