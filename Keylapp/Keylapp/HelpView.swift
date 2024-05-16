//
//  HelpView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 16/05/2024.
//

import SwiftUI

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Spacer()

            Image("AppLogo") // Ensure this image is correctly named in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 20)

            Text("How to Use the App")
                .font(.headline)
                .padding()

            Text("Follow the steps to learn how to use the keyboard layouts and customize your experience.")
                .padding()

            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.edgesIgnoringSafeArea(.all))
        .gesture(DragGesture().onChanged { value in
            // Dismiss the modal if the swipe down gesture is recognized
            if value.translation.height > 100 {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}
