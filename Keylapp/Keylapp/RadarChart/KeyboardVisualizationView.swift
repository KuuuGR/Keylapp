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
        VStack(spacing: 8) {
            ForEach(keys.indices, id: \.self) { rowIndex in
                HStack(spacing: 4) {
                    ForEach(keys[rowIndex].indices, id: \.self) { keyIndex in
                        Text(keys[rowIndex][keyIndex])
                            .font(.system(size: 14, weight: .bold))
                            .frame(width: 24, height: 24)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                }
            }
        }
    }
}
