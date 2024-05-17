//
//  LayoutInfoView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 17/05/2024.
//

import SwiftUI

struct LayoutInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    let layouts: [KeyboardLayoutInfo] = KeyboardLayoutData.allLayouts()

    var body: some View {
        NavigationView {
            List {
                ForEach(layouts, id: \.id) { layout in // Ensure that each layout has a unique identifier
                    Section(header: Text(layout.name).font(.headline)) {
                        Text(layout.description)
                            .padding()
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Keyboard Layouts Info")
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
            .gesture(
                DragGesture()
                    .onEnded { value in
                        if value.translation.width > -50 { // Swipe right to close
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
            )
        }
        .background(Color.black) // Ensures background color covers entire view
        .foregroundColor(.white)
        .navigationViewStyle(StackNavigationViewStyle()) // Ensures proper display on all devices
    }
}

struct LayoutInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LayoutInfoView()
    }
}
