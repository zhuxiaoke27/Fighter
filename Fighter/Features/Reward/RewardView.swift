//
//  RewardView.swift
//  Fighter
//

import SwiftUI

struct RewardView: View {
    @Environment(GameStore.self) private var store
    @State private var selectedCardIndex: Int? = nil

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.08, blue: 0.18),
                    Color(red: 0.06, green: 0.05, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                Image(systemName: "trophy.fill")
                    .font(.system(size: 44, weight: .medium))
                    .foregroundStyle(Theme.energyColor)
                    .shadow(color: Theme.energyGlow, radius: 10)

                Text(String(localized: "label_victory"))
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.energyColor)

                HStack(spacing: 6) {
                    Image(systemName: "coins")
                        .font(.system(size: 16))
                    Text("+\(store.rewardGold)")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                }
                .foregroundStyle(Theme.energyColor)

                // Boss relic choice (3 options)
                if !store.rewardBossRelics.isEmpty {
                    VStack(spacing: 10) {
                        Text(String(localized: "label_choose_boss_relic"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.90))

                        HStack(spacing: 12) {
                            ForEach(Array(store.rewardBossRelics.enumerated()), id: \.offset) { index, relic in
                                Button {
                                    store.takeBossRelic(at: index)
                                } label: {
                                    VStack(spacing: 4) {
                                        Image(systemName: "crown.fill")
                                            .font(.system(size: 18))
                                            .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.90))
                                        Text(String(localized: LocalizedStringResource(stringLiteral: relic.nameKey)))
                                            .font(.system(size: 10, weight: .bold, design: .rounded))
                                            .foregroundStyle(Theme.textPrimary)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(10)
                                    .frame(width: 90, height: 70)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color(red: 0.70, green: 0.35, blue: 0.90).opacity(0.1))
                                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.70, green: 0.35, blue: 0.90).opacity(0.3), lineWidth: 1))
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }

                // Elite/Boss relic reward
                if let relic = store.rewardRelic {
                    Button {
                        store.player.relics.append(relic)
                        store.rewardRelic = nil
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "gem")
                                .font(.system(size: 14))
                            Text(String(localized: LocalizedStringResource(stringLiteral: relic.nameKey)))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Spacer()
                            Text(String(localized: LocalizedStringResource(stringLiteral: "btn_take")))
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(Color(red: 0.70, green: 0.50, blue: 0.90))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.70, green: 0.50, blue: 0.90).opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.70, green: 0.50, blue: 0.90).opacity(0.3), lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 30)
                }

                // Elite/Boss potion reward
                if let potion = store.rewardPotion {
                    Button {
                        store.receivePotion(potion)
                        store.rewardPotion = nil
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 14))
                            Text(String(localized: LocalizedStringResource(stringLiteral: potion.nameKey)))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                            Spacer()
                            Text(String(localized: LocalizedStringResource(stringLiteral: "btn_take")))
                                .font(.system(size: 12, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(Color(red: 0.40, green: 0.80, blue: 0.50))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(red: 0.40, green: 0.80, blue: 0.50).opacity(0.1))
                                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.40, green: 0.80, blue: 0.50).opacity(0.3), lineWidth: 1))
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 30)
                }

                if !store.rewardCards.isEmpty {
                    VStack(spacing: 12) {
                        Text(String(localized: "label_choose_card"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)

                        HStack(spacing: 16) {
                            ForEach(Array(store.rewardCards.enumerated()), id: \.offset) { index, card in
                                rewardCardView(card: card, index: index)
                            }
                        }
                    }
                }

                VStack(spacing: 12) {
                    if selectedCardIndex != nil {
                        Button {
                            let card = store.rewardCards[selectedCardIndex!]
                            store.completeReward(addedCard: card)
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                Text(String(localized: "btn_take_card"))
                                    .font(Theme.buttonFont)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 14)
                            .background(
                                LinearGradient(
                                    colors: [Color(red: 0.30, green: 0.58, blue: 0.88), Color(red: 0.20, green: 0.45, blue: 0.75)],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                            .shadow(color: Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.35), radius: 8, y: 3)
                        }
                        .buttonStyle(.plain)
                    }

                    Button {
                        store.completeReward(addedCard: nil)
                    } label: {
                        Text(String(localized: "btn_skip"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func rewardCardView(card: Card, index: Int) -> some View {
        let isSelected = selectedCardIndex == index
        return Button {
            selectedCardIndex = isSelected ? nil : index
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.cardColor(for: card.type).opacity(0.2))
                        .frame(width: 80, height: 50)
                    Image(systemName: typeIcon(for: card.type))
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.6))
                }

                Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                    .font(Theme.cardTitleFont)
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)

                Text(String(localized: LocalizedStringResource(stringLiteral: card.descriptionKey)))
                    .font(.system(size: 8))
                    .foregroundStyle(Theme.textAccent)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)

                Text(rarityText(card.rarity))
                    .font(.system(size: 9, weight: .bold, design: .rounded))
                    .foregroundStyle(rarityColor(card.rarity))
            }
            .padding(8)
            .frame(width: 90, height: 130)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                    .shadow(color: isSelected ? Theme.energyColor.opacity(0.4) : .black.opacity(0.3), radius: isSelected ? 10 : 4, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Theme.energyColor : Theme.cardColor(for: card.type).opacity(0.3), lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private func typeIcon(for type: CardType) -> String {
        switch type {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }

    private func rarityText(_ rarity: CardRarity) -> String {
        switch rarity {
        case .starter:  return ""
        case .common:   return "Common"
        case .uncommon: return "Uncommon"
        case .rare:     return "Rare"
        }
    }

    private func rarityColor(_ rarity: CardRarity) -> Color {
        switch rarity {
        case .starter:  return Theme.textSecondary
        case .common:   return .white.opacity(0.6)
        case .uncommon: return Color(red: 0.30, green: 0.72, blue: 0.42)
        case .rare:     return Theme.energyColor
        }
    }
}
