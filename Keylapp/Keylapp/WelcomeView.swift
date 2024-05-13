//
//  WelcomeView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("AppLogo").resizable().scaledToFit().frame(width: 200, height: 200)
                Text("Keylapp").font(.largeTitle).fontWeight(.bold)
                Text("Explore customizable keyboard layouts").padding()
                NavigationLink(destination: MainView()) {
                    Text("Explore Layouts")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                Spacer()
            }
        }
    }
}
