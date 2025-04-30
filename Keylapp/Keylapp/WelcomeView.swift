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
    @State private var activeSheet: ActiveSheet?

    var body: some View {
        VStack {
            Spacer()

            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
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

            HStack(spacing: 5) {
                Button(action: {
                    withAnimation {
                        viewRouter.currentView = .main
                    }
                }) {
                    Text("Explore Layouts")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200, height: 40)
                        .background(Color.logoOrange)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    activeSheet = .help
                }) {
                    Text("ⓘ")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 60, height: 40)
                        .background(Color.logoJeans)
                        .cornerRadius(10)
                }
                
                Button(action: {
                    activeSheet = .support
                }) {
                    Text("☕︎")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 60, height: 40)
                        .background(Color.logoJeans)
                        .cornerRadius(10)
                }
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
        .sheet(item: $activeSheet) { item in
            switch item {
            case .help:
                HelpView()
            case .support:
                SupportDeveloperView()
            }
        }
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

//struct WelcomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        WelcomeView().environmentObject(ViewRouter())
//    }
//}
