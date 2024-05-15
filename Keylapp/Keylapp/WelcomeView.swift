//
//  WelcomeView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var logoOpacity = 0.0

    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 20) {
                Spacer()

                Image("AppLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)  // Adjusted size for better fit
                    .opacity(logoOpacity)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            logoOpacity = 1.0
                        }
                    }

                Text("Keylapp")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Explore customizable keyboard layouts")
                    .font(.title3)
                    .foregroundColor(Color.secondary)

                Button(action: {
                    withAnimation {
                        viewRouter.currentView = .main
                    }
                }) {
                    Text("Explore Layouts")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 280, height: 50)
                        .background(Color.logoJeans)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }

                Spacer()
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.horizontal)  // Adds horizontal padding to keep elements away from the very edge
        .overlay(
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Version \(Bundle.main.version) (\(Bundle.main.build))")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding([.bottom, .trailing], 10)
                }
            }
        )
    }
}

extension Bundle {
    var version: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }

    var build: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView().environmentObject(ViewRouter())
    }
}
