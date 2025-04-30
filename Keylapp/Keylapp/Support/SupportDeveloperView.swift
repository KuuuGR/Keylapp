//
//  SupportDeveloperView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 30/04/2025.
//

import SwiftUI

struct SupportDeveloperView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Text("Support the Developer")
                .font(.title)
                .fontWeight(.bold)
                .padding()

            Text("If you enjoy using Keylapp, consider buying me a coffee. Your support helps me continue improving the app.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                if let url = URL(string: "https://www.paypal.me/etaosin") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("☕ Buy Me a Coffee")
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)

            Spacer()

            Button("Close") {
                presentationMode.wrappedValue.dismiss()
            }
            .padding()
            .background(Color.logoJeans)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}
