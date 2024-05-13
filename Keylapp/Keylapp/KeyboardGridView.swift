// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout

    // This transforms the string data into an array of arrays, each sub-array representing a row of keys
    private var keys: [[String]] {
        [layout.firstRow, layout.secondRow, layout.thirdRow].map { row in
            row.map { String($0) } // Convert each row into an array of strings
        } + [["","","","","--","--","","","",""]] // Append an empty array to create an empty row
    }

    var body: some View {
        ScrollView {
            // Using a VStack to stack rows vertically
            VStack(alignment: .leading, spacing: 10) {
                ForEach(keys, id: \.self) { row in
                    HStack {
                        ForEach(row, id: \.self) { key in
                            Text(key)
                                .frame(width: 40, height: 40)
                                .border(Color.gray)
                        }
                    }
                }
            }
        }
    }
}

struct KeyboardGridView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardGridView(layout: KeyboardLayout(id: "001", name: "QWERTY", firstRow: "qwfpbjluy;", secondRow: "arstgmneio", thirdRow: "zxcdvkh,./"))
    }
}
