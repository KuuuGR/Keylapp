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
    var backgroundColor: Color
    var selectedBackgroundColor: Color
    var textColor: Color

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .font(.system(size: (keySize / 2) * 0.4, weight: .bold)) // Adjust text size
                        .frame(width: keySize * 2, height: keySize / 2) // Adjust frame size
                        .background(index == selectedIndex ? selectedBackgroundColor : backgroundColor)
                        .cornerRadius(10)
                        .foregroundColor(textColor)
                        .onTapGesture {
                            withAnimation {
                                selectedIndex = index
                            }
                        }
                }
            }
            .padding(.horizontal, 5) // Minimal horizontal padding
        }
        .frame(height: keySize) // Set the frame height based on key size
    }
}

//struct CarouselPicker_Previews: PreviewProvider {
//    static var previews: some View {
//        CarouselPicker(selectedIndex: .constant(0), items: ["Item 1", "Item 2", "Item 3"], keySize: 40, backgroundColor: .logoJeans, selectedBackgroundColor: .logoRed, textColor: .white)
//    }
//}
