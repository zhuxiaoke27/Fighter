//
//  Relic.swift
//  Fighter
//

import Foundation

enum RelicTrigger: Codable, Sendable {
    case onCombatStart
    case onTurnStart
    case onTurnEnd
    case onCardPlayed(CardType)
    case onDamageDealt
    case onDamageTaken
    case onBlockGained
    case onEnemyKilled
    case onPotionUsed
    case onGoldGained
    case onCardAdded
    case onShuffle
    case onExhaust
    case onDraw
    case onGainStrength
    case passive
}

enum RelicTag: String, Codable, Sendable, CaseIterable {
    case starter, common, uncommon, rare, boss
    case offensive, defensive, utility, economic
    case warrior, assassin, mage
}

struct RelicEffect: Codable, Sendable {
    let trigger: RelicTrigger
    let effect: Effect
}

struct RelicTemplate: Identifiable, Codable, Sendable {
    let id: String
    let nameKey: String
    let descriptionKey: String
    let effects: [RelicEffect]
    let rarity: CardRarity
    let tags: Set<RelicTag>
    let season: Int?

    init(
        id: String,
        nameKey: String,
        descriptionKey: String,
        effects: [RelicEffect],
        rarity: CardRarity,
        tags: Set<RelicTag> = [],
        season: Int? = nil
    ) {
        self.id = id
        self.nameKey = nameKey
        self.descriptionKey = descriptionKey
        self.effects = effects
        self.rarity = rarity
        self.tags = tags
        self.season = season
    }
}
