//
//  SettingsView.swift
//  Fighter
//

import SwiftUI

struct SettingsView: View {
    @Environment(GameStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var showResetStatsAlert = false
    @State private var showResetUnlocksAlert = false

    var body: some View {
        NavigationStack {
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

                VStack(spacing: 0) {
                    settingsRow(
                        icon: "globe",
                        label: String(localized: "settings_language"),
                        color: Theme.energyColor
                    ) {
                        Picker("", selection: Binding(
                            get: { store.settings.language },
                            set: { store.settings.language = $0 }
                        )) {
                            ForEach(AppLanguage.allCases, id: \.self) { lang in
                                Text(lang == .system ? String(localized: "settings_lang_system") : (lang == .en ? "English" : "中文"))
                                    .font(.system(size: 14, design: .rounded))
                                    .tag(lang)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(Theme.textSecondary)
                    }

                    Divider().background(Color.white.opacity(0.06))

                    settingsRow(
                        icon: "hand.tap",
                        label: String(localized: "settings_haptic"),
                        color: Color(red: 0.60, green: 0.30, blue: 0.85)
                    ) {
                        Toggle("", isOn: Binding(
                            get: { store.settings.hapticFeedback },
                            set: { store.settings.hapticFeedback = $0 }
                        ))
                        .tint(Theme.energyColor)
                        .labelsHidden()
                    }

                    Divider().background(Color.white.opacity(0.06))

                    settingsRow(
                        icon: "number.square",
                        label: String(localized: "settings_damage_numbers"),
                        color: Color(red: 0.90, green: 0.35, blue: 0.30)
                    ) {
                        Toggle("", isOn: Binding(
                            get: { store.settings.showDamageNumbers },
                            set: { store.settings.showDamageNumbers = $0 }
                        ))
                        .tint(Theme.energyColor)
                        .labelsHidden()
                    }

                    Spacer()

                    // Destructive actions
                    VStack(spacing: 12) {
                        Button(role: .destructive) {
                            showResetStatsAlert = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "chart.bar.fill")
                                    .font(.system(size: 14))
                                Text(String(localized: "btn_reset_stats"))
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                            }
                            .foregroundStyle(Color(red: 0.85, green: 0.35, blue: 0.30))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 0.85, green: 0.22, blue: 0.18).opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.85, green: 0.22, blue: 0.18).opacity(0.3), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)

                        Button(role: .destructive) {
                            showResetUnlocksAlert = true
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "lock.fill")
                                    .font(.system(size: 14))
                                Text(String(localized: "btn_reset_unlocks"))
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                            }
                            .foregroundStyle(Color(red: 0.85, green: 0.35, blue: 0.30))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(red: 0.85, green: 0.22, blue: 0.18).opacity(0.1))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(red: 0.85, green: 0.22, blue: 0.18).opacity(0.3), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.bottom, 20)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
            .navigationTitle(String(localized: "btn_settings"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .onChange(of: store.settings) { _, _ in
                SaveManager.shared.saveSettings(store.settings)
            }
            .alert(String(localized: "label_reset_stats_confirm"), isPresented: $showResetStatsAlert) {
                Button(String(localized: "btn_reset"), role: .destructive) {
                    StatisticsStore.shared.reset()
                }
                Button(String(localized: "btn_cancel"), role: .cancel) {}
            }
            .alert(String(localized: "label_reset_unlocks_confirm"), isPresented: $showResetUnlocksAlert) {
                Button(String(localized: "btn_reset"), role: .destructive) {
                    UnlockStore.shared.reset()
                }
                Button(String(localized: "btn_cancel"), role: .cancel) {}
            }
        }
    }

    private func settingsRow(
        icon: String,
        label: String,
        color: Color,
        @ViewBuilder trailing: () -> some View
    ) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
                .frame(width: 28)

            Text(label)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textPrimary)

            Spacer()

            trailing()
        }
        .padding(.vertical, 16)
    }
}
