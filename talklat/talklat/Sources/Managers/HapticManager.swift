//
//  HapticManager.swift
//  talklat
//
//  Created by user on 2023/10/14.
//

import SwiftUI

class HapticManager {
    static let sharedInstance = HapticManager()
    
    private func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    private func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
