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
    
    @State private var selectedRayCase: RayCase?
    
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

                    // Label as tappable button
                    Button(action: {
                        selectedRayCase = dimension.rayCase
                    }) {
                        Text(dimension.name)
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.primary)
                            .rotationEffect(.radians(Double(angle)))
                            .frame(width: 80, height: 20)
                    }
                    .offset(x: (radius + labelOffset) * cos(angle),
                            y: (radius + labelOffset) * sin(angle))
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
        .sheet(item: $selectedRayCase) { ray in
            RadarAxisDescriptionView(rayCase: ray)
        }
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

// View shown in sheet with ray case description
struct RadarAxisDescriptionView: View {
    let rayCase: RayCase
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text(rayCase.rawValue)
                    .font(.title2)
                    .bold()
                
                Text(descriptionText(for: rayCase))
                    .font(.body)
                
                Spacer()
                
                // Dismiss arrow button
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(UIColor.secondarySystemBackground))
                        .clipShape(Circle())
                        .shadow(radius: 2)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
            }
            .padding()
            .navigationTitle("Metric Info")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func descriptionText(for ray: RayCase) -> String {
        switch ray {
        case .alternation:
            return """
            🔄 Alternation (alt): Measures how often typing switches between hands.
            🎯 Higher is better — promotes rhythm and reduces fatigue.
            💡 Example: Typing “ad” alternates hands, while “as” uses the same hand.
            """

        case .rolling:
            return """
            🔁 Rolls (rol): Measures flowing finger movements in one direction, like “asd”.
            🎯 Higher is better — improves comfort and typing speed.
            💡 Example: “jkl” forms a right-hand inward roll.
            """

        case .oneHand:
            return """
            ✋ One-Hand Usage: Shows how often one hand types multiple keys in a row.
            🎯 Lower is better — reduces strain by encouraging hand alternation.
            💡 Example: “fast” on QWERTY is mostly typed with the left hand.
            """

        case .redirect:
            return """
            ↩️ Redirects (rdt): Measures changes in finger or hand direction that break flow.
            🎯 Lower is better — smoother finger travel means better ergonomics.
            💡 Example: Typing “lo” then “k” creates a redirect on the right hand.
            """

        case .badRedirect:
            return """
            🚫 Bad Redirects: Especially disruptive direction changes, often with weak fingers.
            🎯 Lower is much better — these patterns cause inefficiency and discomfort.
            💡 Example: “plk” requires an awkward right-hand movement.
            """

        case .sfb:
            return """
            🧍 Same-Finger Bigrams (sfb): Measures consecutive keypresses using the same finger.
            🎯 Lower is better — prevents fatigue and improves speed.
            💡 Example: “ed” on QWERTY uses the same finger (middle).
            """

        case .sfs:
            return """
            🦘 Same-Finger Skips (sfs): Measures skips over keys with the same finger.
            🎯 Lower is better — reduces stretch and strain.
            💡 Example: Typing “e” then “t” with the index finger.
            """
        }
    }
}
