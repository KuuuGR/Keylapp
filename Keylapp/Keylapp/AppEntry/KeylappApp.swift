//
//  KeylappApp.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

@main
struct KeylappApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewRouter())
                .preferredColorScheme(.dark) // Set default color scheme to dark mode
        }
    }
}
