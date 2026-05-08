//
//  StatisticsView.swift
//  Fighter
//

import SwiftUI

struct StatisticsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appeared = false
    private var stats: GameStatistics { StatisticsStore.shared.stats }

    private func animatedValue(_ value: Int) -> Int {
        appeared ? value : 0
    }

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

            ScrollView {
                VStack(spacing: 20) {
                    headerSection
                    winRateSection
                    countersGrid
                    perCharacterSection
                    ascensionSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                appeared = true
            }
        }
    }

    // MARK: - Header

    private var headerSection: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 32, weight: .medium))
                    .foregroundStyle(Theme.energyColor)
                Text(String(localized: "label_statistics"))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
            }
            Spacer()
        }
        .overlay(alignment: .topTrailing) {
            Button { dismiss() } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 20)
    }

    // MARK: - Win Rate

    private var winRateSection: some View {
        VStack(spacing: 12) {
            Text(String(localized: "label_win_rate"))
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            ZStack {
                Circle()
                    .stroke(Color(red: 0.20, green: 0.18, blue: 0.28), lineWidth: 10)
                    .frame(width: 100, height: 100)
                Circle()
                    .trim(from: 0, to: stats.winRate)
                    .stroke(
                        LinearGradient(
                            colors: [Color(red: 0.30, green: 0.72, blue: 0.42), Theme.energyColor],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .frame(width: 100, height: 100)
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(Int(stats.winRate * 100))%")
                        .font(.system(size: 22, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    Text("\(stats.totalRuns) runs")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
        )
    }

    // MARK: - Counters

    private var countersGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            statCard(icon: "trophy.fill", color: Theme.energyColor, title: String(localized: "stat_wins"), value: "\(animatedValue(stats.totalWins))")
            statCard(icon: "skull.fill", color: Color(red: 0.85, green: 0.22, blue: 0.18), title: String(localized: "stat_deaths"), value: "\(animatedValue(stats.totalDeaths))")
            statCard(icon: "flame.fill", color: Color(red: 0.90, green: 0.45, blue: 0.20), title: String(localized: "stat_streak"), value: "\(animatedValue(stats.bestWinStreak))")
            statCard(icon: "crown.fill", color: Color(red: 0.95, green: 0.75, blue: 0.20), title: String(localized: "stat_bosses"), value: "\(animatedValue(stats.bossesDefeated))")
            statCard(icon: "coins.fill", color: Theme.energyColor, title: String(localized: "stat_gold"), value: "\(animatedValue(stats.totalGoldEarned))")
            statCard(icon: "gem.fill", color: Color(red: 0.70, green: 0.50, blue: 0.90), title: String(localized: "stat_relics"), value: "\(animatedValue(stats.relicsCollected))")
        }
    }

    private func statCard(icon: String, color: Color, title: String, value: String) -> some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(color)
            Text(value)
                .font(.system(size: 18, weight: .heavy, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
            Text(title)
                .font(.system(size: 10, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
        )
    }

    // MARK: - Per Character

    private var perCharacterSection: some View {
        VStack(spacing: 10) {
            Text(String(localized: "label_per_character"))
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            ForEach(CharacterClass.allCases, id: \.rawValue) { charClass in
                let key = charClass.rawValue
                let asc = stats.highestAscension[key] ?? -1
                HStack(spacing: 10) {
                    Image(systemName: charClass == .warrior ? "shield.fill" : charClass == .assassin ? "bolt.horizontal.fill" : "sparkles")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textAccent)
                        .frame(width: 20)
                    Text(String(localized: LocalizedStringResource(stringLiteral: charClass.localizationKey)))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    if asc >= 0 {
                        Text(asc > 0 ? "Asc \(asc)" : String(localized: "label_cleared"))
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.energyColor)
                    } else {
                        Text("—")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.12, green: 0.11, blue: 0.20))
                .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
        )
    }

    // MARK: - Ascension

    private var ascensionSection: some View {
        VStack(spacing: 10) {
            Text(String(localized: "label_ascension_progress"))
                .font(.system(size: 14, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            ForEach(CharacterClass.allCases, id: \.rawValue) { charClass in
                let key = charClass.rawValue
                let asc = stats.highestAscension[key] ?? 0
                HStack(spacing: 10) {
                    Image(systemName: charClass == .warrior ? "shield.fill" : charClass == .assassin ? "bolt.horizontal.fill" : "sparkles")
                        .font(.system(size: 12))
                        .foregroundStyle(Theme.textAccent)
                        .frame(width: 20)
                    Text(String(localized: LocalizedStringResource(stringLiteral: charClass.localizationKey)))
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    Spacer()
                    Text(asc > 0 ? "Asc \(asc)" : "—")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundStyle(asc > 0 ? Theme.energyColor : Theme.textSecondary)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                )
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(red: 0.12, green: 0.11, blue: 0.20))
                .shadow(color: .black.opacity(0.3), radius: 6, y: 3)
        )
    }
}
