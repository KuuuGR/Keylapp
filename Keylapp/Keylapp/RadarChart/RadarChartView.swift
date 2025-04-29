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
    
    private var centerPoint: CGPoint {
        CGPoint(x: width / 2, y: width / 2)
    }
    
    private var chartRadius: CGFloat {
        (width - 80) / 2
    }
    
    private var labelRadius: CGFloat {
        chartRadius + 20
    }
    
    private var labelRotationOffset: Angle {
        .degrees(25)
    }

    var body: some View {
        ZStack {
            drawGrid()
            drawAxesAndLabels()
            drawDataPolygons()
        }
        .frame(width: width, height: width)
    }
    
    private func drawGrid() -> some View {
        ForEach(0..<quantityOfDividers, id: \.self) { divider in
            let radius = chartRadius * CGFloat(divider + 1) / CGFloat(quantityOfDividers + 1)
            PolygonShape(sides: dimensions.count, radius: radius)
                .stroke(subtleColor.opacity(0.3), lineWidth: 1)
        }
    }
    
    private func drawAxesAndLabels() -> some View {
        ForEach(Array(dimensions.enumerated()), id: \.offset) { index, dimension in
            Group {
                drawAxis(at: index)
                drawLabel(for: dimension, at: index)
            }
        }
    }
    
    private func drawAxis(at index: Int) -> some View {
        let angle = angleForDimension(at: index)
        let endPoint = pointOnCircle(radius: chartRadius, angle: angle)
        
        return Path { path in
            path.move(to: centerPoint)
            path.addLine(to: endPoint)
        }
        .stroke(mainColor.opacity(0.5), lineWidth: 1)
    }
    
    private func drawLabel(for dimension: Ray, at index: Int) -> some View {
        let axisAngle = angleForDimension(at: index)
        let position = pointOnCircle(radius: labelRadius, angle: axisAngle)
        let rotation = calculateLabelRotation(axisAngle: axisAngle)
        
        return Text(dimension.name)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(mainColor)
            .fixedSize()
            .frame(width: 80, alignment: .center)
            .position(position)
            .rotationEffect(rotation)
    }
    
    private func drawDataPolygons() -> some View {
        ForEach(data) { dataPoint in
            let values = dimensions.map { dimension -> CGFloat in
                guard let entry = dataPoint.entries.first(where: { $0.rayCase == dimension.rayCase }) else {
                    return 0
                }
                return CGFloat(entry.value / dimension.maxValue)
            }
            
            PolygonShape(
                sides: dimensions.count,
                radius: chartRadius,
                values: values
            )
            .fill(dataPoint.color.opacity(0.3))
            .stroke(dataPoint.color, lineWidth: 2)
        }
    }
    
    private func angleForDimension(at index: Int) -> CGFloat {
        let angleStep = 2 * .pi / CGFloat(dimensions.count)
        return angleStep * CGFloat(index) - .pi/2
    }
    
    private func pointOnCircle(radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: centerPoint.x + radius * cos(angle),
            y: centerPoint.y + radius * sin(angle)
        )
    }
    
    private func calculateLabelRotation(axisAngle: CGFloat) -> Angle {
        let labelAngle = axisAngle + labelRotationOffset.radians
        let normalizedAngle = labelAngle.truncatingRemainder(dividingBy: 2 * .pi)
        let shouldFlip = normalizedAngle > .pi/2 && normalizedAngle < 3 * .pi/2
        
        return .radians(shouldFlip ? labelAngle + .pi : labelAngle)
    }
}

struct PolygonShape: Shape {
    let sides: Int
    let radius: CGFloat
    var values: [CGFloat] = []
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
            
            for i in 0..<sides {
                let angle = RayEntry.radAngleFromFraction(numerator: i, denominator: sides)
                let value = values.indices.contains(i) ? values[i] : 1.0
                let point = CGPoint(
                    x: center.x + radius * value * cos(angle),
                    y: center.y + radius * value * sin(angle)
                )
                
                if i == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            path.closeSubpath()
        }
    }
}
