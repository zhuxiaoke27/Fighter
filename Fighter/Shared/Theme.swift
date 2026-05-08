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

    // MARK: - Rich Card Gradients
    static func cardRichGradient(for type: CardType) -> LinearGradient {
        let color = cardColor(for: type)
        return LinearGradient(
            colors: [
                color.opacity(0.45),
                color.opacity(0.25),
                color.opacity(0.10),
                Color(red: 0.10, green: 0.09, blue: 0.16)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Act-Themed Particle Colors
    static func particleColors(for act: Int) -> [Color] {
        switch act {
        case 1: return [
            Color(red: 1.0, green: 0.55, blue: 0.20).opacity(0.6),
            Color(red: 0.95, green: 0.35, blue: 0.15).opacity(0.4),
            Color(red: 1.0, green: 0.75, blue: 0.30).opacity(0.3)
        ]
        case 2: return [
            Color(red: 0.50, green: 0.75, blue: 1.0).opacity(0.5),
            Color(red: 0.70, green: 0.85, blue: 1.0).opacity(0.3),
            Color.white.opacity(0.2)
        ]
        case 3: return [
            Color(red: 0.60, green: 0.30, blue: 0.85).opacity(0.5),
            Color(red: 0.40, green: 0.20, blue: 0.60).opacity(0.4),
            Color(red: 0.80, green: 0.50, blue: 1.0).opacity(0.3)
        ]
        default: return [Color.white.opacity(0.2)]
        }
    }

    // MARK: - Act-Themed Combat Background
    static func combatBackground(for act: Int) -> LinearGradient {
        switch act {
        case 1: return LinearGradient(colors: [
            Color(red: 0.12, green: 0.08, blue: 0.10),
            Color(red: 0.08, green: 0.05, blue: 0.08),
            Color(red: 0.06, green: 0.04, blue: 0.06)
        ], startPoint: .top, endPoint: .bottom)
        case 2: return LinearGradient(colors: [
            Color(red: 0.08, green: 0.10, blue: 0.16),
            Color(red: 0.05, green: 0.07, blue: 0.12),
            Color(red: 0.04, green: 0.05, blue: 0.09)
        ], startPoint: .top, endPoint: .bottom)
        case 3: return LinearGradient(colors: [
            Color(red: 0.10, green: 0.06, blue: 0.16),
            Color(red: 0.07, green: 0.04, blue: 0.12),
            Color(red: 0.05, green: 0.03, blue: 0.09)
        ], startPoint: .top, endPoint: .bottom)
        default: return backgroundGradient
        }
    }

    // MARK: - Screen Backgrounds
    static let shopBackground = LinearGradient(colors: [
        Color(red: 0.10, green: 0.12, blue: 0.08),
        Color(red: 0.08, green: 0.10, blue: 0.06),
        Color(red: 0.06, green: 0.08, blue: 0.04)
    ], startPoint: .top, endPoint: .bottom)

    static let rewardBackground = LinearGradient(colors: [
        Color(red: 0.12, green: 0.10, blue: 0.06),
        Color(red: 0.08, green: 0.07, blue: 0.04),
        Color(red: 0.06, green: 0.05, blue: 0.03)
    ], startPoint: .top, endPoint: .bottom)

    static let eventBackground = LinearGradient(colors: [
        Color(red: 0.10, green: 0.06, blue: 0.14),
        Color(red: 0.07, green: 0.04, blue: 0.10),
        Color(red: 0.05, green: 0.03, blue: 0.08)
    ], startPoint: .top, endPoint: .bottom)

    static let restSiteBackground = LinearGradient(colors: [
        Color(red: 0.10, green: 0.08, blue: 0.06),
        Color(red: 0.08, green: 0.06, blue: 0.04),
        Color(red: 0.06, green: 0.04, blue: 0.03)
    ], startPoint: .top, endPoint: .bottom)

    // MARK: - Rarity Glow Colors
    static let rareGlow = Color(red: 1.0, green: 0.85, blue: 0.30)
    static let uncommonGlow = Color(red: 0.35, green: 0.55, blue: 0.90)
    static let upgradedGlow = Color(red: 0.30, green: 0.85, blue: 0.50)

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
    let isUpgraded: Bool

    init(isSelected: Bool, isUpgraded: Bool = false) {
        self.isSelected = isSelected
        self.isUpgraded = isUpgraded
    }

    func body(content: Content) -> some View {
        content
            .shadow(color: Theme.shadowColor, radius: 4, y: 2)
            .shadow(color: isSelected ? Theme.energyGlow : .clear, radius: 12, y: -2)
            .shadow(color: isUpgraded && !isSelected ? Theme.upgradedGlow.opacity(0.3) : .clear, radius: 8, y: 0)
    }
}

// MARK: - Shimmer Effect
struct ShimmerEffect: ViewModifier {
    let color: Color
    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        colors: [.clear, color.opacity(0.3), .clear],
                        startPoint: .init(x: phase - 0.3, y: 0),
                        endPoint: .init(x: phase + 0.3, y: 0)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
                }
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: false)) {
                    phase = 1.5
                }
            }
    }
}

