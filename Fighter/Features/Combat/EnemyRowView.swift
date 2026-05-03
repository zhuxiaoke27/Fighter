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

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                // Intent badge
                intentView

                // Enemy card
                VStack(spacing: 6) {
                    // Enemy body area
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.22, green: 0.18, blue: 0.30),
                                        Color(red: 0.16, green: 0.13, blue: 0.24)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .frame(width: 90, height: 70)

                        // Hit flash overlay
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.white)
                            .frame(width: 90, height: 70)
                            .opacity(hitFlash ? 0.6 : 0)

                        if !enemy.isAlive {
                            Image(systemName: "xmark")
                                .font(.system(size: 28, weight: .heavy))
                                .foregroundStyle(Color.red.opacity(0.5))
                        } else {
                            // Enemy icon placeholder
                            Image(systemName: enemyIcon)
                                .font(.system(size: 26))
                                .foregroundStyle(Theme.textSecondary.opacity(0.6))
                        }
                    }
                    .onChange(of: enemy.currentHP) { oldHP, newHP in
                        if newHP < oldHP {
                            hitFlash = true
                            withAnimation(.easeOut(duration: 0.25)) {
                                hitFlash = false
                            }
                        }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                isSelected ? Theme.energyColor :
                                    isTarget ? Theme.energyColor.opacity(0.4) :
                                    Color.white.opacity(0.06),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    )
                    .shadow(color: isSelected ? Theme.energyGlow : .black.opacity(0.3), radius: isSelected ? 10 : 3, y: 2)

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
                .opacity(enemy.isAlive ? 1.0 : 0.3)
            }
        }
        .buttonStyle(.plain)
        .disabled(!enemy.isAlive)
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
