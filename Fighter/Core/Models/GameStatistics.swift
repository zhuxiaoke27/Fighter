//
//  GameStatistics.swift
//  Fighter
//

import Foundation

struct GameStatistics: Codable, Sendable {
    var totalRuns: Int = 0
    var totalWins: Int = 0
    var totalDeaths: Int = 0
    var highestAscension: [String: Int] = [:]
    var totalCardsPlayed: Int = 0
    var totalDamageDealt: Int = 0
    var totalEnemiesKilled: Int = 0
    var totalGoldEarned: Int = 0
    var bestWinStreak: Int = 0
    var currentWinStreak: Int = 0
    var bossesDefeated: Int = 0
    var relicsCollected: Int = 0
    var potionsUsed: Int = 0

    var winRate: Double {
        totalRuns > 0 ? Double(totalWins) / Double(totalRuns) : 0
    }
}
