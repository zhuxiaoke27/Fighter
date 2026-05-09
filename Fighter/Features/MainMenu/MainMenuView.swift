//
//  MainMenuView.swift
//  Fighter
//

import SwiftUI

struct MainMenuView: View {
    @Environment(GameStore.self) private var store
    @State private var showSettings = false
    @State private var showStatistics = false
    @State private var titleGlow = false
    @State private var showContinueConfirm = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.08, blue: 0.18),
                    Color(red: 0.08, green: 0.06, blue: 0.14),
                    Color(red: 0.06, green: 0.05, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Atmospheric particles
            ParticleField(
                colors: [
                    Theme.energyColor.opacity(0.4),
                    Theme.energyColor.opacity(0.2),
                    Color.white.opacity(0.15)
                ],
                particleCount: 25,
                speedMultiplier: 0.5
            )

            // Background glow orbs with radial gradients
            VStack {
                Spacer().frame(height: 80)
                ForEach(0..<3, id: \.self) { i in
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.energyColor.opacity(0.06 + Double(i) * 0.02), .clear],
                                center: .center,
                                startRadius: 0,
                                endRadius: CGFloat(100 + i * 40)
                            )
                        )
                        .frame(width: CGFloat(200 + i * 80), height: CGFloat(200 + i * 80))
                        .offset(y: CGFloat(-40 + i * 30))
                }
                Spacer()
            }

            VStack(spacing: 0) {
                Spacer()

                // Title with pulsing glow
                VStack(spacing: 8) {
                    Image(systemName: "bolt.ring.closed")
                        .font(.system(size: 44, weight: .medium))
                        .foregroundStyle(Theme.energyColor)
                        .modifier(PulsingGlow(color: Theme.energyGlow, radius: 20, duration: 2.5))
                        .padding(.bottom, 8)

                    Text(String(localized: "label_game_title"))
                        .font(.system(size: 38, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                        .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                        .shadow(color: Theme.energyColor.opacity(titleGlow ? 0.15 : 0.05), radius: titleGlow ? 16 : 8)

                    Text(String(localized: "app_name"))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)

                    let runs = StatisticsStore.shared.stats.totalRuns
                    let unlockState = UnlockStore.shared.state
                    if runs > 0 {
                        HStack(spacing: 12) {
                            Text(String(localized: "label_total_runs \(runs)"))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.textSecondary)
                            Text(String(localized: "label_unlock_progress \(unlockState.unlockedCount) \(unlockState.totalCount)"))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.energyColor.opacity(0.8))
                        }
                    }
                }

                Spacer()

                // Buttons
                VStack(spacing: 14) {
                    if SaveManager.shared.hasSavedRun {
                        Button {
                            showContinueConfirm = true
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

                    Button {
                        showStatistics = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chart.bar.fill")
                                .font(.system(size: 14))
                            Text(String(localized: "btn_statistics"))
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                        }
                        .foregroundStyle(Theme.textSecondary)
                    }
                    .buttonStyle(.plain)
                }

                Spacer().frame(height: 50)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $showStatistics) {
            StatisticsView()
        }
        .alert(String(localized: "confirm_continue_run"), isPresented: $showContinueConfirm) {
            Button(String(localized: "btn_confirm")) {
                SaveManager.shared.load(into: store)
            }
            Button(String(localized: "btn_cancel"), role: .cancel) {}
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                titleGlow = true
            }
        }
    }
}
