//
//  EventView.swift
//  Fighter
//

import SwiftUI

struct EventView: View {
    @Environment(GameStore.self) private var store

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.08, blue: 0.18),
                    Color(red: 0.08, green: 0.05, blue: 0.12)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if let event = store.currentEvent {
                VStack(spacing: 28) {
                    Spacer()

                    Image(systemName: "questionmark.diamond.fill")
                        .font(.system(size: 48, weight: .medium))
                        .foregroundStyle(Color(red: 0.45, green: 0.55, blue: 0.90))
                        .shadow(color: Color(red: 0.45, green: 0.55, blue: 0.90).opacity(0.4), radius: 12)

                    Text(String(localized: LocalizedStringResource(stringLiteral: event.titleKey)))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)

                    Text(String(localized: LocalizedStringResource(stringLiteral: event.descriptionKey)))
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Theme.textAccent)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)

                    VStack(spacing: 12) {
                        ForEach(event.choices) { choice in
                            Button {
                                resolveChoice(choice)
                            } label: {
                                HStack(spacing: 8) {
                                    Image(systemName: "arrow.right.circle")
                                        .font(.system(size: 14))
                                    Text(String(localized: LocalizedStringResource(stringLiteral: choice.textKey)))
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .foregroundStyle(Theme.textPrimary)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.45, green: 0.55, blue: 0.90).opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 8)

                    Spacer()
                }
            }
        }
    }

    private func resolveChoice(_ choice: EventChoice) {
        for effect in choice.effects {
            switch effect {
            case .loseHP(let amount):
                store.player.currentHP = max(0, store.player.currentHP - amount)
                if store.player.currentHP <= 0 {
                    store.endRun(victory: false)
                    return
                }
            case .gainGold(let amount):
                store.player.gold += amount
            case .loseGold(let amount):
                store.player.gold = max(0, store.player.gold - amount)
            case .gainMaxHP(let amount):
                store.player.maxHP += amount
                store.player.currentHP += amount
            case .gainStrength:
                break
            case .addCardToDeck(let templateKey):
                if let card = CardDatabase.card(byKey: templateKey) {
                    store.player.deck.append(card.copy())
                }
            case .removeRandomCard:
                if !store.player.deck.isEmpty {
                    store.player.deck.remove(at: Int.random(in: 0..<store.player.deck.count))
                }
            case .upgradeRandomCard:
                let upgradable = store.player.deck.indices.filter { !store.player.deck[$0].isUpgraded }
                if let idx = upgradable.randomElement() {
                    store.player.deck[idx] = store.player.deck[idx].withUpgrade()
                }
            case .nothing:
                break
            }
        }
        store.completeEvent()
    }
}
