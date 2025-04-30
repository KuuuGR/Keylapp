//
//  KeyboardVisualizationView.swift
//  Keylapp
//
//  Created by admin on 30/04/2025.
//

import SwiftUI

struct KeyboardVisualizationView: View {
    let keys: [[String]]
    
    var body: some View {
        GeometryReader { geometry in
            let keySize = min(geometry.size.width / CGFloat(keys[0].count), 50)
            
            VStack(spacing: 8) {
                ForEach(keys.indices, id: \.self) { rowIndex in
                    HStack(spacing: 4) {
                        ForEach(keys[rowIndex].indices, id: \.self) { keyIndex in
                            Text(keys[rowIndex][keyIndex])
                                .font(.system(size: keySize * 0.6, weight: .bold))
                                .frame(width: keySize, height: keySize)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 200) // Fixed height with dynamic width
    }
}

