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
        ZStack(alignment: .leading) {
            Color.black
                .ignoresSafeArea() // Full-screen black background

            HStack(spacing: 0) {
                Spacer().frame(width: 44) // Reserve space for back button

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

                            //Text("• Keyboard Layout Discord Community")
                            /*
                             https://discord.com/invite/sxTV2G5Acg   //2025.04.30
                             https://discord.com/invite/keyboard-layouts //2025.04.30
                            */

                            Group {
                                Button(action: {
                                    if let url = URL(string: "https://www.google.com/search?q=Alt+Keyboard+Layouts+discord") {
                                        UIApplication.shared.open(url)
                                    }
                                }) {
                                    HStack {
                                        Text("• Alt Keyboard Layouts – Discord Community")
                                        Spacer()
                                        Button(action: {
                                            if let url = URL(string: "https://discord.com/invite/keyboard-layouts") {
                                                UIApplication.shared.open(url)
                                            }
                                        }) {
                                            Text("Join")
                                                .foregroundColor(.blue)
                                                .underline()
                                                .font(.subheadline)
                                        }
                                    }
                                }

                                Text("• Open-source layout authors") //
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

                            //                    Button(action: {
                            //                        if let url = URL(string: "https://www.paypal.me/etaosin") {
                            //                            UIApplication.shared.open(url)
                            //                        }
                            //                    }) {
                            //                        Text("☕ Buy Me a Coffee")
                            //                            .fontWeight(.bold)
                            //                            .padding()
                            //                            .frame(maxWidth: 200)
                            //                            .background(Color.logoJeans)
                            //                            .foregroundColor(.white)
                            //                            .cornerRadius(10)
                            //                            .shadow(radius: 5)
                            //                    }
                            //                    .padding(.horizontal)

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
                                    .colorInvert()
                                    .opacity(0.5)
                            }
                            .frame(width: 60, height: 60)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                    .padding()
                }
            }

            // Back arrow button on the far left, vertically centered
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
    }
}
