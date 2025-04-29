// KeyboardStatsView.swift

import SwiftUI

struct KeyboardStatsView: View {
    let layout: KeyboardLayoutStats
    
    // Radar chart configuration
    private let chartWidth: CGFloat = 250
    private let mainChartColor: Color = .blue
    private let subtleChartColor: Color = .gray.opacity(0.3)
    private let dividersCount: Int = 4
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with name and likes
            HStack {
                Text(layout.name)
                    .font(.title.bold())
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "hand.thumbsup.fill")
                    Text("\(layout.likes)")
                }
                .foregroundColor(.yellow)
            }
            
            // Main content
            HStack(alignment: .top, spacing: 20) {
                // Radar Chart
                VStack {
                    Text("Performance Metrics")
                        .font(.headline)
                    RadarChartView(
                        mainColor: mainChartColor,
                        subtleColor: subtleChartColor,
                        width: chartWidth,
                        quantityOfDividers: dividersCount,
                        dimensions: [
                            Ray(maxValue: 50, rayCase: .alternation),
                            Ray(maxValue: 50, rayCase: .rolling),
                            Ray(maxValue: 50, rayCase: .oneHand),
                            Ray(maxValue: 50, rayCase: .redirect),
                            Ray(maxValue: 50, rayCase: .redundancy),
                            Ray(maxValue: 10, rayCase: .sfb),
                            Ray(maxValue: 10, rayCase: .sfs)
                        ],
                        data: [
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
                                color: .blue,
                                label: layout.name
                            )
                        ]
                    )
                    .frame(width: chartWidth, height: chartWidth)
                }
                
                // Right side - LH/RH balance and layout
                VStack(spacing: 20) {
                    VStack {
                        Text("Hand Balance")
                            .font(.headline)
                        HandBalanceView(
                            title: layout.name,
                            lhPercent: layout.stats.lh,
                            rhPercent: layout.stats.rh,
                            color: mainChartColor // Using the same blue as the radar chart
                        )
                        .frame(height: 30)
                        .padding(.horizontal)
                    }
                    
                    VStack {
                        Text("Key Layout")
                            .font(.headline)
                        KeyboardVisualizationView(keys: layout.layout)
                            .frame(width: 300)
                    }
                }
            }
        }
        .padding()
    }
}
