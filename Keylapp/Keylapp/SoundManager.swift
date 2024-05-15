//
//  SoundManager.swift
//  Keylapp
//
//  Created by Grzegorz Kulesza on 15/05/2024.
//

import Foundation
import AudioToolbox

class SoundManager {
    static let shared = SoundManager()
    
    private init() {}
    
    func playSound(for character: String) {
        // Example sound ID for key press. You can map different characters to different sounds if needed.
        AudioServicesPlaySystemSound(1104)
    }
}
