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
        guard let asciiValue = character.unicodeScalars.first?.value else { return }
        let soundID = 1000 + asciiValue
        AudioServicesPlaySystemSound(SystemSoundID(soundID))
    }
}
