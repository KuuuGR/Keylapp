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
        VStack {
            Spacer()

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.bottom, 20)
                .opacity(logoOpacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        logoOpacity = 1.0
                    }
                }

            Text("Keylapp")
                .font(.system(size: 34, weight: .bold, design: .default))
                .foregroundColor(Color.primary)
                .padding(.bottom, 10)

            Text("Explore customizable keyboard layouts")
                .font(.title3)
                .foregroundColor(Color.secondary)
                .padding(.bottom, 50)

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
                    .cornerRadius(25)
                    .shadow(radius: 5)
            }

            Spacer()
        }
        .padding()
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
