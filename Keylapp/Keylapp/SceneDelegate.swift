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

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Lock the orientation when the app becomes active
        (UIApplication.shared.delegate as? AppDelegate)?.restrictRotation = .landscape
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Unlock the orientation when the app goes to the background
        (UIApplication.shared.delegate as? AppDelegate)?.restrictRotation = .all
    }
}
