//
//  KeyboardStats.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import Foundation

struct KeyboardLayoutStats: Codable, Identifiable {
    let id = UUID()
    let name: String
    let likes: Int
    let stats: KeyboardStat
    let layout: [[String]]
    
    struct KeyboardStat: Codable {
        let alt: Double  // alternation
        let roll: Double // rolling
        let one: Double  // one-hand
        let rtl: Double  // redirect
        let red: Double  // redundancy
        let sfb: Double  // SFB
        let sfs: Double  // SFS
        let lh: Double   // left hand
        let rh: Double   // right hand
    }
    
    enum CodingKeys: CodingKey {
        case name, likes, stats, layout
    }
}

extension KeyboardLayoutStats {
    static func loadSampleData() -> [KeyboardLayoutStats] {
        guard let url = Bundle.main.url(forResource: "KeyboardStats", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return []
        }
        
        do {
            return try JSONDecoder().decode([KeyboardLayoutStats].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
            return []
        }
    }
}
