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

struct BuffBadgeView: View {
    let buff: BuffInstance

    var body: some View {
        Text("\(buff.stacks)")
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
