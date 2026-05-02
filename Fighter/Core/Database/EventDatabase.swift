//
//  EventDatabase.swift
//  Fighter
//

import Foundation

enum EventDatabase {

    static let allEvents: [EventTemplate] = [
        EventTemplate(
            id: "old_beggar",
            titleKey: "event_old_beggar",
            descriptionKey: "event_old_beggar_desc",
            choices: [
                EventChoice(
                    textKey: "event_old_beggar_choice1",
                    effects: [.loseGold(30), .gainMaxHP(5)]
                ),
                EventChoice(
                    textKey: "event_old_beggar_choice2",
                    effects: [.gainGold(15)]
                )
            ]
        ),
        EventTemplate(
            id: "dark_alley",
            titleKey: "event_dark_alley",
            descriptionKey: "event_dark_alley_desc",
            choices: [
                EventChoice(
                    textKey: "event_dark_alley_choice1",
                    effects: [.gainGold(50), .loseHP(8)]
                ),
                EventChoice(
                    textKey: "event_dark_alley_choice2",
                    effects: [.nothing]
                )
            ]
        ),
        EventTemplate(
            id: "mysterious_shrine",
            titleKey: "event_shrine",
            descriptionKey: "event_shrine_desc",
            choices: [
                EventChoice(
                    textKey: "event_shrine_choice1",
                    effects: [.upgradeRandomCard, .loseHP(5)]
                ),
                EventChoice(
                    textKey: "event_shrine_choice2",
                    effects: [.nothing]
                )
            ]
        ),
        EventTemplate(
            id: "wandering_merchant",
            titleKey: "event_merchant",
            descriptionKey: "event_merchant_desc",
            choices: [
                EventChoice(
                    textKey: "event_merchant_choice1",
                    effects: [.loseGold(50), .gainStrength(1)]
                ),
                EventChoice(
                    textKey: "event_merchant_choice2",
                    effects: [.nothing]
                )
            ]
        ),

        // MARK: - Act 2 Events

        EventTemplate(
            id: "blood_ritual",
            titleKey: "event_blood_ritual",
            descriptionKey: "event_blood_ritual_desc",
            choices: [
                EventChoice(
                    textKey: "event_blood_ritual_choice1",
                    effects: [.loseHP(15), .gainMaxHP(8)]
                ),
                EventChoice(
                    textKey: "event_blood_ritual_choice2",
                    effects: [.nothing]
                )
            ]
        ),
        EventTemplate(
            id: "ancient_library",
            titleKey: "event_ancient_library",
            descriptionKey: "event_ancient_library_desc",
            choices: [
                EventChoice(
                    textKey: "event_ancient_library_choice1",
                    effects: [.loseHP(5), .upgradeRandomCard, .upgradeRandomCard]
                ),
                EventChoice(
                    textKey: "event_ancient_library_choice2",
                    effects: [.nothing]
                )
            ]
        ),
        EventTemplate(
            id: "treasure_chest",
            titleKey: "event_treasure_chest",
            descriptionKey: "event_treasure_chest_desc",
            choices: [
                EventChoice(
                    textKey: "event_treasure_chest_choice1",
                    effects: [.gainGold(80), .loseHP(10)]
                ),
                EventChoice(
                    textKey: "event_treasure_chest_choice2",
                    effects: [.gainMaxHP(3)]
                )
            ]
        ),

        // MARK: - Act 3 Events

        EventTemplate(
            id: "soul_burn",
            titleKey: "event_soul_burn",
            descriptionKey: "event_soul_burn_desc",
            choices: [
                EventChoice(
                    textKey: "event_soul_burn_choice1",
                    effects: [.loseHP(20), .gainMaxHP(12)]
                ),
                EventChoice(
                    textKey: "event_soul_burn_choice2",
                    effects: [.gainGold(100), .loseHP(15)]
                )
            ]
        ),
        EventTemplate(
            id: "forbidden_altar",
            titleKey: "event_forbidden_altar",
            descriptionKey: "event_forbidden_altar_desc",
            choices: [
                EventChoice(
                    textKey: "event_forbidden_altar_choice1",
                    effects: [.loseHP(12), .upgradeRandomCard, .upgradeRandomCard]
                ),
                EventChoice(
                    textKey: "event_forbidden_altar_choice2",
                    effects: [.loseGold(60), .gainMaxHP(6)]
                )
            ]
        ),
        EventTemplate(
            id: "abyss_gate",
            titleKey: "event_abyss_gate",
            descriptionKey: "event_abyss_gate_desc",
            choices: [
                EventChoice(
                    textKey: "event_abyss_gate_choice1",
                    effects: [.loseHP(8), .gainStrength(2)]
                ),
                EventChoice(
                    textKey: "event_abyss_gate_choice2",
                    effects: [.nothing]
                )
            ]
        )
    ]

    static func randomEvent(act: Int = 1) -> EventTemplate {
        allEvents.randomElement()!
    }
}
