//
//  CommonFunctions.swift
//  QuickveeApp
//
//  Created by Sooraj kahar on 14/01/26.
//

import Foundation
import UIKit
import AudioToolbox


class CommonFunctions {
    
    static func generateHapticFeedback(value : UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(value)
    }
    
    static func vibrate() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
}
