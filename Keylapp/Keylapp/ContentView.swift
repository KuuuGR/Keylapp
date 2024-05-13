//
//  ContentView.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewRouter: ViewRouter

    var body: some View {
        NavigationView {
            Group {
                if viewRouter.currentView == .welcome {
                    WelcomeView()
                } else {
                    MainView()
                }
            }
        }
    }
}
