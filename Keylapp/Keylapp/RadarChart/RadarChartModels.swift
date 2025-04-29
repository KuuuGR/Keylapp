//
//  RadarChartModels.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import SwiftUI

enum RayCase: String, CaseIterable {
    case efficiency = "Efficiency"
    case comfort = "Comfort"
    case speed = "Speed"
    case memorability = "Memorability"
    case ergonomics = "Ergonomics"
    case customizability = "Customizability"
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
    
    init(efficiency: Double, comfort: Double, speed: Double,
         memorability: Double, ergonomics: Double, customizability: Double,
         color: Color, label: String) {
        self.entries = [
            RayEntry(rayCase: .efficiency, value: efficiency),
            RayEntry(rayCase: .comfort, value: comfort),
            RayEntry(rayCase: .speed, value: speed),
            RayEntry(rayCase: .memorability, value: memorability),
            RayEntry(rayCase: .ergonomics, value: ergonomics),
            RayEntry(rayCase: .customizability, value: customizability)
        ]
        self.color = color
        self.label = label
    }
}
