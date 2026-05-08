//
//  Unlocks.swift
//  Fighter
//

import Foundation

enum UnlockableContent: String, CaseIterable, Codable, Sendable, Identifiable {
    case ascensionMode = "ascension_unlock"
    case nightmareDifficulty = "nightmare"
    case rareCardPack = "rare_cards"
    case bossRelicChoice = "boss_relic"
    case characterAssassin = "char_assassin"
    case characterMage = "char_mage"

    var id: String { rawValue }

    var requirement: UnlockRequirement {
        switch self {
        case .ascensionMode:       return UnlockRequirement(type: .totalWins, value: 1)
        case .nightmareDifficulty: return UnlockRequirement(type: .highestAscension, value: 10)
        case .rareCardPack:        return UnlockRequirement(type: .totalRuns, value: 3)
        case .bossRelicChoice:     return UnlockRequirement(type: .bossesDefeated, value: 1)
        case .characterAssassin:   return UnlockRequirement(type: .totalRuns, value: 2)
        case .characterMage:       return UnlockRequirement(type: .totalRuns, value: 5)
        }
    }

    var nameKey: String { "unlock_\(rawValue)" }
    var descriptionKey: String { "unlock_\(rawValue)_desc" }

    func isSatisfied(by stats: GameStatistics) -> Bool {
        let req = requirement
        switch req.type {
        case .totalRuns:       return stats.totalRuns >= req.value
        case .totalWins:       return stats.totalWins >= req.value
        case .highestAscension:
            let best = stats.highestAscension.values.max() ?? 0
            return best >= req.value
        case .bossesDefeated:  return stats.bossesDefeated >= req.value
        }
    }
}

struct UnlockRequirement: Codable, Sendable {
    let type: RequirementType
    let value: Int

    enum RequirementType: String, Codable, Sendable {
        case totalRuns
        case totalWins
        case highestAscension
        case bossesDefeated
    }

    var descriptionKey: String {
        "unlock_req_\(type.rawValue)_\(value)"
    }
}

struct UnlockState: Codable, Sendable {
    var unlocked: Set<UnlockableContent> = []

    var isAscensionUnlocked: Bool { unlocked.contains(.ascensionMode) }
    var isNightmareUnlocked: Bool { unlocked.contains(.nightmareDifficulty) }
    var isAssassinUnlocked: Bool { unlocked.contains(.characterAssassin) }
    var isMageUnlocked: Bool { unlocked.contains(.characterMage) }
    var isBossRelicUnlocked: Bool { unlocked.contains(.bossRelicChoice) }
    var isRareCardPackUnlocked: Bool { unlocked.contains(.rareCardPack) }

    var unlockedCount: Int { unlocked.count }
    var totalCount: Int { UnlockableContent.allCases.count }

    mutating func checkUnlocks(statistics: GameStatistics) -> [UnlockableContent] {
        var newlyUnlocked: [UnlockableContent] = []
        for content in UnlockableContent.allCases {
            if !unlocked.contains(content) && content.isSatisfied(by: statistics) {
                unlocked.insert(content)
                newlyUnlocked.append(content)
            }
        }
        return newlyUnlocked
    }
}
