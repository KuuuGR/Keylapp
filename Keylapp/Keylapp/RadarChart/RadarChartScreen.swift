//
//  RadarChartScreen.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import SwiftUI

struct RadarChartScreen: View {
    let layout: KeyboardLayout
    let comparisonLayout: KeyboardLayout
    
    private var dimensions: [Ray] {
        [
            Ray(maxValue: 10, rayCase: .efficiency),
            Ray(maxValue: 10, rayCase: .comfort),
            Ray(maxValue: 10, rayCase: .speed),
            Ray(maxValue: 10, rayCase: .memorability),
            Ray(maxValue: 10, rayCase: .ergonomics),
            Ray(maxValue: 10, rayCase: .customizability)
        ]
    }
    
    private var data: [DataPoint] {
        [
            DataPoint(
                efficiency: calculateEfficiency(for: layout),
                comfort: calculateComfort(for: layout),
                speed: calculateSpeed(for: layout),
                memorability: calculateMemorability(for: layout),
                ergonomics: calculateErgonomics(for: layout),
                customizability: calculateCustomizability(for: layout),
                color: .blue,
                label: layout.name
            ),
            DataPoint(
                efficiency: calculateEfficiency(for: comparisonLayout),
                comfort: calculateComfort(for: comparisonLayout),
                speed: calculateSpeed(for: comparisonLayout),
                memorability: calculateMemorability(for: comparisonLayout),
                ergonomics: calculateErgonomics(for: comparisonLayout),
                customizability: calculateCustomizability(for: comparisonLayout),
                color: .green,
                label: comparisonLayout.name
            )
        ]
    }
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Keyboard Layout Analysis")
                    .font(.title)
                    .foregroundColor(.white)
                    .padding(.top)
                
                RadarChartView(
                    width: min(UIScreen.main.bounds.width - 40, 350),
                    mainColor: .white,
                    subtleColor: .gray,
                    quantityOfIncrementalDividers: 4,
                    dimensions: dimensions,
                    data: data
                )
                .padding()
                
                HStack(spacing: 20) {
                    ForEach(data, id: \.id) { point in
                        HStack {
                            Circle()
                                .fill(point.color)
                                .frame(width: 12, height: 12)
                            Text(point.label)
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Calculation Methods
    private func calculateEfficiency(for layout: KeyboardLayout) -> Double {
        // Implement your actual efficiency calculation
        return Double.random(in: 5...9)
    }
    
    private func calculateComfort(for layout: KeyboardLayout) -> Double {
        // Implement your actual comfort calculation
        return Double.random(in: 5...9)
    }
    
    private func calculateSpeed(for layout: KeyboardLayout) -> Double {
        // Implement your actual speed calculation
        return Double.random(in: 5...9)
    }
    
    private func calculateMemorability(for layout: KeyboardLayout) -> Double {
        // Implement your actual memorability calculation
        return Double.random(in: 5...9)
    }
    
    private func calculateErgonomics(for layout: KeyboardLayout) -> Double {
        // Implement your actual ergonomics calculation
        return Double.random(in: 5...9)
    }
    
    private func calculateCustomizability(for layout: KeyboardLayout) -> Double {
        // Implement your actual customizability calculation
        return Double.random(in: 5...9)
    }
}
