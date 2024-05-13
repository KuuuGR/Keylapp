//
//  MainView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("Welcome to Main View!")
                .font(.title)
                .padding()

            Text("Select a layout from the options below:")
                .padding()

            // Placeholder for keyboard layout selector and view
            Text("Layout options will be here")
                .foregroundColor(.gray)
                .padding()

            Spacer()
        }
        .navigationTitle("Keyboard Layouts")
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}


#Preview {
    MainView()
}
