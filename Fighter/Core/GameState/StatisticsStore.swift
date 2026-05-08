//
//  StatisticsStore.swift
//  Fighter
//

import Foundation

final class StatisticsStore {
    static let shared = StatisticsStore()

    private let key = "fighter_statistics"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private(set) var stats: GameStatistics = GameStatistics()

    private init() {
        load()
    }

    // MARK: - Persistence

    func save() {
        if let data = try? encoder.encode(stats) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? decoder.decode(GameStatistics.self, from: data) else {
            return
        }
        stats = decoded
    }

    // MARK: - Recording

    func recordRun(character: String, won: Bool, ascension: Int) {
        stats.totalRuns += 1
        if won {
            stats.totalWins += 1
            stats.currentWinStreak += 1
            if stats.currentWinStreak > stats.bestWinStreak {
                stats.bestWinStreak = stats.currentWinStreak
            }
            let currentBest = stats.highestAscension[character] ?? 0
            if ascension > currentBest {
                stats.highestAscension[character] = ascension
            }
        } else {
            stats.totalDeaths += 1
            stats.currentWinStreak = 0
        }
        save()
    }

    func addGoldEarned(_ amount: Int) {
        stats.totalGoldEarned += amount
        save()
    }
}
