// KeyboardGridView.swift
// Keylapp
//
// Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardGridView: View {
    var layout: KeyboardLayout

    // Convert rows to a 2D array
    private var keys: [[String]] {
        let firstRow = layout.firstRow.map { String($0) }
        let secondRow = layout.secondRow.map { String($0) }
        let thirdRow = layout.thirdRow.map { String($0) }
        return [firstRow, secondRow, thirdRow]
    }

    var body: some View {
        ScrollView(.horizontal) {
            // Define the number of columns based on the maximum number of keys in any row
            let columns = Array(repeating: GridItem(.flexible()), count: keys.max(by: { $0.count < $1.count })?.count ?? 10)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(0..<keys.count, id: \.self) { rowIndex in
                    ForEach(0..<keys[rowIndex].count, id: \.self) { columnIndex in
                        Text(keys[rowIndex][columnIndex])
                            .frame(width: 40, height: 40)
                            .border(Color.gray, width: 1)
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
