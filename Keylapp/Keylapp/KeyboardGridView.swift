//
//  KeyboardGridView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout

    var body: some View {
        VStack {
            ForEach(layout.keys, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { key in
                        Text(key)
                            .frame(width: 30, height: 30)
                            .border(Color.gray, width: 1)
                            .padding(1)
                    }
                }
            }
        }
    }
}

