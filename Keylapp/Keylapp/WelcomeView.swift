//
//  WelcomeView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()
            
            // App Logo
            Image("AppLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)

            // App Name
            Text("Keylapp")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()
            
            // Navigation Button
            NavigationLink(destination: MainView()) {
                Text("Explore Layouts")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
            .padding()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}


#Preview {
    WelcomeView()
}
