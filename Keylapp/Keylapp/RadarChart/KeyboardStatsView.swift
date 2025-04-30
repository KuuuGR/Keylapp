// KeyboardStatsView.swift
import SwiftUI

struct KeyboardStatsView: View {
    let layout: KeyboardLayoutStats
    
    // Radar chart configuration
    private let chartWidth: CGFloat = 250
    private let mainChartColor: Color = .blue
    private let subtleChartColor: Color = .gray.opacity(0.3)
    private let dividersCount: Int = 4
    
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
    
    private var data: [DataPoint] {
        [
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
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
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
                    if geometry.size.width > 700 { // iPad layout
                        HStack(alignment: .top, spacing: 30) {
                            // Left column - Radar Chart
                            VStack {
                                Text("Performance Metrics")
                                    .font(.headline)
                                RadarChartView(
                                    mainColor: mainChartColor,
                                    subtleColor: subtleChartColor,
                                    width: chartWidth,
                                    quantityOfDividers: dividersCount,
                                    dimensions: dimensions,
                                    data: data
                                )
                                .frame(width: chartWidth, height: chartWidth)
                            }
                            .frame(minWidth: 300)
                            
                            // Right column - Hand balance and keyboard visualization
                            VStack(spacing: 30) {
                                VStack {
                                    Text("Hand Balance")
                                        .font(.headline)
                                    HandBalanceView(
                                        title: layout.name,
                                        lhPercent: layout.stats.lh,
                                        rhPercent: layout.stats.rh,
                                        color: mainChartColor
                                    )
                                    .frame(height: 40)
                                }
                                
                                VStack {
                                    Text("Key Layout")
                                        .font(.headline)
                                    KeyboardVisualizationView(keys: layout.layout)
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 20)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                    } else { // iPhone layout
                        VStack(alignment: .center, spacing: 30) {
                            // Radar Chart
                            VStack {
                                Text("Performance Metrics")
                                    .font(.headline)
                                RadarChartView(
                                    mainColor: mainChartColor,
                                    subtleColor: subtleChartColor,
                                    width: min(geometry.size.width - 40, chartWidth),
                                    quantityOfDividers: dividersCount,
                                    dimensions: dimensions,
                                    data: data
                                )
                                .frame(width: min(geometry.size.width - 40, chartWidth),
                                      height: min(geometry.size.width - 40, chartWidth))
                            }
                            
                            // Hand balance
                            VStack {
                                Text("Hand Balance")
                                    .font(.headline)
                                HandBalanceView(
                                    title: layout.name,
                                    lhPercent: layout.stats.lh,
                                    rhPercent: layout.stats.rh,
                                    color: mainChartColor
                                )
                                .frame(height: 30)
                                //.padding(.top, 15)
                            }
                            
                            // Keyboard visualization
                            VStack {
                                Text("Key Layout")
                                    .font(.headline)
                                KeyboardVisualizationView(keys: layout.layout)
                                    .frame(maxWidth: .infinity)
                                    .padding(.horizontal, 20)
                            }
                        }
                    }
                }
                .padding()
            }
        }
    }
}
