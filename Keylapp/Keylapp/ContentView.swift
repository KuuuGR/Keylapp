//
//  ContentView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        Group {
            if viewRouter.currentView == .welcome {
                WelcomeView()
            } else {
                MainView()
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                adjustOrientation()
            }
        }
    }

    func adjustOrientation() {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController as? OrientationViewController {
            rootVC.orientationMask = viewRouter.currentView == .welcome ? .portrait : .landscape
            rootVC.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(ViewRouter())
    }
}
