//
//  Potion.swift
//  Fighter
//

import Foundation

enum PotionTarget: Codable, Sendable {
    case enemy
    case allEnemies
    case selfTarget
    case none
}

struct PotionTemplate: Identifiable, Codable, Sendable, Equatable {
    let id: String
    let nameKey: String
    let descriptionKey: String
    let effects: [Effect]
    let target: PotionTarget
    let rarity: CardRarity
}
