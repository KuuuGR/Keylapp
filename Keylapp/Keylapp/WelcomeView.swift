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
            Image("AppLogo")  // Ensure the logo image is added in assets
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding(.bottom, 20)  // Provides spacing between the logo and the text

            // App Name
            Text("Keylapp")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.primary)  // Ensures that the text color adapts to light/dark mode
                .padding(.bottom, 10)  // Adds space between the title and the subtitle

            // Subtitle or description
            Text("Explore customizable keyboard layouts")
                .font(.title3)
                .foregroundColor(Color.secondary)  // A lighter color for less emphasis
                .padding(.bottom, 50)  // Space before the navigation button

            // Navigation Button to MainView
            NavigationLink(destination: MainView()) {
                Text("Explore Layouts")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 280, height: 50)  // Ensures the button is wide and easy to tap
                    .background(Color.blue)
                    .cornerRadius(25)
                    .shadow(radius: 5)
            }

            Spacer()
        }
        .padding()  // Adds padding around the entire VStack to give some space from screen edges
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
