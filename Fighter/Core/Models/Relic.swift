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
    case passive
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
}
