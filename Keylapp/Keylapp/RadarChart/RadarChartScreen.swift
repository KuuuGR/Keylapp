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
        RayCase.allCases.map { Ray(maxValue: 10, rayCase: $0) }
    }
    
    private var data: [DataPoint] {
        [
            DataPoint(
                values: calculateMetrics(for: layout),
                color: .blue,
                label: layout.name
            ),
            DataPoint(
                values: calculateMetrics(for: comparisonLayout),
                color: .green,
                label: comparisonLayout.name
            )
        ]
    }
    
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Keyboard Layout Analysis")
                    .font(.title)
                    .padding(.top)
                
                RadarChartView(
                    mainColor: .primary,
                    subtleColor: .gray,
                    width: min(UIScreen.main.bounds.width - 40, 350),
                    quantityOfDividers: 4,
                    dimensions: dimensions,
                    data: data
                )
                .padding()
                
                HStack(spacing: 20) {
                    ForEach(data) { point in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(point.color)
                                .frame(width: 12, height: 12)
                            Text(point.label)
                                .font(.subheadline)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func calculateMetrics(for layout: KeyboardLayout) -> [RayCase: Double] {
        // Replace with your actual calculations
        return [
            .efficiency: Double.random(in: 5...9),
            .comfort: Double.random(in: 5...9),
            .speed: Double.random(in: 5...9),
            .memorability: Double.random(in: 5...9),
            .ergonomics: Double.random(in: 5...9),
            .customizability: Double.random(in: 5...9)
        ]
    }
}
