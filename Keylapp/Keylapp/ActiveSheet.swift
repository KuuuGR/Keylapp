//
//  ActiveSheet.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 16/05/2024.
//

enum ActiveSheet: Identifiable {
    case help
    case support  // new case

    var id: Int {
        switch self {
        case .help: return 1
        case .support: return 2
        }
    }
}
