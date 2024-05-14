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
    var keySize: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .font(.system(size: (keySize / 2) * 0.4, weight: .bold)) // Adjust text size
                        .frame(width: keySize * 2, height: keySize / 2) // Adjust frame size
                        .background(index == selectedIndex ? Color.green : Color.graphiteGray)
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
        .frame(height: keySize) // Set the frame height based on key size
    }
}

struct CarouselPicker_Previews: PreviewProvider {
    static var previews: some View {
        CarouselPicker(selectedIndex: .constant(0), items: ["Item 1", "Item 2", "Item 3"], keySize: 40)
    }
}
