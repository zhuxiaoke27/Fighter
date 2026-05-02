//
//  Card.swift
//  Fighter
//

import Foundation

enum CardType: String, Codable, Sendable {
    case attack, skill, power, status, curse
}

enum CardRarity: String, Codable, Sendable {
    case starter, common, uncommon, rare
}

enum CardTarget: String, Codable, Sendable {
    case enemy
    case allEnemies
    case selfTarget
    case none
}

enum CardTag: String, Codable, Sendable, CaseIterable {
    case exhaust, strength, poison, energy, block, draw
    case multiHit, selfDamage, cardGen
    case starter, offensive, defensive, utility
}

struct Card: Identifiable, Codable, Sendable, Equatable {
    let id: String
    let templateKey: String
    let type: CardType
    let rarity: CardRarity
    let cost: Int
    let target: CardTarget
    let characterClass: CharacterClass?
    let effects: [Effect]
    let upgradedEffects: [Effect]?
    let isExhaust: Bool
    let isInnate: Bool
    let isEthereal: Bool
    let tags: Set<CardTag>

    var isUpgraded: Bool

    var nameKey: String { templateKey }
    var descriptionKey: String { "\(templateKey)_desc" }

    var resolvedEffects: [Effect] {
        isUpgraded ? (upgradedEffects ?? effects) : effects
    }

    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }

    /// Placeholder card used when resolving relic/potion effects that don't originate from a card.
    static let placeholder = Card(
        id: "__placeholder__",
        templateKey: "__placeholder__",
        type: .skill,
        rarity: .starter,
        cost: 0,
        target: .none,
        characterClass: nil,
        effects: [],
        upgradedEffects: nil,
        isExhaust: false,
        isInnate: false,
        isEthereal: false,
        tags: [],
        isUpgraded: false
    )

    func withUpgrade() -> Card {
        Card(
            id: id,
            templateKey: templateKey,
            type: type,
            rarity: rarity,
            cost: cost,
            target: target,
            characterClass: characterClass,
            effects: effects,
            upgradedEffects: upgradedEffects,
            isExhaust: isExhaust,
            isInnate: isInnate,
            isEthereal: isEthereal,
            tags: tags,
            isUpgraded: true
        )
    }

    static func newInstance(
        templateKey: String,
        type: CardType,
        rarity: CardRarity,
        cost: Int,
        target: CardTarget,
        characterClass: CharacterClass? = nil,
        effects: [Effect],
        upgradedEffects: [Effect]? = nil,
        isExhaust: Bool = false,
        isInnate: Bool = false,
        isEthereal: Bool = false,
        tags: Set<CardTag> = []
    ) -> Card {
        Card(
            id: UUID().uuidString,
            templateKey: templateKey,
            type: type,
            rarity: rarity,
            cost: cost,
            target: target,
            characterClass: characterClass,
            effects: effects,
            upgradedEffects: upgradedEffects,
            isExhaust: isExhaust,
            isInnate: isInnate,
            isEthereal: isEthereal,
            tags: tags,
            isUpgraded: false
        )
    }
}
