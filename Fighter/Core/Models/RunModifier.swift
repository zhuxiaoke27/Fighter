//
//  RunModifier.swift
//  Fighter
//

import Foundation

enum ModifierEffect: Codable, Sendable {
    case doubleEliteChance
    case extraBossHP(Double)
    case bonusGoldPerFloor(Int)
    case reducedHealing(Double)
    case startWithCurse(String)
}

struct RunModifier: Codable, Identifiable, Sendable {
    let id: String
    let nameKey: String
    let descriptionKey: String
    let effects: [ModifierEffect]
}
