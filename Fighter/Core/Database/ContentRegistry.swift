//
//  ContentRegistry.swift
//  Fighter
//

import Foundation

struct ContentRegistry {
    static var currentSeason: Int = 1

    // MARK: - Card Queries

    static func cards(tag: CardTag? = nil, character: CharacterClass? = nil) -> [Card] {
        var pool = CardDatabase.allCards
        if let tag {
            pool = pool.filter { $0.tags.contains(tag) }
        }
        if let character {
            pool = pool.filter { $0.characterClass == character || $0.characterClass == nil }
        }
        return pool
    }

    // MARK: - Relic Queries

    static func relics(tag: RelicTag? = nil) -> [RelicTemplate] {
        var pool = RelicDatabase.allRelics
        if let tag {
            pool = pool.filter { $0.tags.contains(tag) }
        }
        return pool
    }

    // MARK: - Enemy Queries

    static func enemies(act: Int? = nil, isElite: Bool? = nil) -> [EnemyTemplate] {
        var pool = EnemyDatabase.allEnemies
        if let act {
            pool = pool.filter { $0.act == act }
        }
        if let isElite {
            pool = pool.filter { $0.isElite == isElite && !$0.isBoss }
        }
        return pool
    }

    // MARK: - Season Content Injection

    static func registerSeasonContent(
        _ season: Int,
        cards: [Card] = [],
        relics: [RelicTemplate] = []
    ) {
        _ = (season, cards, relics)
        // Future: append to database arrays for season content
    }
}
