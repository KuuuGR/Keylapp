//
//  ContentView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

// ContentView.swift
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        Group {
            if viewRouter.currentView == .welcome {
                WelcomeView()
                    .onAppear {
                        setOrientation(isPortrait: true)
                    }
            } else {
                MainView()
                    .onAppear {
                        setOrientation(isPortrait: false)
                    }
            }
        }
    }

    // This function sets the device orientation
    private func setOrientation(isPortrait: Bool) {
        UIDevice.current.setValue(isPortrait ? UIInterfaceOrientation.portrait.rawValue : UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
