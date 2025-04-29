//
//  RadarChartView.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import SwiftUI

struct RadarChartView: View {
    var mainColor: Color
    var subtleColor: Color
    var centerPoint: CGFloat
    var labelWidth: CGFloat = 70
    var width: CGFloat
    var quantityOfIncrementalDividers: Int
    var dimensions: [Ray]
    var data: [DataPoint]
    
    @State private var showLabels = true
    
    init(width: CGFloat, mainColor: Color = .white, subtleColor: Color = .gray,
         quantityOfIncrementalDividers: Int = 3, dimensions: [Ray], data: [DataPoint]) {
        self.width = width
        self.mainColor = mainColor
        self.subtleColor = subtleColor
        self.centerPoint = width / 2
        self.quantityOfIncrementalDividers = quantityOfIncrementalDividers
        self.dimensions = dimensions
        self.data = data
    }
    
    var body: some View {
        ZStack {
            // Main spokes
            Path { path in
                for i in 0..<dimensions.count {
                    let angle = RayEntry.radAngleFromFraction(numerator: i, denominator: dimensions.count)
                    let x = centerPoint + (width - 50 + labelWidth) / 2 * cos(angle)
                    let y = centerPoint + (width - 50 + labelWidth) / 2 * sin(angle)
                    
                    path.move(to: CGPoint(x: centerPoint, y: centerPoint))
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            .stroke(mainColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            
            // Labels
            if showLabels {
                ForEach(0..<dimensions.count, id: \.self) { i in
                    Text(dimensions[i].rayCase.rawValue)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(mainColor)
                        .frame(width: labelWidth, height: 10)
                        .rotationEffect(.degrees(RayEntry.angleFromFraction(numerator: i, denominator: dimensions.count)))
                        .offset(x: (width - 50) / 2)
                        .rotationEffect(
                            .degrees(
                                RayEntry.angleFromFraction(numerator: i, denominator: dimensions.count) > 90 &&
                                RayEntry.angleFromFraction(numerator: i, denominator: dimensions.count) < 270 ? 180 : 0
                            )
                        )
                        .background(Color.clear)
                }
            }
            
            // Outer border
            Path { path in
                for i in 0..<dimensions.count + 1 {
                    let currentDimension = i == dimensions.count ? dimensions[0] : dimensions[i]
                    let angle = RayEntry.radAngleFromFraction(numerator: i % dimensions.count, denominator: dimensions.count)
                    let x = centerPoint + (width - 50 + labelWidth) / 2 * cos(angle)
                    let y = centerPoint + (width - 50 + labelWidth) / 2 * sin(angle)
                    
                    if i == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(mainColor)
            
            // Incremental dividers
            ForEach(0..<quantityOfIncrementalDividers, id: \.self) { divider in
                Path { path in
                    let size = (width - 50 + labelWidth) / 2 * CGFloat(divider + 1) / CGFloat(quantityOfIncrementalDividers + 1)
                    
                    for i in 0..<dimensions.count + 1 {
                        let currentDimension = i == dimensions.count ? dimensions[0] : dimensions[i]
                        let angle = RayEntry.radAngleFromFraction(numerator: i % dimensions.count, denominator: dimensions.count)
                        let x = centerPoint + size * cos(angle)
                        let y = centerPoint + size * sin(angle)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(subtleColor.opacity(0.5))
            }
            
            // Data polygons
            ForEach(data) { dataPoint in
                Path { path in
                    for i in 0..<dimensions.count + 1 {
                        let currentDimension = i == dimensions.count ? dimensions[0] : dimensions[i % dimensions.count]
                        let maxVal = currentDimension.maxValue
                        
                        let dataPointValue: Double = {
                            if let entry = dataPoint.entries.first(where: { $0.rayCase == currentDimension.rayCase }) {
                                return entry.value
                            }
                            return 0
                        }()
                        
                        let angle = RayEntry.radAngleFromFraction(numerator: i % dimensions.count, denominator: dimensions.count)
                        let size = (width - 50 + labelWidth) / 2 * CGFloat(dataPointValue) / CGFloat(maxVal)
                        let x = centerPoint + size * cos(angle)
                        let y = centerPoint + size * sin(angle)
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .fill(dataPoint.color.opacity(0.3))
                .stroke(dataPoint.color, lineWidth: 2)
            }
        }
        .frame(width: width, height: width)
    }
}
