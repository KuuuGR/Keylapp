//
//  RadarChartView.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import SwiftUI

struct RadarChartView: View {
    let mainColor: Color
    let subtleColor: Color
    let width: CGFloat
    let quantityOfDividers: Int
    let dimensions: [Ray]
    let data: [DataPoint]
    
    private let labelOffset: CGFloat = 10  // Increase to move labels further out
//    private let labelWidth: CGFloat = 10  // Adjust text container width
//    private let labelHeight: CGFloat = 70 // Adjust text container height

    private let labelRotationOffset: Angle = .degrees(90)
    
    private var center: CGPoint {
        CGPoint(x: width/2, y: width/2)
    }
    
    private var radius: CGFloat {
        width/2 - 60
    }
    
    var body: some View {
        ZStack {
            // Background grid
            ForEach(0..<quantityOfDividers, id: \.self) { index in
                let currentRadius = radius * CGFloat(index + 1)/CGFloat(quantityOfDividers + 1)
                Circle()
                    .stroke(subtleColor.opacity(0.3), lineWidth: 1)
                    .frame(width: currentRadius * 2, height: currentRadius * 2)
            }
            
            // Axes and labels
            ForEach(Array(dimensions.enumerated()), id: \.element.id) { index, dimension in
                let angle = angleForDimension(at: index)
                let endPoint = pointOnCircle(radius: radius, angle: angle)
                
                ZStack {
                    // Axis line
                    Path { path in
                        path.move(to: center)
                        path.addLine(to: endPoint)
                    }
                    .stroke(mainColor.opacity(0.5), lineWidth: 1)
        
                    // Label
                    Text(dimension.name)
                        .font(.system(size: 12, weight: .medium))
                        .rotationEffect(.radians(Double(angle))) // Rotate text to follow axis
                        .offset(x: (radius + labelOffset) * cos(angle),
                                y: (radius + labelOffset) * sin(angle))
                        .fixedSize()
                        .frame(width: 80, height: 20, alignment: .center)
                }
            }
            
            // Data polygons
            ForEach(data) { dataPoint in
                Path { path in
                    for index in 0..<dimensions.count {
                        let angle = angleForDimension(at: index)
                        let dimension = dimensions[index]
                        guard let entry = dataPoint.entries.first(where: { $0.rayCase == dimension.rayCase }) else { continue }
                        
                        let valueRadius = radius * CGFloat(entry.value / dimension.maxValue)
                        let point = pointOnCircle(radius: valueRadius, angle: angle)
                        
                        if index == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                    path.closeSubpath()
                }
                .fill(dataPoint.color.opacity(0.3))
                .stroke(dataPoint.color, lineWidth: 2)
            }
        }
        .frame(width: width, height: width)
        //.frame(width: labelWidth, height: labelHeight, alignment: .top)
    }
    
    private func angleForDimension(at index: Int) -> CGFloat {
        2 * .pi / CGFloat(dimensions.count) * CGFloat(index)
    }
    
    private func pointOnCircle(radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }
}