// MARK: - Particle System
struct Particle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var speed: CGFloat
    var opacity: Double
    var drift: CGFloat
    let colorIndex: Int
}

struct ParticleField: View {
    let colors: [Color]
    let particleCount: Int
    let speedMultiplier: CGFloat
    @State private var particles: [Particle] = []

    init(colors: [Color], particleCount: Int = 20, speedMultiplier: CGFloat = 1.0) {
        self.colors = colors
        self.particleCount = particleCount
        self.speedMultiplier = speedMultiplier
    }

    var body: some View {
        TimelineView(.animation(minimumInterval: 1.0 / 30.0)) { timeline in
            Canvas { context, canvasSize in
                for particle in particles {
                    let color = colors[particle.colorIndex % colors.count]
                    let rect = CGRect(
                        x: particle.x * canvasSize.width,
                        y: particle.y * canvasSize.height,
                        width: particle.size,
                        height: particle.size
                    )
                    context.opacity = particle.opacity
                    context.fill(Circle().path(in: rect), with: .color(color))
                    context.opacity = particle.opacity * 0.4
                    let glowRect = rect.insetBy(dx: -particle.size, dy: -particle.size)
                    context.fill(Circle().path(in: glowRect), with: .color(color.opacity(0.3)))
                }
            }
            .onAppear { initializeParticles() }
            .onChange(of: timeline.date) { _, _ in updateParticles() }
        }
        .allowsHitTesting(false)
    }

    private func initializeParticles() {
        particles = (0..<particleCount).map { i in
            Particle(
                x: .random(in: 0...1), y: .random(in: 0...1),
                size: .random(in: 2...5), speed: .random(in: 0.003...0.012) * speedMultiplier,
                opacity: .random(in: 0.2...0.6), drift: .random(in: -0.002...0.002),
                colorIndex: i % colors.count
            )
        }
    }

    private func updateParticles() {
        for i in particles.indices {
            particles[i].y -= particles[i].speed
            particles[i].x += particles[i].drift
            particles[i].opacity += Double.random(in: -0.02...0.02)
            particles[i].opacity = max(0.1, min(0.6, particles[i].opacity))
            if particles[i].y < -0.05 {
                particles[i].y = 1.05
                particles[i].x = .random(in: 0...1)
            }
        }
    }
}

// MARK: - Pulsing Glow Modifier
struct PulsingGlow: ViewModifier {
    let color: Color
    let radius: CGFloat
    let duration: Double
    @State private var isGlowing = false

    init(color: Color, radius: CGFloat = 12, duration: Double = 2.0) {
        self.color = color
        self.radius = radius
        self.duration = duration
    }

    func body(content: Content) -> some View {
        content
            .shadow(color: isGlowing ? color : color.opacity(0.3), radius: isGlowing ? radius : radius * 0.5)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isGlowing = true
                }
            }
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

// MARK: - CardType Icon Extension

extension CardType {
    var icon: String {
        switch self {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }
}

// MARK: - Potion Color Extension

extension Theme {
    static func potionColor(for id: String) -> Color {
        switch id {
        case "fire_potion":       return Color(red: 0.90, green: 0.30, blue: 0.25)
        case "block_potion":      return blockColor
        case "strength_potion":   return Color(red: 0.85, green: 0.55, blue: 0.20)
        case "weakness_potion":   return Color(red: 0.60, green: 0.40, blue: 0.80)
        case "energy_potion":     return energyColor
        case "elixir_potion":     return Color(red: 0.30, green: 0.85, blue: 0.40)
        case "liquid_memories":   return Color(red: 0.40, green: 0.70, blue: 0.90)
        case "bottled_void":      return Color(red: 0.50, green: 0.30, blue: 0.70)
        case "fear_potion":       return Color(red: 0.60, green: 0.30, blue: 0.80)
        case "swift_potion":      return Color(red: 0.30, green: 0.80, blue: 0.90)
        case "regen_potion":      return Color(red: 0.30, green: 0.85, blue: 0.40)
        case "dual_energy":       return Color(red: 1.0,  green: 0.82, blue: 0.15)
        case "gamblers_brew":     return Color(red: 0.90, green: 0.60, blue: 0.20)
        case "essence_of_steel":  return Color(red: 0.45, green: 0.68, blue: 0.92)
        case "fire_potion_large": return Color(red: 0.90, green: 0.35, blue: 0.15)
        case "ghost_in_a_jar":    return Color(red: 0.70, green: 0.80, blue: 0.95)
        default:                  return textSecondary
        }
    }
}
