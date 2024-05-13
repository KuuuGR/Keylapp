//
//  KeyboardLayoutView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct KeyboardLayoutView: View {
    var layouts = LayoutDataManager.shared.layouts

    var body: some View {
        List(layouts, id: \.id) { layout in
            VStack(alignment: .leading) {
                Text(layout.name).font(.headline)
                Text(layout.firstRow)
                Text(layout.secondRow)
                Text(layout.thirdRow)
            }
        }
    }
}

struct KeyboardLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardLayoutView()
    }
}
