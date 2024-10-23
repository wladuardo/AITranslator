//
//  HapticFeedbackService.swift
//  TranslatorGPT
//
//  Created by Vladislav Kovalskii on 23.10.2024.
//


import UIKit

final class HapticFeedbackService {
    static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        generator.impactOccurred()
    }
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }
}