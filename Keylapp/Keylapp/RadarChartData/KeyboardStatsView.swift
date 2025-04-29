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
                // Radar Chart - now with all required parameters
                VStack {
                    Text("Performance Metrics")
                        .font(.headline)
                    RadarChartView(
                        mainColor: mainChartColor,
                        subtleColor: subtleChartColor,
                        width: chartWidth,
                        quantityOfDividers: dividersCount,
                        dimensions: [
                            Ray(maxValue: 50, rayCase: .alt),
                            Ray(maxValue: 50, rayCase: .roll),
                            Ray(maxValue: 50, rayCase: .one),
                            Ray(maxValue: 50, rayCase: .rtl),
                            Ray(maxValue: 50, rayCase: .red),
                            Ray(maxValue: 10, rayCase: .sfb),
                            Ray(maxValue: 10, rayCase: .sfs)
                        ],
                        data: [
                            DataPoint(
                                values: [
                                    .alt: layout.stats.alt,
                                    .roll: layout.stats.roll,
                                    .one: layout.stats.one,
                                    .rtl: layout.stats.rtl,
                                    .red: layout.stats.red,
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
                
                // Right side - LH/RH balance and layout (unchanged)
                VStack(spacing: 20) {
                    VStack {
                        Text("Hand Balance")
                            .font(.headline)
                        HandBalanceView(lhPercent: layout.stats.lh, rhPercent: layout.stats.rh)
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
