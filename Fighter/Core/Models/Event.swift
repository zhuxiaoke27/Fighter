//
//  Event.swift
//  Fighter
//

import Foundation

struct EventTemplate: Identifiable {
    let id: String
    let titleKey: String
    let descriptionKey: String
    let choices: [EventChoice]
}

struct EventChoice: Identifiable {
    let id = UUID()
    let textKey: String
    let effects: [EventEffect]
}

enum EventEffect {
    case loseHP(Int)
    case gainGold(Int)
    case loseGold(Int)
    case gainMaxHP(Int)
    case addCardToDeck(String)
    case removeRandomCard
    case upgradeRandomCard
    case gainStrength(Int)
    case nothing
}
