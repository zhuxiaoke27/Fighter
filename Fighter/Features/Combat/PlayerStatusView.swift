//
//  PlayerStatusView.swift
//  Fighter
//

import SwiftUI

struct PlayerStatusView: View {
    let currentHP: Int
    let maxHP: Int
    let block: Int
    let energy: Int
    let gold: Int
    let buffs: [BuffInstance]

    var body: some View {
        HStack(spacing: 12) {
            // HP section
            VStack(alignment: .leading, spacing: 3) {
                HealthBarView(
                    current: currentHP,
                    max: maxHP,
                    barGradient: Theme.healthBarGradient,
                    backgroundColor: Theme.healthBarBackground
                )
                .frame(width: 130, height: 10)

                HStack(spacing: 8) {
                    Text("\(currentHP)/\(maxHP)")
                        .font(Theme.healthFont)
                        .foregroundStyle(Theme.textPrimary)

                    if block > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 11))
                            Text("\(block)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(Theme.blockColor)
                        .shadow(color: Theme.blockGlow, radius: 3)
                    }
                }
            }

            Spacer()

            // Buffs
            if !buffs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(buffs) { buff in
                            BuffBadgeView(buff: buff)
                        }
                    }
                }
                .frame(maxWidth: 80)
            }

            // Energy orb
            EnergyView(current: energy)

            // Gold
            HStack(spacing: 3) {
                Image(systemName: "coins")
                    .font(.system(size: 12))
                Text("\(gold)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Theme.energyColor)
        }
        .padding(.horizontal, Theme.padding)
        .padding(.vertical, 8)
        .background(
            Rectangle()
                .fill(Color.black.opacity(0.3))
                .blur(radius: 0)
        )
    }
}

// MARK: - Compact Top Bar (energy + gold + floor info)

struct CombatTopBar: View {
    let energy: Int
    let gold: Int
    let floor: Int
    let act: Int

    var body: some View {
        HStack {
            Text(String(localized: "label_act \(act)"))
                .font(.system(size: 13, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            Text("·")
                .foregroundStyle(Theme.textSecondary)

            Text(String(localized: "label_floor \(floor)"))
                .font(Theme.captionFont)
                .foregroundStyle(Theme.textSecondary)

            Spacer()

            EnergyView(current: energy)

            HStack(spacing: 3) {
                Image(systemName: "coins")
                    .font(.system(size: 12))
                Text("\(gold)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Theme.energyColor)
        }
        .padding(.horizontal, Theme.padding)
        .padding(.vertical, 6)
        .background(Color.black.opacity(0.2))
    }
}

// MARK: - Player Character Area (bottom center, facing enemies)

struct CombatPlayerAreaView: View {
    let characterClass: CharacterClass
    let currentHP: Int
    let maxHP: Int
    let block: Int
    let buffs: [BuffInstance]

    private var characterIcon: String {
        switch characterClass {
        case .warrior:  return "figure.strengthtraining.functional"
        case .assassin: return "figure.run"
        case .mage:     return "figure.wave"
        }
    }

    private var characterColor: Color {
        switch characterClass {
        case .warrior:  return Color(red: 0.85, green: 0.35, blue: 0.25)
        case .assassin: return Color(red: 0.40, green: 0.75, blue: 0.45)
        case .mage:     return Color(red: 0.45, green: 0.55, blue: 0.90)
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Character avatar
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [characterColor.opacity(0.3), characterColor.opacity(0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 64, height: 64)
                    .overlay(
                        Circle()
                            .stroke(characterColor.opacity(0.5), lineWidth: 2)
                    )
                    .shadow(color: characterColor.opacity(0.3), radius: 8)

                Image(systemName: characterIcon)
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(characterColor)
            }

            // HP bar + block
            VStack(spacing: 4) {
                HealthBarView(
                    current: currentHP,
                    max: maxHP,
                    barGradient: Theme.healthBarGradient,
                    backgroundColor: Theme.healthBarBackground
                )
                .frame(width: 120, height: 8)

                HStack(spacing: 8) {
                    Text("\(currentHP)/\(maxHP)")
                        .font(Theme.healthFont)
                        .foregroundStyle(Theme.textPrimary)

                    if block > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "shield.fill")
                                .font(.system(size: 10))
                            Text("\(block)")
                                .font(.system(size: 11, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(Theme.blockColor)
                        .shadow(color: Theme.blockGlow, radius: 3)
                    }
                }
            }

            // Buffs
            if !buffs.isEmpty {
                HStack(spacing: 4) {
                    ForEach(buffs.prefix(6)) { buff in
                        BuffBadgeView(buff: buff)
                    }
                }
            }
        }
        .frame(maxWidth: 200)
    }
}

struct BuffBadgeView: View {
    let buff: BuffInstance

    var body: some View {
        Text("\(buff.type.abbreviation) \(buff.stacks)")
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .foregroundStyle(buff.type.isDebuff ? .red : .green)
            .padding(.horizontal, 5)
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

struct HealthBarView: View {
    let current: Int
    let max: Int
    var barGradient: LinearGradient = Theme.healthBarGradient
    var barColor: Color? = nil
    let backgroundColor: Color

    init(current: Int, max: Int, barColor: Color, backgroundColor: Color) {
        self.current = current
        self.max = max
        self.barGradient = LinearGradient(colors: [barColor, barColor], startPoint: .leading, endPoint: .trailing)
        self.barColor = barColor
        self.backgroundColor = backgroundColor
    }

    init(current: Int, max: Int, barGradient: LinearGradient, backgroundColor: Color) {
        self.current = current
        self.max = max
        self.barGradient = barGradient
        self.barColor = nil
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(backgroundColor)

                let width = max > 0 ? geo.size.width * CGFloat(current) / CGFloat(max) : 0
                RoundedRectangle(cornerRadius: 4)
                    .fill(barGradient)
                    .frame(width: width)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(
                                LinearGradient(
                                    colors: [.white.opacity(0.15), .clear],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            }
        }
    }
}
