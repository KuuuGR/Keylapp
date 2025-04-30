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
        GeometryReader { geometry in
            HStack(alignment: .top, spacing: 20) {
                // Left side - Radar Chart (60% of width)
                chartSection
                    .frame(width: geometry.size.width * 0.6)
                
                // Right side - Controls (40% of width)
                controlPanelSection
                    .frame(width: geometry.size.width * 0.4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
    
    private var chartSection: some View {
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
                .frame(height: 350)
                
                // Legend
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
    }
    
    private var controlPanelSection: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Layout Selection
                VStack(alignment: .leading, spacing: 20) {
                    Text("Keylapp")
                        .foregroundColor(.yellow)
                        .font(.headline)
                    +
                    Text(": Layout Comparison")
                        .foregroundColor(.primary)
                        .font(.headline)

                    layoutPicker(label: "🔵 Primary Layout:", selection: $selectedLayout1)
                    layoutPicker(label: "🟢 Comparison Layout:", selection: $selectedLayout2) //⁸.☘︎ ݁˖༝༚.☘︎ ݁˖𖦹꩜୭
                }
                
                // Hand Balance Visualization
                if selectedLayout1 != nil || selectedLayout2 != nil {
                    VStack(alignment: .leading, spacing: 5) {
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
            }
            .padding(.trailing, 60)
        }
    }
    
    private func layoutPicker(label: String, selection: Binding<KeyboardLayoutStats?>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
            Picker(label, selection: selection) {
                Text("None").tag(nil as KeyboardLayoutStats?)
                ForEach(allLayouts, id: \.self) { layout in
                    Text(layout.name).tag(layout as KeyboardLayoutStats?)
                }
            }
            .pickerStyle(MenuPickerStyle())
        }
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
