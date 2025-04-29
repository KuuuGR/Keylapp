//
//  KeyboardStats.swift
//  Keylapp
//
//  Created by admin on 29/04/2025.
//

import Foundation

struct KeyboardLayoutStats: Codable, Identifiable, Hashable {
    let id = UUID()
    let name: String
    let likes: Int
    let stats: KeyboardStat
    let layout: [[String]]
    
    struct KeyboardStat: Codable, Hashable {
        let alt: Double
        let roll: Double
        let one: Double
        let rtl: Double
        let red: Double
        let sfb: Double
        let sfs: Double
        let lh: Double
        let rh: Double
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
