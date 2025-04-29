//
//  LayoutComparisonView.swift
//  Keylapp
//
//  Created by admin on 30/04/2025.
//

import SwiftUI

struct LayoutComparisonView: View {
    var initialLayout1: KeyboardLayoutStats?
    var initialLayout2: KeyboardLayoutStats?
    
    @State private var allLayouts: [KeyboardLayoutStats] = KeyboardLayoutStats.loadSampleData()
    @State private var selectedLayout1: KeyboardLayoutStats?
    @State private var selectedLayout2: KeyboardLayoutStats?
    
    init(initialLayout1: KeyboardLayoutStats? = nil, initialLayout2: KeyboardLayoutStats? = nil) {
        _selectedLayout1 = State(initialValue: initialLayout1)
        _selectedLayout2 = State(initialValue: initialLayout2)
    }
    
    private var dimensions: [Ray] {
        [
            Ray(maxValue: 50, rayCase: .alternation),
            Ray(maxValue: 50, rayCase: .rolling),
            Ray(maxValue: 50, rayCase: .oneHand),
            Ray(maxValue: 50, rayCase: .redirect),
            Ray(maxValue: 50, rayCase: .redundancy),
            Ray(maxValue: 10, rayCase: .sfb),
            Ray(maxValue: 10, rayCase: .sfs)
        ]
    }
    
    private var chartData: [DataPoint] {
        var points = [DataPoint]()
        
        if let layout1 = selectedLayout1 {
            points.append(createDataPoint(for: layout1, color: .blue))
        }
        
        if let layout2 = selectedLayout2 {
            points.append(createDataPoint(for: layout2, color: .green))
        }
        
        return points
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            // Radar Chart Area
            VStack {
                if !chartData.isEmpty {
                    RadarChartView(
                        mainColor: .primary,
                        subtleColor: .gray,
                        width: 350,
                        quantityOfDividers: 4,
                        dimensions: dimensions,
                        data: chartData
                    )
                    .frame(width: 350, height: 350)
                    
                    // Legend at bottom of chart
                    HStack(spacing: 20) {
                        ForEach(chartData) { point in
                            HStack(spacing: 8) {
                                Circle()
                                    .fill(point.color)
                                    .frame(width: 12, height: 12)
                                Text(point.label)
                                    .font(.subheadline)
                            }
                        }
                    }
                    .padding(.top, 10)
                } else {
                    Text("Select layouts to compare")
                        .frame(width: 350, height: 350)
                        .foregroundColor(.secondary)
                }
            }
            
            // Control Panel
            VStack(alignment: .leading, spacing: 30) {
                // Layout Selection
                VStack(alignment: .leading, spacing: 15) {
                    Text("Compare Layouts")
                        .font(.headline)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Primary Layout:")
                        Picker("Select Layout 1", selection: $selectedLayout1) {
                            Text("None").tag(nil as KeyboardLayoutStats?)
                            ForEach(allLayouts, id: \.self) { layout in
                                Text(layout.name).tag(layout as KeyboardLayoutStats?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 200)
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Comparison Layout:")
                        Picker("Select Layout 2", selection: $selectedLayout2) {
                            Text("None").tag(nil as KeyboardLayoutStats?)
                            ForEach(allLayouts, id: \.self) { layout in
                                Text(layout.name).tag(layout as KeyboardLayoutStats?)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 200)
                    }
                }
                
                // Hand Balance Visualization
                if selectedLayout1 != nil || selectedLayout2 != nil {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Hand Balance")
                            .font(.headline)
                        
                        if let layout1 = selectedLayout1 {
                            HandBalanceView(
                                title: layout1.name,
                                lhPercent: layout1.stats.lh,
                                rhPercent: layout1.stats.rh,
                                color: .blue
                            )
                        }
                        
                        if let layout2 = selectedLayout2 {
                            HandBalanceView(
                                title: layout2.name,
                                lhPercent: layout2.stats.lh,
                                rhPercent: layout2.stats.rh,
                                color: .green
                            )
                        }
                    }
                }
                
                Spacer()
            }
            .frame(width: 250)
            .padding(.top, 20)
        }
        .padding()
        .navigationTitle("Keyboard Layout Comparison")
    }
    
    private func createDataPoint(for layout: KeyboardLayoutStats, color: Color) -> DataPoint {
        DataPoint(
            values: [
                .alternation: layout.stats.alt,
                .rolling: layout.stats.roll,
                .oneHand: layout.stats.one,
                .redirect: layout.stats.rtl,
                .redundancy: layout.stats.red,
                .sfb: layout.stats.sfb,
                .sfs: layout.stats.sfs
            ],
            color: color,
            label: layout.name
        )
    }
}

// Enhanced Hand Balance View
struct HandBalanceView: View {
    let title: String
    let lhPercent: Double
    let rhPercent: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(color)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 20)
                    
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(color.opacity(0.6))
                            .frame(width: geometry.size.width * CGFloat(lhPercent / 100),
                                   height: 20)
                        
                        Rectangle()
                            .fill(color)
                            .frame(width: geometry.size.width * CGFloat(rhPercent / 100),
                                   height: 20)
                    }
                }
                .cornerRadius(4)
            }
            .frame(height: 20)
            
            HStack {
                Text("LH: \(lhPercent, specifier: "%.1f")%")
                    .font(.caption)
                Spacer()
                Text("RH: \(rhPercent, specifier: "%.1f")%")
                    .font(.caption)
            }
        }
    }
}
