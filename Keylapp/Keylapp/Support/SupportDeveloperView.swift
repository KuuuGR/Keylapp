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
        ScrollView {
            HStack(alignment: .top, spacing: 20) {
                
                // LEFT SIDE – App Info
                VStack(alignment: .leading, spacing: 15) {
                    Text("App Information")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 5)

                    Group {
                        Text("• App Name: Keylapp")
                        Text("• Version: \(Bundle.main.version) (\(Bundle.main.build))")
                        Text("• Developer: Grzegorz Kulesza")
                    }
                    .foregroundColor(.white)

                    Divider().background(Color.gray)

                    Text("Thanks to:")
                        .font(.headline)
                        .padding(.top, 10)

                    Group {
                        Text("• Keyboard Layout Discord Community")
                        Text("• Open-source layout authors")
                        Text("• All testers and contributors ❤️")
                    }
                    .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()

                // RIGHT SIDE – Support
                VStack(spacing: 20) {
                    Text("Support the Developer")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top)

                    Text("If you enjoy using Keylapp, consider buying me a coffee… or even better, some new keycaps :)")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    Button(action: {
                        if let url = URL(string: "https://www.paypal.me/etaosin") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("☕ Buy Me a Coffee")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: 200)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal)

                    Button(action: {
                        if let url = URL(string: "https://www.paypal.me/etaosin") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Image("Paypal_2014_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(10)
                            .background(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .frame(width: 60, height: 60)
                }
                .frame(maxWidth: .infinity)
                .padding()
            }
            .padding()
            .background(Color.black.edgesIgnoringSafeArea(.all))
        }

        Button("Close") {
            presentationMode.wrappedValue.dismiss()
        }
        .padding()
        .background(Color.logoJeans)
        .foregroundColor(.white)
        .cornerRadius(10)
    }
}

