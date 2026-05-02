//
//  Event.swift
//  Fighter
//

import Foundation

struct EventTemplate: Identifiable {
    let id: String
    let titleKey: String
    let descriptionKey: String
    let icon: String
    let choices: [EventChoice]
    let act: Int
    let weight: Double
}

struct EventChoice: Identifiable {
    let id = UUID()
    let textKey: String
    let effects: [EventEffect]
}

enum EventEffect {
    case loseHP(Int)
    case gainHP(Int)
    case gainGold(Int)
    case loseGold(Int)
    case gainMaxHP(Int)
    case loseMaxHP(Int)
    case addCardToDeck(String)
    case removeRandomCard
    case removeSpecificCard(String)
    case upgradeRandomCard
    case upgradeRandomCards(Int)
    case gainStrength(Int)
    case gainDexterity(Int)
    case gainBlockPermanent(Int)
    case healPercent(Double)
    case gainRelic(String)
    case gainRandomRelic
    case gainPotion(String)
    case gainRandomPotion
    case randomDebuff
    case transformRandomStrike
    case duplicateRandomCard
    case removeAllStrikes
    case gainEnergyNextCombat(Int)
    case gainGoldPerCard(Int)
    case nothing
}
