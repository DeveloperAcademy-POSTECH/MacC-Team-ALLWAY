//
//  HapticManager.swift
//  talklat
//
//  Created by user on 2023/10/14.
//

import SwiftUI

class HapticManager {
    static let sharedInstance = HapticManager()
    
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}


struct HapticTestView: View {
    let hapticManager: HapticManager = HapticManager()
    var body: some View {
        Button("Haptic Test") {
            hapticManager.impact(.rigid)
        }
    }
}
