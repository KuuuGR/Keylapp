//
//  WelcomeView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct WelcomeView: View {
    @State private var logoOpacity = 0.0
    @EnvironmentObject var viewRouter: ViewRouter

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
//            Button("Explore Layouts") {
//                            viewRouter.currentView = .main
//                        }
            NavigationLink(destination: MainView()) {
                Text("Explore Layouts")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 280, height: 50)
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(radius: 5)
                    .onTapGesture {
                        viewRouter.currentView = .main // This updates the view state.
                    }
            }

            Spacer()
        }
        .padding()
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
