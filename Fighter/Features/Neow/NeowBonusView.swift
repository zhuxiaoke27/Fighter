//
//  NeowBonusView.swift
//  Fighter
//

import SwiftUI

struct NeowBonusView: View {
    @Environment(GameStore.self) private var store
    @State private var selectedBonus: NeowBonus? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.04, blue: 0.12),
                    Color(red: 0.03, green: 0.02, blue: 0.06)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "eye.circle")
                    .font(.system(size: 56, weight: .medium))
                    .foregroundStyle(Color(red: 0.60, green: 0.40, blue: 0.85))
                    .shadow(color: Color(red: 0.60, green: 0.40, blue: 0.85).opacity(0.5), radius: 16)
                    .padding(.top, 40)

                Text(String(localized: "neow_title"))
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)

                Text(String(localized: "neow_subtitle"))
                    .font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundStyle(Theme.textAccent)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Spacer()

                VStack(spacing: 14) {
                    ForEach(neowBonuses, id: \.self) { bonus in
                        Button {
                            selectedBonus = bonus
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: bonus.icon)
                                    .font(.system(size: 18))
                                    .frame(width: 32)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(String(localized: LocalizedStringResource(stringLiteral: bonus.titleKey)))
                                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                                    Text(String(localized: LocalizedStringResource(stringLiteral: bonus.descKey)))
                                        .font(.system(size: 11, weight: .regular, design: .rounded))
                                        .foregroundStyle(Theme.textSecondary)
                                }
                                Spacer()
                            }
                            .foregroundStyle(selectedBonus == bonus ? Theme.energyColor : Theme.textPrimary)
                            .padding(14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                                    .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(
                                        selectedBonus == bonus
                                            ? Theme.energyColor.opacity(0.5)
                                            : Color(red: 0.60, green: 0.40, blue: 0.85).opacity(0.15),
                                        lineWidth: selectedBonus == bonus ? 2 : 1
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                        .opacity(selectedBonus == nil || selectedBonus == bonus ? 1.0 : 0.4)
                    }
                }
                .padding(.horizontal, 24)

                Spacer()

                if let bonus = selectedBonus {
                    Button {
                        applyBonus(bonus)
                        store.completeNeow()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.right")
                            Text(String(localized: "btn_begin_adventure"))
                                .font(Theme.buttonFont)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 36)
                        .padding(.vertical, 14)
                        .background(Theme.buttonPrimaryGradient)
                        .clipShape(Capsule())
                        .shadow(color: Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.35), radius: 8, y: 3)
                    }
                    .buttonStyle(.plain)
                    .padding(.bottom, 20)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .animation(.spring(response: 0.3), value: selectedBonus)
        }
    }

    private var neowBonuses: [NeowBonus] {
        [
            NeowBonus(icon: "trash.circle", titleKey: "neow_remove_card", descKey: "neow_remove_card_desc"),
            NeowBonus(icon: "coins", titleKey: "neow_bonus_gold", descKey: "neow_bonus_gold_desc"),
            NeowBonus(icon: "gem", titleKey: "neow_random_relic", descKey: "neow_random_relic_desc"),
            NeowBonus(icon: "heart.circle", titleKey: "neow_bonus_maxhp", descKey: "neow_bonus_maxhp_desc")
        ]
    }

    private func applyBonus(_ bonus: NeowBonus) {
        switch bonus.titleKey {
        case "neow_remove_card":
            let removable = store.player.deck.indices
            if let idx = removable.randomElement() {
                store.player.deck.remove(at: idx)
            }
        case "neow_bonus_gold":
            store.player.gold += 100
        case "neow_random_relic":
            let relic = RelicDatabase.randomRelic(excluding: store.player.relics)
            store.player.relics.append(relic)
        case "neow_bonus_maxhp":
            store.player.maxHP += 5
            store.player.currentHP += 5
        default:
            break
        }
    }
}

private struct NeowBonus: Hashable {
    let icon: String
    let titleKey: String
    let descKey: String
}
