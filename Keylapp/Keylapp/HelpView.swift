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



            Text("How to Use the App")
                .font(.headline)
                .foregroundColor(.white) // Text color adapted for dark mode
                .padding()
            
            Image("HelpScreenImage") // Ensure this image is correctly named in your assets
                .resizable()
                .scaledToFit()
                .frame(width: 600, height: 800)
                .padding(.top, 20)

            Text("Follow the steps to learn how to use the keyboard layouts and customize your experience.")
                .foregroundColor(.gray) // Subtext color adapted for dark mode
                .padding()

            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding(.vertical, 10)  // Increased vertical padding for taller button
            .frame(width: 60, height: 40)  // Explicit height setting
            .background(Color.logoJeans)
            .foregroundColor(.white)
            .cornerRadius(10)

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all)) // Background color for dark mode
        .gesture(DragGesture().onChanged { value in
            // Dismiss the modal if the swipe down gesture is recognized
            if value.translation.height > 100 {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
