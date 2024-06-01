//
//  HapticsManager.swift
//  TastySwipe
//
//  Created by Nursultan Yelemessov on 16/02/2024.
//

import Foundation
import UIKit

fileprivate final class HapticsManager {
    
    static let shared = HapticsManager()
    
    private let feedback = UINotificationFeedbackGenerator()
    
    private init() {}
    
    func trigger(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
        feedback.notificationOccurred(notification)
    }
}

func haptic(_ notification: UINotificationFeedbackGenerator.FeedbackType) {
    if UserDefaults.standard.bool(forKey: UserDefaultsKey.hapticEnabled) {
        HapticsManager.shared.trigger(notification)
    }
}
