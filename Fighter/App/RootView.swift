//
//  RootView.swift
//  Fighter
//

import SwiftUI

struct RootView: View {
    @State private var store = GameStore()

    var body: some View {
        Group {
            switch store.gameState {
            case .menu:
                MainMenuView()
            case .characterSelect:
                CharacterSelectView()
            case .map:
                MapView()
            case .combat:
                CombatView()
            case .reward:
                RewardView()
            case .shop:
                ShopView()
            case .restSite:
                RestSiteView()
            case .event:
                EventView()
            case .gameOver(let victory):
                GameOverView(victory: victory)
            }
        }
        .background(Theme.background)
        .environment(store)
    }
}

// MARK: - Main Menu

struct MainMenuView: View {
    @Environment(GameStore.self) private var store

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

                VStack(spacing: 14) {
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
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.30, green: 0.58, blue: 0.88),
                                    Color(red: 0.20, green: 0.45, blue: 0.75)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
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
                }

                Spacer().frame(height: 50)
            }
        }
    }
}

// MARK: - Character Select

struct CharacterSelectView: View {
    @Environment(GameStore.self) private var store

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
                Text(String(localized: "label_select_character"))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                    .padding(.top, 40)

                HStack(spacing: 16) {
                    ForEach(CharacterClass.allCases, id: \.rawValue) { charClass in
                        Button {
                            store.startNewRun(characterClass: charClass)
                        } label: {
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            RadialGradient(
                                                colors: [
                                                    characterColor(for: charClass).opacity(0.4),
                                                    characterColor(for: charClass).opacity(0.1)
                                                ],
                                                center: .center,
                                                startRadius: 5,
                                                endRadius: 35
                                            )
                                        )
                                        .frame(width: 72, height: 72)
                                        .overlay(
                                            Circle()
                                                .stroke(characterColor(for: charClass).opacity(0.3), lineWidth: 1.5)
                                        )

                                    Image(systemName: characterIcon(for: charClass))
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundStyle(characterColor(for: charClass))
                                }

                                Text(String(localized: LocalizedStringResource(stringLiteral: charClass.localizationKey)))
                                    .font(.system(size: 14, weight: .bold, design: .rounded))
                                    .foregroundStyle(Theme.textPrimary)

                                HStack(spacing: 4) {
                                    Image(systemName: "heart.fill")
                                        .font(.system(size: 10))
                                        .foregroundStyle(Color(red: 0.85, green: 0.22, blue: 0.18))
                                    Text("\(charClass.baseHP)")
                                        .font(.system(size: 12, weight: .bold, design: .rounded))
                                        .foregroundStyle(Theme.textSecondary)
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 12)
                            .frame(width: 100)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                                    .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(characterColor(for: charClass).opacity(0.15), lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                Button { store.gameState = .menu } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11))
                        Text(String(localized: "btn_back"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(Theme.textSecondary)
                }
                .buttonStyle(.plain)

                Spacer()
            }
        }
    }

    private func characterColor(for charClass: CharacterClass) -> Color {
        switch charClass {
        case .warrior: return Color(red: 0.90, green: 0.30, blue: 0.25)
        case .assassin: return Color(red: 0.60, green: 0.30, blue: 0.85)
        case .mage: return Color(red: 0.25, green: 0.58, blue: 0.90)
        }
    }

    private func characterIcon(for charClass: CharacterClass) -> String {
        switch charClass {
        case .warrior: return "shield.fill"
        case .assassin: return "bolt.fill"
        case .mage: return "flame.fill"
        }
    }
}
