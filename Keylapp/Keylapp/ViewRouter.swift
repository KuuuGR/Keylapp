//
//  ViewRouter.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 13/05/2024.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var currentView: ActiveView = .welcome
}

enum ActiveView {
    case welcome
    case main
}
