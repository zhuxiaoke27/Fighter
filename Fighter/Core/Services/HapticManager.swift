//
//  HapticManager.swift
//  Fighter
//

import UIKit

enum HapticManager {
    private static var isEnabled: Bool {
        guard let data = UserDefaults.standard.data(forKey: "fighter_settings"),
              let settings = try? JSONDecoder().decode(GameSettings.self, from: data) else {
            return true
        }
        return settings.hapticFeedback
    }

    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        guard isEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }

    static func selection() {
        guard isEnabled else { return }
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
