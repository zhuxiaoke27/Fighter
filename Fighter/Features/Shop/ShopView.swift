//
//  ShopView.swift
//  Fighter
//

import SwiftUI

struct ShopView: View {
    @Environment(GameStore.self) private var store
    @State private var showRemoveSheet = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.12, blue: 0.08),
                    Color(red: 0.05, green: 0.08, blue: 0.05)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                HStack {
                    Image(systemName: "cart")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(Color(red: 0.25, green: 0.70, blue: 0.50))
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
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 14) {
                        ForEach(Array(store.shopCards.enumerated()), id: \.offset) { index, card in
                            shopCardView(card: card, index: index)
                        }
                    }
                    .padding(.horizontal, Theme.padding)
                }

                HStack(spacing: 16) {
                    Button {
                        showRemoveSheet = true
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "trash")
                                .font(.system(size: 20))
                            Text(String(localized: "btn_remove_card"))
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                            Text("75g")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(store.player.gold >= 75 ? Color(red: 0.90, green: 0.30, blue: 0.25) : Theme.textSecondary.opacity(0.5))
                        .padding(16)
                        .frame(width: 110)
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(red: 0.14, green: 0.13, blue: 0.22)))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(red: 0.90, green: 0.30, blue: 0.25).opacity(0.2), lineWidth: 1))
                    }
                    .buttonStyle(.plain)
                    .disabled(store.player.gold < 75)
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
    }

    private func shopCardView(card: Card, index: Int) -> some View {
        let price = cardPrice(card.rarity)
        let canAfford = store.player.gold >= price
        return Button {
            guard canAfford else { return }
            store.player.gold -= price
            store.player.deck.append(card.copy())
            store.shopCards.remove(at: index)
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
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(canAfford ? Theme.cardColor(for: card.type).opacity(0.3) : Color.white.opacity(0.06), lineWidth: 1))
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
                            if let idx = store.player.deck.firstIndex(where: { $0.id == card.id }) {
                                store.player.deck.remove(at: idx)
                            }
                            store.player.gold -= 75
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

    private func typeIcon(for type: CardType) -> String {
        switch type {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }
}
