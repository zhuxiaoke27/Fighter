//
//  ShopView.swift
//  Fighter
//

import SwiftUI

struct ShopView: View {
    @Environment(GameStore.self) private var store
    @State private var showRemoveSheet = false
    @State private var showTutorial: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.12, blue: 0.08),
                    Color(red: 0.08, green: 0.10, blue: 0.06),
                    Color(red: 0.06, green: 0.08, blue: 0.04)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Image(systemName: "cart")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color(red: 0.90, green: 0.65, blue: 0.20))
                    Text(String(localized: "label_shop"))
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    HStack(spacing: 3) {
                        Image(systemName: "coins")
                            .font(.system(size: 14))
                        Text("\(store.player.gold)")
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Theme.energyColor)
                    .shadow(color: Theme.energyGlow, radius: 6)
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 20)

                // Cards section
                if !store.shopCards.isEmpty {
                    Text(String(localized: "label_cards"))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.padding)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Array(store.shopCards.enumerated()), id: \.offset) { index, card in
                                shopCardView(card: card, index: index)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                }

                // Relics section
                if !store.shopRelics.isEmpty {
                    Text(String(localized: "label_relics"))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.padding)
                        .padding(.top, 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Array(store.shopRelics.enumerated()), id: \.offset) { index, relic in
                                shopRelicView(relic: relic, index: index)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                }

                // Potions section
                if !store.shopPotions.isEmpty {
                    Text(String(localized: "label_potions"))
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Theme.padding)
                        .padding(.top, 4)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(Array(store.shopPotions.enumerated()), id: \.offset) { index, potion in
                                shopPotionView(potion: potion, index: index)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                }

                // Remove card button
                HStack(spacing: 16) {
                    Button {
                        showRemoveSheet = true
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                            Text(String(localized: "btn_remove_card"))
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                            Text(String(localized: "label_price_75g"))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle((store.player.gold >= 75 && !store.hasRemovedCardThisShopVisit) ? Color(red: 0.90, green: 0.30, blue: 0.25) : Theme.textSecondary.opacity(0.5))
                        .padding(16)
                        .frame(width: 110)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.14, green: 0.13, blue: 0.22)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.90, green: 0.30, blue: 0.25).opacity(0.2), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .disabled(store.player.gold < 75 || store.hasRemovedCardThisShopVisit)
                }
                .padding(.horizontal, Theme.padding)

                Spacer()

                Button {
                    store.completeShop()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.right")
                        Text(String(localized: "btn_leave_shop"))
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
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showRemoveSheet) {
            removeCardSheet
        }
        .onAppear {
            if !store.settings.hasSeenShopTutorial {
                showTutorial = true
            }
        }
        .overlay {
            if showTutorial {
                TutorialOverlay(text: String(localized: "tutorial_shop")) {
                    showTutorial = false
                    store.settings.hasSeenShopTutorial = true
                    SaveManager.shared.saveSettings(store.settings)
                }
            }
        }
    }

    private func shopCardView(card: Card, index: Int) -> some View {
        let price = cardPrice(card.rarity)
        let canAfford = store.player.gold >= price
        return Button {
            guard canAfford else { return }
            HapticManager.impact(.medium)
            store.player.gold -= price
            store.player.deck.append(card.copy())
            store.shopCards.remove(at: index)
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.cardColor(for: card.type).opacity(0.2))
                        .frame(width: 80, height: 50)
                    Image(systemName: card.type.icon)
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
                HStack(spacing: 3) {
                    Image(systemName: "coins")
                        .font(.system(size: 10))
                    Text("\(price)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundStyle(canAfford ? Theme.energyColor : Theme.textSecondary.opacity(0.5))
            }
            .padding(8)
            .frame(width: 90, height: 140)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.14, green: 0.13, blue: 0.20)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(canAfford ? Color(red: 0.85, green: 0.65, blue: 0.20).opacity(0.4) : Color.white.opacity(0.06), lineWidth: canAfford ? 1.5 : 1))
            .shadow(color: canAfford ? Color(red: 0.85, green: 0.65, blue: 0.20).opacity(0.15) : .clear, radius: 6)
        }
        .buttonStyle(.plain)
        .opacity(canAfford ? 1.0 : 0.5)
    }

    private var removeCardSheet: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(store.player.deck) { card in
                        Button {
                            guard store.player.gold >= 75 && !store.hasRemovedCardThisShopVisit else { return }
                            if let idx = store.player.deck.firstIndex(where: { $0.id == card.id }) {
                                store.player.deck.remove(at: idx)
                            }
                            store.player.gold -= 75
                            store.hasRemovedCardThisShopVisit = true
                            showRemoveSheet = false
                        } label: {
                            VStack(spacing: 4) {
                                Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                                    .font(Theme.cardTitleFont)
                                    .foregroundStyle(Theme.textPrimary)
                                    .lineLimit(1)
                                Text(String(localized: LocalizedStringResource(stringLiteral: card.descriptionKey)))
                                    .font(Theme.cardDescFont)
                                    .foregroundStyle(Theme.textAccent)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.7)
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 8).fill(Color(red: 0.14, green: 0.13, blue: 0.22)))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle(String(localized: "label_select_remove"))
        }
    }

    private func cardPrice(_ rarity: CardRarity) -> Int {
        switch rarity {
        case .common:   return 50
        case .uncommon: return 75
        case .rare:     return 150
        case .starter:  return 30
        }
    }


    // MARK: - Shop Relic View

    private func shopRelicView(relic: RelicTemplate, index: Int) -> some View {
        let price = index < store.shopRelicPrices.count ? store.shopRelicPrices[index] : 150
        let canAfford = store.player.gold >= price
        return Button {
            HapticManager.impact(.medium)
            store.purchaseRelic(at: index)
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.85, green: 0.65, blue: 0.20).opacity(0.15))
                        .frame(width: 80, height: 50)
                    Image(systemName: "gem")
                        .font(.system(size: 20))
                        .foregroundStyle(Color(red: 0.85, green: 0.65, blue: 0.20).opacity(0.7))
                }
                Text(String(localized: LocalizedStringResource(stringLiteral: relic.nameKey)))
                    .font(Theme.cardTitleFont)
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                Text(String(localized: LocalizedStringResource(stringLiteral: relic.descriptionKey)))
                    .font(.system(size: 8))
                    .foregroundStyle(Theme.textAccent)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                HStack(spacing: 3) {
                    Image(systemName: "coins")
                        .font(.system(size: 10))
                    Text("\(price)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundStyle(canAfford ? Theme.energyColor : Theme.textSecondary.opacity(0.5))
            }
            .padding(8)
            .frame(width: 90, height: 140)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.14, green: 0.13, blue: 0.22)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(canAfford ? Color(red: 0.85, green: 0.65, blue: 0.20).opacity(0.3) : Color.white.opacity(0.06), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .opacity(canAfford ? 1.0 : 0.5)
    }

    // MARK: - Shop Potion View

    private func shopPotionView(potion: PotionTemplate, index: Int) -> some View {
        let price = index < store.shopPotionPrices.count ? store.shopPotionPrices[index] : 50
        let canAfford = store.player.gold >= price
        let hasEmptySlot = store.player.potions.contains(where: { $0 == nil })
        return Button {
            HapticManager.impact(.medium)
            store.purchasePotion(at: index)
        } label: {
            VStack(spacing: 4) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Theme.potionColor(for: potion.id).opacity(0.15))
                        .frame(width: 80, height: 50)
                    Image(systemName: "drop.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.potionColor(for: potion.id).opacity(0.7))
                }
                Text(String(localized: LocalizedStringResource(stringLiteral: potion.nameKey)))
                    .font(Theme.cardTitleFont)
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)
                Text(String(localized: LocalizedStringResource(stringLiteral: potion.descriptionKey)))
                    .font(.system(size: 8))
                    .foregroundStyle(Theme.textAccent)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                if !hasEmptySlot {
                    Text(String(localized: "label_full"))
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary.opacity(0.5))
                } else {
                    HStack(spacing: 3) {
                        Image(systemName: "coins")
                            .font(.system(size: 10))
                        Text("\(price)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(canAfford ? Theme.energyColor : Theme.textSecondary.opacity(0.5))
                }
            }
            .padding(8)
            .frame(width: 90, height: 140)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.14, green: 0.13, blue: 0.22)))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(canAfford && hasEmptySlot ? Theme.potionColor(for: potion.id).opacity(0.3) : Color.white.opacity(0.06), lineWidth: 1))
        }
        .buttonStyle(.plain)
        .opacity(canAfford && hasEmptySlot ? 1.0 : 0.5)
    }

}
