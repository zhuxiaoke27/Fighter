//
//  RestSiteView.swift
//  Fighter
//

import SwiftUI

struct RestSiteView: View {
    @Environment(GameStore.self) private var store
    @State private var showUpgradeSheet = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.12, blue: 0.18),
                    Color(red: 0.05, green: 0.08, blue: 0.12)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 48, weight: .medium))
                    .foregroundStyle(Color(red: 0.90, green: 0.45, blue: 0.20))
                    .shadow(color: Color(red: 0.90, green: 0.45, blue: 0.20).opacity(0.4), radius: 12)
                    .padding(.top, 40)

                Text(String(localized: "label_rest_site"))
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)

                Text(String(localized: "label_hp \(store.player.currentHP) \(store.player.maxHP)"))
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)

                HStack(spacing: 20) {
                    Button {
                        let healAmount = store.player.maxHP / 3
                        store.player.currentHP = min(store.player.maxHP, store.player.currentHP + healAmount)
                        store.completeRestSite()
                    } label: {
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Color(red: 0.30, green: 0.72, blue: 0.42).opacity(0.2))
                                    .frame(width: 80, height: 80)
                                    .overlay(Circle().stroke(Color(red: 0.30, green: 0.72, blue: 0.42).opacity(0.4), lineWidth: 1.5))
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Color(red: 0.85, green: 0.22, blue: 0.18))
                            }
                            Text(String(localized: "btn_rest"))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textPrimary)
                            Text(String(localized: "label_heal_amount \(store.player.maxHP / 3)"))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Color(red: 0.30, green: 0.72, blue: 0.42))
                        }
                        .padding(16)
                        .frame(width: 130)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(red: 0.14, green: 0.13, blue: 0.22)).shadow(color: .black.opacity(0.3), radius: 6, y: 3))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showUpgradeSheet = true
                    } label: {
                        VStack(spacing: 10) {
                            ZStack {
                                Circle()
                                    .fill(Theme.energyColor.opacity(0.2))
                                    .frame(width: 80, height: 80)
                                    .overlay(Circle().stroke(Theme.energyColor.opacity(0.4), lineWidth: 1.5))
                                Image(systemName: "arrow.up.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(Theme.energyColor)
                            }
                            Text(String(localized: "btn_upgrade"))
                                .font(.system(size: 14, weight: .bold, design: .rounded))
                                .foregroundStyle(Theme.textPrimary)
                            Text(String(localized: "label_upgrade_desc"))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.energyColor.opacity(0.8))
                        }
                        .padding(16)
                        .frame(width: 130)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(red: 0.14, green: 0.13, blue: 0.22)).shadow(color: .black.opacity(0.3), radius: 6, y: 3))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.top, 20)

                Spacer()
            }
        }
        .sheet(isPresented: $showUpgradeSheet) {
            upgradeSheet
        }
    }

    private var upgradeSheet: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(store.player.deck) { card in
                        Button {
                            if let idx = store.player.deck.firstIndex(where: { $0.id == card.id }) {
                                store.player.deck[idx] = card.withUpgrade()
                            }
                            showUpgradeSheet = false
                            store.completeRestSite()
                        } label: {
                            VStack(spacing: 4) {
                                Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                                    .font(Theme.cardTitleFont)
                                    .foregroundStyle(card.isUpgraded ? Theme.energyColor : Theme.textPrimary)
                                    .lineLimit(1)
                                Text(String(localized: LocalizedStringResource(stringLiteral: card.descriptionKey)))
                                    .font(Theme.cardDescFont)
                                    .foregroundStyle(Theme.textAccent)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(3)
                                    .minimumScaleFactor(0.7)
                                if card.isUpgraded {
                                    Text("+")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(Theme.energyColor)
                                }
                            }
                            .padding(8)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(card.isUpgraded ? Theme.energyColor.opacity(0.5) : Theme.cardColor(for: card.type).opacity(0.2), lineWidth: 1))
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(card.isUpgraded)
                        .opacity(card.isUpgraded ? 0.4 : 1.0)
                    }
                }
                .padding()
            }
            .background(Theme.background)
            .navigationTitle(String(localized: "label_select_upgrade"))
        }
    }
}
