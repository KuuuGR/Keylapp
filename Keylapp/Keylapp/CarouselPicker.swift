//
//  CarouselPicker.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 14/05/2024.
//

import SwiftUI

struct CarouselPicker: View {
    @Binding var selectedLayoutIndex: Int
    let layouts: [KeyboardLayout]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(layouts.indices, id: \.self) { index in
                    Text(layouts[index].name)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 20)
                        .background(self.selectedLayoutIndex == index ? Color.blue : Color.gray.opacity(0.2))
                        .foregroundColor(self.selectedLayoutIndex == index ? .white : .gray)
                        .cornerRadius(10)
                        .shadow(radius: self.selectedLayoutIndex == index ? 10 : 0)
                        .scaleEffect(self.selectedLayoutIndex == index ? 1.1 : 1.0)
                        .onTapGesture {
                            withAnimation {
                                self.selectedLayoutIndex = index
                            }
                        }
                }
            }
        }
        .padding(.horizontal)
    }
}
