//
//  SceneDelegate.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let orientationController = OrientationViewController()
    var viewRouter: ViewRouter?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let viewRouter = ViewRouter()
        self.viewRouter = viewRouter
        let contentView = ContentView().environmentObject(viewRouter)

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let hostingController = UIHostingController(rootView: contentView)
            orientationController.view = hostingController.view
            window.rootViewController = orientationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        adjustOrientation()
    }

    func adjustOrientation() {
        guard let viewRouter = viewRouter else { return }

        if let rootVC = window?.rootViewController as? OrientationViewController {
            if viewRouter.currentView == .welcome {
                rootVC.setOrientation(.portrait)
            } else {
                rootVC.setOrientation(.landscape)
            }
        }
    }
}
