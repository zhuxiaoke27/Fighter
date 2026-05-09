//
//  GameOverView.swift
//  Fighter
//

import SwiftUI

struct GameOverView: View {
    let victory: Bool
    @Environment(GameStore.self) private var store
    @State private var newUnlocks: [UnlockableContent] = []
    @State private var showShareSheet = false
    @State private var showQuitConfirm = false

    private var shareText: String {
        let result = victory ? "Victory!" : "Defeated"
        return "\(result) — Act \(store.currentAct) | HP: \(store.player.currentHP)/\(store.player.maxHP) | Gold: \(store.player.gold)g | Cards: \(store.player.deck.count) | Relics: \(store.player.relics.count)"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: victory ? [
                    Color(red: 0.12, green: 0.10, blue: 0.06),
                    Color(red: 0.10, green: 0.08, blue: 0.04),
                    Color(red: 0.08, green: 0.06, blue: 0.03)
                ] : [
                    Color(red: 0.12, green: 0.06, blue: 0.06),
                    Color(red: 0.10, green: 0.04, blue: 0.04),
                    Color(red: 0.08, green: 0.03, blue: 0.03)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Victory: golden particle rain
            if victory {
                ParticleField(
                    colors: [
                        Theme.energyColor.opacity(0.6),
                        Theme.energyColor.opacity(0.3),
                        Color.white.opacity(0.2)
                    ],
                    particleCount: 20,
                    speedMultiplier: 0.6
                )
            }

            // Defeat: red vignette
            if !victory {
                RadialGradient(
                    colors: [.clear, Color(red: 0.30, green: 0.05, blue: 0.05).opacity(0.4)],
                    center: .center,
                    startRadius: 100,
                    endRadius: 400
                )
                .ignoresSafeArea()
            }

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
                    statRow(icon: "flame.fill", value: String(localized: "stat_damage \(store.player.totalDamageDealt)"), color: Color(red: 0.90, green: 0.45, blue: 0.25))
                }
                .padding(.top, 8)

                // Unlock notification
                if !newUnlocks.isEmpty {
                    VStack(spacing: 6) {
                        Image(systemName: "lock.open.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Theme.energyColor)
                        Text(String(localized: "label_new_unlocks"))
                            .font(.system(size: 13, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.energyColor)
                        ForEach(newUnlocks) { unlock in
                            Text(String(localized: LocalizedStringResource(stringLiteral: unlock.nameKey)))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.textAccent)
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Theme.energyColor.opacity(0.1))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Theme.energyColor.opacity(0.3), lineWidth: 1))
                    )
                    .padding(.horizontal, 20)
                }

                Spacer()

                HStack(spacing: 12) {
                    Button {
                        showQuitConfirm = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.counterclockwise")
                            Text(String(localized: "btn_back_menu"))
                                .font(Theme.buttonFont)
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 30)
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

                    Button {
                        showShareSheet = true
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .padding(14)
                            .background(
                                Capsule()
                                    .fill(Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.3))
                                    .overlay(Capsule().stroke(Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.5), lineWidth: 1))
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            HapticManager.notification(victory ? .success : .error)
            // Unlock checking already happened in GameStore before arriving here,
            // but we can re-check to find what was newly unlocked
            let stats = StatisticsStore.shared.stats
            newUnlocks = UnlockableContent.allCases.filter {
                UnlockStore.shared.isUnlocked($0) && $0.isSatisfied(by: stats)
            }
            // Only show recently unlocked (those whose requirement is just barely met)
            let previousRuns = stats.totalRuns - 1
            newUnlocks = newUnlocks.filter { content in
                let req = content.requirement
                switch req.type {
                case .totalRuns: return previousRuns < req.value && stats.totalRuns >= req.value
                case .totalWins: return stats.totalWins == req.value
                case .bossesDefeated: return stats.bossesDefeated == req.value
                case .highestAscension:
                    let best = stats.highestAscension.values.max() ?? 0
                    return best == req.value
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            UIActivityView(activityItems: [shareText])
        }
        .alert(String(localized: "confirm_quit_to_menu"), isPresented: $showQuitConfirm) {
            Button(String(localized: "btn_confirm")) {
                store.quitToMenu()
            }
            Button(String(localized: "btn_cancel"), role: .cancel) {}
        }
    }

    private func statRow(icon: String, value: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(color)
                .frame(width: 20)
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.04))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(color.opacity(0.15), lineWidth: 0.5))
        )
    }
}

// MARK: - Share Sheet Wrapper

struct UIActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
