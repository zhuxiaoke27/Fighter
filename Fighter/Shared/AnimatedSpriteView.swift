//
//  AnimatedSpriteView.swift
//  Fighter
//
//  Pixel art sprite animation system for combat.
//

import SwiftUI

// MARK: - Animation State

enum AnimationState: Equatable {
    case idle
    case attacking
    case hit
    case dying
}

// MARK: - Idle Sprite View (breathing animation)

struct IdleSpriteView: View {
    let frames: [String]
    var frameDuration: Double = 0.6
    let size: CGFloat

    private let startDate = Date()

    var body: some View {
        TimelineView(.periodic(from: .now, by: frameDuration)) { context in
            let elapsed = context.date.timeIntervalSince(startDate)
            let frameIndex = !frames.isEmpty ? Int(elapsed / frameDuration) % frames.count : 0
            Group {
                if frameIndex < frames.count {
                    Image(frames[frameIndex])
                        .resizable()
                        .interpolation(.none)
                } else {
                    Color.clear
                }
            }
            .frame(width: size, height: size)
        }
    }
}

// MARK: - Static Sprite View (single frame)

struct StaticSpriteView: View {
    let imageName: String
    let size: CGFloat

    var body: some View {
        Image(imageName)
            .resizable()
            .interpolation(.none)
            .frame(width: size, height: size)
    }
}

// MARK: - Attack Animation View

struct AttackAnimationView: View {
    let spriteID: String
    let size: CGFloat
    let isPlayerAttack: Bool
    let completion: () -> Void

    @State private var phase: Int = 0

    var body: some View {
        Image(spriteID)
            .resizable()
            .interpolation(.none)
            .frame(width: size, height: size)
            .scaleEffect(scaleForPhase)
            .offset(y: offsetForPhase)
            .onAppear {
                runAttackAnimation()
            }
    }

    private var scaleForPhase: CGFloat {
        switch phase {
        case 1: return 0.85
        case 2: return 1.15
        default: return 1.0
        }
    }

    private var offsetForPhase: CGFloat {
        switch phase {
        case 2: return isPlayerAttack ? -12 : 12
        default: return 0
        }
    }

    private func runAttackAnimation() {
        withAnimation(.easeOut(duration: 0.08)) {
            phase = 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeIn(duration: 0.1)) {
                phase = 2
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            withAnimation(.easeOut(duration: 0.15)) {
                phase = 3
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            completion()
        }
    }
}

// MARK: - Hit Animation View

struct HitAnimationView: View {
    let spriteID: String
    let size: CGFloat
    let completion: () -> Void

    @State private var flashWhite = false
    @State private var shakeOffset: CGFloat = 0
    @State private var redTint = false

    var body: some View {
        Image(spriteID)
            .resizable()
            .interpolation(.none)
            .frame(width: size, height: size)
            .colorMultiply(flashWhite ? .white : (redTint ? Color(red: 1.0, green: 0.5, blue: 0.5) : .white))
            .offset(x: shakeOffset)
            .onAppear {
                runHitAnimation()
            }
    }

    private func runHitAnimation() {
        withAnimation(.easeOut(duration: 0.05)) {
            flashWhite = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            flashWhite = false
            withAnimation(.easeOut(duration: 0.05)) { shakeOffset = 6 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeOut(duration: 0.05)) { shakeOffset = -5 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            withAnimation(.easeOut(duration: 0.05)) { shakeOffset = 4 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeOut(duration: 0.05)) { shakeOffset = 0 }
            redTint = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            withAnimation(.easeOut(duration: 0.1)) {
                redTint = false
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            completion()
        }
    }
}

// MARK: - Death Animation View

struct DeathAnimationView: View {
    let spriteID: String
    let size: CGFloat
    let completion: () -> Void

    @State private var topHalfOffset: CGFloat = 0
    @State private var bottomHalfOffset: CGFloat = 0
    @State private var opacity: Double = 1.0
    @State private var particles: [DeathParticle] = []

    var body: some View {
        ZStack {
            Image(spriteID)
                .resizable()
                .interpolation(.none)
                .frame(width: size, height: size / 2, alignment: .top)
                .clipped()
                .offset(y: topHalfOffset)
                .opacity(opacity)

            Image(spriteID)
                .resizable()
                .interpolation(.none)
                .frame(width: size, height: size / 2, alignment: .bottom)
                .clipped()
                .offset(y: bottomHalfOffset)
                .opacity(opacity)

            ForEach(particles) { p in
                RoundedRectangle(cornerRadius: 1)
                    .fill(p.color)
                    .frame(width: p.size, height: p.size)
                    .offset(x: p.x, y: p.y)
                    .opacity(p.opacity)
            }
        }
        .frame(width: size, height: size)
        .onAppear {
            runDeathAnimation()
        }
    }

    private func runDeathAnimation() {
        withAnimation(.easeOut(duration: 0.4)) {
            topHalfOffset = -15
            bottomHalfOffset = 15
            opacity = 0.2
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let colors: [Color] = [.white, .gray, Color(red: 0.8, green: 0.3, blue: 0.3)]
            for _ in 0..<8 {
                let p = DeathParticle(
                    x: CGFloat.random(in: -size/2...size/2),
                    y: CGFloat.random(in: -size/2...size/2),
                    color: colors.randomElement() ?? .white,
                    size: CGFloat.random(in: 2...4)
                )
                particles.append(p)
            }
            withAnimation(.easeOut(duration: 0.4)) {
                for i in particles.indices {
                    particles[i].x += CGFloat.random(in: -30...30)
                    particles[i].y += CGFloat.random(in: -30...30)
                    particles[i].opacity = 0
                }
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            completion()
        }
    }
}

// MARK: - Death Particle

private struct DeathParticle: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    let color: Color
    let size: CGFloat
    var opacity: Double = 1.0
}

// MARK: - Sprite Image Name Helpers

enum SpriteAssets {
    static func idleFrames(for charClass: CharacterClass) -> [String] {
        switch charClass {
        case .warrior:  return ["warrior_idle_1", "warrior_idle_2"]
        case .assassin: return ["assassin_idle_1", "assassin_idle_2"]
        case .mage:     return ["mage_idle_1", "mage_idle_2"]
        }
    }

    static func staticFrame(for charClass: CharacterClass) -> String {
        switch charClass {
        case .warrior:  return "warrior_idle_1"
        case .assassin: return "assassin_idle_1"
        case .mage:     return "mage_idle_1"
        }
    }

    static func enemySprite(for templateID: String) -> String {
        if templateID == "slime_boss" {
            return "slime_boss"
        }
        return templateID
    }

    static func enemySize(for templateID: String) -> CGFloat {
        templateID.contains("boss") ? 72 : 56
    }
}
