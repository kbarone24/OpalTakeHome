//
//  HapticGenerator.swift
//  Opal Take Home
//
//  Created by Kenny Barone on 1/24/24.
//

import UIKit

class HapticGenerator {
    static let shared = HapticGenerator()

    private init() { }

    func play(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: feedbackStyle).impactOccurred()
    }

    func notify(_ feedbackType: UINotificationFeedbackGenerator.FeedbackType) {
        UINotificationFeedbackGenerator().notificationOccurred(feedbackType)
    }
}

