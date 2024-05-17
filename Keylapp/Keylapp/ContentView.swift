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
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active {
                adjustOrientation()
            }
        }
    }

    func adjustOrientation() {
        if let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }),
           let rootVC = window.rootViewController as? OrientationViewController {
            rootVC.setOrientation(viewRouter.currentView == .welcome ? .portrait : .landscape)
        }
    }
}

extension EnvironmentValues {
    var window: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.windows }
            .flatMap { $0 }
            .first { $0.isKeyWindow }
    }
}
