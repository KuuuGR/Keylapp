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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            orientationController.view = UIHostingController(rootView: contentView).view
            window.rootViewController = orientationController
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
