//
//  EnemyRowView.swift
//  Fighter
//

import SwiftUI

struct EnemyRowView: View {
    let enemies: [CombatEnemy]
    let isTargetSelection: Bool
    let selectedTargetID: UUID?
    let onEnemyTap: (CombatEnemy) -> Void
    var onEnemyFrameUpdate: ((UUID, CGRect) -> Void)? = nil

    var body: some View {
        HStack(spacing: 24) {
            ForEach(enemies) { enemy in
                EnemyView(
                    enemy: enemy,
                    isTarget: isTargetSelection,
                    isSelected: enemy.id == selectedTargetID
                ) {
                    onEnemyTap(enemy)
                }
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear {
                                onEnemyFrameUpdate?(enemy.id, geo.frame(in: .global))
                            }
                            .onChange(of: geo.frame(in: .global)) { _, newFrame in
                                onEnemyFrameUpdate?(enemy.id, newFrame)
                            }
                    }
                )
            }
        }
    }
}

struct EnemyView: View {
    let enemy: CombatEnemy
    let isTarget: Bool
    let isSelected: Bool
    let onTap: () -> Void

    @State private var hitFlash = false
    @State private var shakeOffset: CGFloat = 0
    @State private var deathOpacity: Double = 1.0

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Intent badge
                intentView

                // Enemy card
                VStack(spacing: 6) {
                    // Enemy body area — larger with per-enemy theme
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(enemyThemedGradient)
                            .frame(width: 100, height: 80)

                        // Glow overlay
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                RadialGradient(
                                    colors: [enemyThemeColor.opacity(0.15), .clear],
                                    center: .center,
                                    startRadius: 0,
                                    endRadius: 40
                                )
                            )
                            .frame(width: 100, height: 80)

                        // Hit flash overlay
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                            .frame(width: 100, height: 80)
                            .opacity(hitFlash ? 0.6 : 0)

