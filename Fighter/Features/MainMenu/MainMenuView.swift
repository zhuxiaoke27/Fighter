//
//  MainMenuView.swift
//  Fighter
//

import SwiftUI

struct MainMenuView: View {
    @Environment(GameStore.self) private var store
    @State private var showSettings = false

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

            // Background orbs
            VStack {
                Spacer().frame(height: 80)
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(Theme.energyColor.opacity(0.03 + Double(i) * 0.01))
                        .frame(width: CGFloat(200 + i * 80), height: CGFloat(200 + i * 80))
                        .offset(y: CGFloat(-40 + i * 30))
                }
                Spacer()
            }

            VStack(spacing: 0) {
                Spacer()

                // Title
                VStack(spacing: 8) {
                    Image(systemName: "bolt.ring.closed")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(Theme.energyColor)
                        .shadow(color: Theme.energyGlow, radius: 12)
                        .padding(.bottom, 8)

                    Text("FIGHTER")
                        .font(.system(size: 38, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)

                    Text(String(localized: "app_name"))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }

                Spacer()

                // Buttons
                VStack(spacing: 14) {
                    if SaveManager.shared.hasSavedRun {
                        Button {
                            SaveManager.shared.load(into: store)
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.uturn.backward")
                                    .font(.system(size: 14, weight: .semibold))
                                Text(String(localized: "btn_continue_run"))
                                    .font(Theme.buttonFont)
                            }
                            .foregroundStyle(Theme.energyColor)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Theme.energyColor.opacity(0.12))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(Theme.energyColor.opacity(0.4), lineWidth: 1.5)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 50)
                    }

                    Button {
                        store.gameState = .characterSelect
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14, weight: .semibold))
                            Text(String(localized: "btn_new_run"))
                                .font(Theme.buttonFont)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Theme.buttonPrimaryGradient)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.35), radius: 10, y: 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 50)

                    Button {
                        store.player = PlayerState(characterClass: .warrior)
                        store.player.deck = CardDatabase.startingDeck(for: .warrior)
                        store.startCombat(enemies: EnemyDatabase.randomBattle(act: 1))
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 14, weight: .semibold))
                            Text(String(localized: "btn_quick_battle"))
                                .font(Theme.buttonFont)
                        }
                        .foregroundStyle(Theme.energyColor)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(
                                    LinearGradient(
                                        colors: [Theme.energyColor.opacity(0.6), Theme.energyColor.opacity(0.2)],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1.5
                                )
                        )
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 50)

                    Button {
                        showSettings = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 14))
                            Text(String(localized: "btn_settings"))
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(Theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 8)
                }

                Spacer().frame(height: 50)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}
