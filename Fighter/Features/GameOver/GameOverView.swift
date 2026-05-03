//
//  GameOverView.swift
//  Fighter
//

import SwiftUI

struct GameOverView: View {
    let victory: Bool
    @Environment(GameStore.self) private var store

    var body: some View {
        ZStack {
            LinearGradient(
                colors: victory ? [
                    Color(red: 0.12, green: 0.10, blue: 0.06),
                    Color(red: 0.08, green: 0.06, blue: 0.03)
                ] : [
                    Color(red: 0.12, green: 0.06, blue: 0.06),
                    Color(red: 0.08, green: 0.03, blue: 0.03)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: victory ? "trophy.fill" : "skull.fill")
                    .font(.system(size: 64, weight: .medium))
                    .foregroundStyle(victory ? Theme.energyColor : Color(red: 0.85, green: 0.22, blue: 0.18))
                    .shadow(color: victory ? Theme.energyGlow : Color.red.opacity(0.4), radius: 16)
                    .padding(.bottom, 8)

                Text(victory ? String(localized: "label_victory") : String(localized: "label_defeat"))
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(victory ? Theme.energyColor : Color(red: 0.90, green: 0.30, blue: 0.25))

                VStack(spacing: 10) {
                    statRow(icon: "person.fill", value: String(localized: "stat_act \(store.currentAct)"), color: Theme.energyColor)
                    statRow(icon: "heart.fill", value: "\(store.player.currentHP)/\(store.player.maxHP)", color: Color(red: 0.85, green: 0.22, blue: 0.18))
                    statRow(icon: "coins", value: "\(store.player.gold)g", color: Theme.energyColor)
                    statRow(icon: "rectangle.stack", value: String(localized: "stat_cards \(store.player.deck.count)"), color: Theme.textSecondary)
                    statRow(icon: "gem", value: String(localized: "stat_relics \(store.player.relics.count)"), color: Color(red: 0.70, green: 0.50, blue: 0.90))
                    statRow(icon: "skull.fill", value: String(localized: "stat_killed \(store.player.enemiesKilled)"), color: Color(red: 0.70, green: 0.35, blue: 0.90))
                    statRow(icon: "sword.fill", value: String(localized: "stat_played \(store.player.cardsPlayed)"), color: Color(red: 0.90, green: 0.35, blue: 0.30))
                    statRow(icon: "map.fill", value: String(localized: "stat_floors \(store.player.floorsVisited)"), color: Theme.textSecondary)
                }
                .padding(.top, 8)

                Spacer()

                Button {
                    store.gameState = .menu
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.counterclockwise")
                        Text(String(localized: "btn_back_menu"))
                            .font(Theme.buttonFont)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)
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
                .padding(.bottom, 40)
            }
        }
    }

    private func statRow(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textSecondary)
        }
    }
}