                        if !enemy.isAlive {
                            Image(systemName: "xmark")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundStyle(Color.red.opacity(0.5))
                        } else {
                            // Enemy icon with theme color
                            Image(systemName: enemyIcon)
                                .font(.system(size: isBoss ? 32 : 26))
                                .foregroundStyle(enemyThemeColor.opacity(0.7))
                        }
                    }
                    .offset(x: shakeOffset)
                    .onChange(of: enemy.currentHP) { oldHP, newHP in
                        if newHP < oldHP {
                            hitFlash = true
                            withAnimation(.easeOut(duration: 0.08)) { shakeOffset = 8 }
                            withAnimation(.easeOut(duration: 0.08).delay(0.08)) { shakeOffset = -6 }
                            withAnimation(.easeOut(duration: 0.08).delay(0.16)) { shakeOffset = 4 }
                            withAnimation(.easeOut(duration: 0.08).delay(0.24)) { shakeOffset = 0 }
                            withAnimation(.easeOut(duration: 0.25)) { hitFlash = false }
                        }
                    }
                    .onChange(of: enemy.isAlive) { wasAlive, isAlive in
                        if wasAlive && !isAlive {
                            withAnimation(.easeOut(duration: 0.6)) {
                                deathOpacity = 0.2
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isSelected ? Theme.energyColor :
                                    isTarget ? Theme.energyColor.opacity(0.4) :
                                    enemyThemeColor.opacity(0.2),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                    .shadow(color: isSelected ? Theme.energyGlow : enemyThemeColor.opacity(0.15), radius: isSelected ? 10 : 3, y: 2)

                    // Name + HP section
                    VStack(spacing: 4) {
                        Text(String(localized: LocalizedStringResource(stringLiteral: "enemy_\(enemy.templateID)")))
                            .font(Theme.enemyNameFont)
                            .foregroundStyle(Theme.textPrimary)
                            .lineLimit(1)

                        // HP bar
                        HealthBarView(
                            current: max(0, enemy.currentHP),
                            max: enemy.maxHP,
                            barGradient: Theme.healthBarGradient,
                            backgroundColor: Theme.healthBarBackground
                        )
                        .frame(width: 72, height: 8)

                        Text("\(max(0, enemy.currentHP))/\(enemy.maxHP)")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)

                        // Block indicator
                        if enemy.block > 0 {
                            HStack(spacing: 3) {
                                Image(systemName: "shield.fill")
                                    .font(.system(size: 10))
                                Text("\(enemy.block)")
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                            }
                            .foregroundStyle(Theme.blockColor)
                            .shadow(color: Theme.blockGlow, radius: 4)
                        }

                        // Buffs
                        if !enemy.buffs.isEmpty {
                            HStack(spacing: 3) {
                                ForEach(enemy.buffs.prefix(4)) { buff in
                                    Text("\(buff.type.abbreviation) \(buff.stacks)")
                                        .font(.system(size: 8, weight: .bold, design: .rounded))
                                        .foregroundStyle(buff.type.isDebuff ? .red : .green)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 2)
                                        .background(
                                            Capsule()
                                                .fill(Color.black.opacity(0.6))
                                                .overlay(
                                                    Capsule()
                                                        .stroke(buff.type.isDebuff ? Color.red.opacity(0.3) : Color.green.opacity(0.3), lineWidth: 0.5)
                                                )
                                        )
                                }
                            }
                        }
                    }
                }
                .opacity(deathOpacity)
            }
        }
        .buttonStyle(.plain)
        .disabled(!enemy.isAlive)
    }

    // MARK: - Per-Enemy Theming

    private var isBoss: Bool {
        enemy.templateID.contains("boss")
    }

    private var enemyThemeColor: Color {
        switch enemy.templateID {
        case "cultist":           return Color(red: 0.85, green: 0.25, blue: 0.20)
        case "jaw_worm":          return Color(red: 0.70, green: 0.50, blue: 0.20)
        case "slime", "blue_slime": return Color(red: 0.30, green: 0.65, blue: 0.85)
        case "gremlin_nob":       return Color(red: 0.85, green: 0.40, blue: 0.20)
        case "slime_boss":        return Color(red: 0.40, green: 0.75, blue: 0.50)
        case "fungus_beast":      return Color(red: 0.40, green: 0.70, blue: 0.30)
        case "spheric_guardian":  return Color(red: 0.50, green: 0.60, blue: 0.80)
        case "chosen":            return Color(red: 0.60, green: 0.30, blue: 0.80)
        case "book_of_stabbing":  return Color(red: 0.70, green: 0.20, blue: 0.20)
        case "gremlin_leader":    return Color(red: 0.80, green: 0.55, blue: 0.20)
        case "spire_growth":      return Color(red: 0.45, green: 0.75, blue: 0.40)
        case "transmogrifier":    return Color(red: 0.65, green: 0.40, blue: 0.85)
        case "darkling":          return Color(red: 0.40, green: 0.30, blue: 0.60)
        case "giant_head":        return Color(red: 0.80, green: 0.60, blue: 0.30)
        case "giant_worm":        return Color(red: 0.65, green: 0.35, blue: 0.20)
        default:                  return Theme.textSecondary
        }
    }

    private var enemyThemedGradient: LinearGradient {
        let color = enemyThemeColor
        return LinearGradient(
            colors: [
                color.opacity(0.25),
                Color(red: 0.18, green: 0.15, blue: 0.26),
                Color(red: 0.14, green: 0.12, blue: 0.22)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private var enemyIcon: String {
        switch enemy.templateID {
        case "cultist": return "person.fill"
        case "jaw_worm": return "ant.fill"
        case "slime", "blue_slime": return "drop.fill"
        case "gremlin_nob": return "figure.strengthtraining.functional"
        case "slime_boss": return "snowflake"
        case "fungus_beast": return "leaf.fill"
        case "spheric_guardian": return "shield.fill"
        case "chosen": return "eye.fill"
        case "book_of_stabbing": return "book.fill"
        case "gremlin_leader": return "flag.fill"
        case "spire_growth": return "arrow.up.backward.and.arrow.down.forward"
        case "transmogrifier": return "wand.and.stars"
        case "darkling": return "moon.fill"
        case "giant_head": return "person.fill"
        case "giant_worm": return "ant.fill"
        default: return "skull"
        }
    }

    private var intentView: some View {
        Group {
            if let intent = enemy.nextIntent, enemy.isAlive {
                switch intent {
                case .attack(let damage):
                    HStack(spacing: 3) {
                        Image(systemName: "sword")
                            .font(.system(size: 11, weight: .semibold))
                        Text("\(damage)")
                            .font(Theme.enemyIntentFont)
                    }
                    .foregroundStyle(Theme.enemyIntentAttack)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.enemyIntentAttack.opacity(0.15))
                            .overlay(Capsule().stroke(Theme.enemyIntentAttack.opacity(0.3), lineWidth: 1))
                    )
                case .attackMulti(let hits):
                    let total = hits.reduce(into: 0) { $0 += $1.0 * $1.1 }
                    HStack(spacing: 3) {
                        Image(systemName: "sword")
                            .font(.system(size: 11, weight: .semibold))
                        Text("\(total)")
                            .font(Theme.enemyIntentFont)
                    }
                    .foregroundStyle(Theme.enemyIntentAttack)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.enemyIntentAttack.opacity(0.15))
                            .overlay(Capsule().stroke(Theme.enemyIntentAttack.opacity(0.3), lineWidth: 1))
                    )
                case .defend(let amount):
                    HStack(spacing: 3) {
                        Image(systemName: "shield.fill")
                            .font(.system(size: 11, weight: .semibold))
                        Text("\(amount)")
                            .font(Theme.enemyIntentFont)
                    }
                    .foregroundStyle(Theme.enemyIntentDefend)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.enemyIntentDefend.opacity(0.15))
                            .overlay(Capsule().stroke(Theme.enemyIntentDefend.opacity(0.3), lineWidth: 1))
                    )
                case .buff(let type, let stacks):
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 11, weight: .semibold))
                        Text("\(stacks)")
                            .font(Theme.enemyIntentFont)
                    }
                    .foregroundStyle(Theme.enemyIntentBuff)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.enemyIntentBuff.opacity(0.15))
                            .overlay(Capsule().stroke(Theme.enemyIntentBuff.opacity(0.3), lineWidth: 1))
                    )
                case .debuff(let type, let stacks):
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 11, weight: .semibold))
                        Text("\(stacks)")
                            .font(Theme.enemyIntentFont)
                    }
                    .foregroundStyle(Theme.enemyIntentDebuff)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        Capsule()
                            .fill(Theme.enemyIntentDebuff.opacity(0.15))
                            .overlay(Capsule().stroke(Theme.enemyIntentDebuff.opacity(0.3), lineWidth: 1))
                    )
                case .unknown:
                    Image(systemName: "questionmark.circle.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
