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
        ZStack(alignment: .leading) {
            VStack {
                Spacer()

                Text("How to Use the App")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                Image("HelpScreenImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 600, height: 800)
                    .padding(.top, 20)

                Text("Follow the steps to learn how to use the keyboard layouts and customize your experience.")
                    .foregroundColor(.gray)
                    .padding()

                Button("Close") {
                    presentationMode.wrappedValue.dismiss()
                }
                .padding(.vertical, 10)
                .frame(width: 60, height: 40)
                .background(Color.logoJeans)
                .foregroundColor(.white)
                .cornerRadius(10)

                Spacer()
            }

            VStack {
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                Spacer()
            }
            .frame(width: 44)
            .padding(.leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .gesture(DragGesture().onChanged { value in
            if value.translation.height > 100 {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}
