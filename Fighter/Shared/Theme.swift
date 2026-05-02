//
//  Theme.swift
//  Fighter
//

import SwiftUI

enum Theme {
    // MARK: - Background Colors
    static let background = Color(red: 0.08, green: 0.07, blue: 0.14)
    static let backgroundGradient = LinearGradient(
        colors: [Color(red: 0.10, green: 0.08, blue: 0.18), Color(red: 0.06, green: 0.05, blue: 0.10)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let surfaceColor = Color(red: 0.14, green: 0.13, blue: 0.22)
    static let surfaceElevated = Color(red: 0.18, green: 0.17, blue: 0.27)

    // MARK: - Card Colors
    static let cardBackground = Color(red: 0.16, green: 0.15, blue: 0.24)
    static let cardAttack = Color(red: 0.90, green: 0.30, blue: 0.25)
    static let cardSkill = Color(red: 0.25, green: 0.58, blue: 0.90)
    static let cardPower = Color(red: 0.80, green: 0.58, blue: 0.22)
    static let cardStatusGray = Color.gray.opacity(0.5)

    static func cardColor(for type: CardType) -> Color {
        switch type {
        case .attack: return cardAttack
        case .skill:  return cardSkill
        case .power:  return cardPower
        case .status: return cardStatusGray
        case .curse:  return Color.purple.opacity(0.7)
        }
    }

    static func cardGradient(for type: CardType) -> LinearGradient {
        let color = cardColor(for: type)
        return LinearGradient(
            colors: [color.opacity(0.25), color.opacity(0.05)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - UI Colors
    static let energyColor = Color(red: 1.0, green: 0.82, blue: 0.15)
    static let energyGlow = Color(red: 1.0, green: 0.82, blue: 0.15).opacity(0.4)
    static let healthBarGradient = LinearGradient(
        colors: [Color(red: 0.85, green: 0.22, blue: 0.18), Color(red: 0.70, green: 0.15, blue: 0.12)],
        startPoint: .leading,
        endPoint: .trailing
    )
    static let healthBarBackground = Color(red: 0.18, green: 0.06, blue: 0.05)
    static let blockColor = Color(red: 0.45, green: 0.68, blue: 0.92)
    static let blockGlow = Color(red: 0.45, green: 0.68, blue: 0.92).opacity(0.3)

    // MARK: - Text Colors
    static let textPrimary = Color(red: 0.95, green: 0.95, blue: 0.97)
    static let textSecondary = Color(red: 0.55, green: 0.55, blue: 0.62)
    static let textAccent = Color(red: 0.65, green: 0.65, blue: 0.72)

    // MARK: - Button Colors
    static let buttonPrimaryGradient = LinearGradient(
        colors: [Color(red: 0.30, green: 0.58, blue: 0.88), Color(red: 0.20, green: 0.45, blue: 0.75)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let buttonEndTurnGradient = LinearGradient(
        colors: [Color(red: 0.28, green: 0.62, blue: 0.35), Color(red: 0.18, green: 0.48, blue: 0.25)],
        startPoint: .top,
        endPoint: .bottom
    )
    static let buttonDangerGradient = LinearGradient(
        colors: [Color(red: 0.80, green: 0.25, blue: 0.22), Color(red: 0.65, green: 0.18, blue: 0.15)],
        startPoint: .top,
        endPoint: .bottom
    )

    // MARK: - Enemy Intent
    static let enemyIntentAttack = Color(red: 1.0, green: 0.35, blue: 0.30)
    static let enemyIntentDefend = Color(red: 0.40, green: 0.65, blue: 0.92)
    static let enemyIntentBuff = Color(red: 0.45, green: 0.85, blue: 0.50)
    static let enemyIntentDebuff = Color(red: 0.70, green: 0.45, blue: 0.90)

    // MARK: - Shadows
    static let shadowColor = Color.black.opacity(0.5)

    // MARK: - Spacing
    static let cardWidth: CGFloat = 84
    static let cardHeight: CGFloat = 120
    static let cardCornerRadius: CGFloat = 10
    static let padding: CGFloat = 16
    static let smallPadding: CGFloat = 8

    // MARK: - Fonts
    static let cardTitleFont = Font.system(size: 12, weight: .bold, design: .rounded)
    static let cardDescFont = Font.system(size: 9.5, weight: .regular, design: .default)
    static let cardCostFont = Font.system(size: 15, weight: .heavy, design: .rounded)
    static let energyFont = Font.system(size: 22, weight: .heavy, design: .rounded)
    static let healthFont = Font.system(size: 13, weight: .bold, design: .rounded)
    static let headingFont = Font.system(size: 20, weight: .bold, design: .rounded)
    static let buttonFont = Font.system(size: 16, weight: .bold, design: .rounded)
    static let captionFont = Font.system(size: 11, weight: .medium, design: .rounded)
    static let enemyNameFont = Font.system(size: 13, weight: .bold, design: .rounded)
    static let enemyIntentFont = Font.system(size: 13, weight: .heavy, design: .rounded)
}

// MARK: - View Modifier for Card Shadow
struct CardShadow: ViewModifier {
    let isSelected: Bool
    func body(content: Content) -> some View {
        content
            .shadow(color: Theme.shadowColor, radius: 4, y: 2)
            .shadow(color: isSelected ? Theme.energyGlow : .clear, radius: 12, y: -2)
    }
}

// MARK: - Glow Effect
struct GlowBorder: ViewModifier {
    let color: Color
    let lineWidth: CGFloat
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(color, lineWidth: lineWidth)
                    .blur(radius: 2)
                    .opacity(0.5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(color, lineWidth: lineWidth / 2)
            )
    }
}
