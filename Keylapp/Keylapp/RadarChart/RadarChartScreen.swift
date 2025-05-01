//
//  RadarChartScreen.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import SwiftUI

struct RadarChartScreen: View {
    let layout: KeyboardLayoutStats  // Changed from KeyboardLayout
    let comparisonLayout: KeyboardLayoutStats  // Changed from KeyboardLayout
    
    private var dimensions: [Ray] {
        [
            Ray(maxValue: 50, rayCase: .alternation),
            Ray(maxValue: 50, rayCase: .rolling),
            Ray(maxValue: 50, rayCase: .oneHand),
            Ray(maxValue: 50, rayCase: .redirect),
            Ray(maxValue: 50, rayCase: .badRedirect),
            Ray(maxValue: 10, rayCase: .sfb),
            Ray(maxValue: 10, rayCase: .sfs)
        ]
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
    
    private func calculateMetrics(for layout: KeyboardLayoutStats) -> [RayCase: Double] {
        return [
            .alternation: layout.stats.alt,
            .rolling: layout.stats.roll,
            .oneHand: layout.stats.one,
            .redirect: layout.stats.rtl,
            .badRedirect: layout.stats.red,
            .sfb: layout.stats.sfb,
            .sfs: layout.stats.sfs
        ]
    }
}
