//
//  CarouselPicker.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 14/05/2024.
//

import SwiftUI

struct CarouselPicker: View {
    @Binding var selectedIndex: Int
    var items: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .padding()
                        .background(index == selectedIndex ? Color.blue : Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = index
                            }
                        }
                }
            }
            .padding()
        }
    }
}

struct CarouselPicker_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPicker(selectedIndex: .constant(0), items: ["Item 1", "Item 2", "Item 3"])
    }
}
