//
//  ActiveSheet.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 16/05/2024.
//

enum ActiveSheet: Identifiable {
    case help
    // Add other cases as needed

    var id: Int {
        switch self {
        case .help:
            return 1
        }
    }
}
