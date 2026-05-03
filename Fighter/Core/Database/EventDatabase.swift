//
//  EventDatabase.swift
//  Fighter
//

import Foundation

enum EventDatabase {

    static let allEvents: [EventTemplate] = [
        // MARK: - Act 1 Events (14 total: 4 original + 10 new)

        EventTemplate(
            id: "old_beggar",
            titleKey: "event_old_beggar",
            descriptionKey: "event_old_beggar_desc",
            icon: "person.fill.questionmark",
            choices: [
                EventChoice(textKey: "event_old_beggar_choice1", effects: [.loseGold(30), .gainMaxHP(5)]),
                EventChoice(textKey: "event_old_beggar_choice2", effects: [.gainGold(15)])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "dark_alley",
            titleKey: "event_dark_alley",
            descriptionKey: "event_dark_alley_desc",
            icon: "moon.haze.fill",
            choices: [
                EventChoice(textKey: "event_dark_alley_choice1", effects: [.gainGold(50), .loseHP(8)]),
                EventChoice(textKey: "event_dark_alley_choice2", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "mysterious_shrine",
            titleKey: "event_shrine",
            descriptionKey: "event_shrine_desc",
            icon: "building.columns.fill",
            choices: [
                EventChoice(textKey: "event_shrine_choice1", effects: [.upgradeRandomCard, .loseHP(5)]),
                EventChoice(textKey: "event_shrine_choice2", effects: [.nothing])
            ],
            act: 1, weight: 0.8
        ),
        EventTemplate(
            id: "wandering_merchant",
            titleKey: "event_merchant",
            descriptionKey: "event_merchant_desc",
            icon: "cart.fill",
            choices: [
                EventChoice(textKey: "event_merchant_choice1", effects: [.loseGold(50), .gainStrength(1)]),
                EventChoice(textKey: "event_merchant_choice2", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "wounded_traveler",
            titleKey: "event_wounded_traveler",
            descriptionKey: "event_wounded_traveler_desc",
            icon: "cross.case.fill",
            choices: [
                EventChoice(textKey: "event_wounded_traveler_choice1", effects: [.gainRandomPotion, .loseGold(15)]),
                EventChoice(textKey: "event_wounded_traveler_choice2", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "cursed_chest",
            titleKey: "event_cursed_chest",
            descriptionKey: "event_cursed_chest_desc",
            icon: "chest.lefthalf.filled.badge.xmark",
            choices: [
                EventChoice(textKey: "event_cursed_chest_choice1", effects: [.gainRandomRelic, .loseHP(12)]),
                EventChoice(textKey: "event_cursed_chest_choice2", effects: [.addCardToDeck("decay")])
            ],
            act: 1, weight: 0.5
        ),
        EventTemplate(
            id: "gambler",
            titleKey: "event_gambler",
            descriptionKey: "event_gambler_desc",
            icon: "dice.fill",
            choices: [
                EventChoice(textKey: "event_gambler_choice1", effects: [.loseGold(30), .gainGold(60)]),
                EventChoice(textKey: "event_gambler_choice2", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "ancient_forge",
            titleKey: "event_ancient_forge",
            descriptionKey: "event_ancient_forge_desc",
            icon: "hammer.fill",
            choices: [
                EventChoice(textKey: "event_ancient_forge_choice1", effects: [.removeRandomCard, .gainRandomRelic]),
                EventChoice(textKey: "event_ancient_forge_choice2", effects: [.nothing])
            ],
            act: 1, weight: 0.6
        ),
        EventTemplate(
            id: "ghost_crossroads",
            titleKey: "event_ghost_crossroads",
            descriptionKey: "event_ghost_crossroads_desc",
            icon: "signpost.right.and.left.fill",
            choices: [
                EventChoice(textKey: "event_ghost_crossroads_choice1", effects: [.healPercent(0.25)]),
                EventChoice(textKey: "event_ghost_crossroads_choice2", effects: [.gainRandomPotion]),
                EventChoice(textKey: "event_ghost_crossroads_choice3", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "flower_girl",
            titleKey: "event_flower_girl",
            descriptionKey: "event_flower_girl_desc",
            icon: "leaf.fill",
            choices: [
                EventChoice(textKey: "event_flower_girl_choice1", effects: [.loseGold(20), .gainHP(15)]),
                EventChoice(textKey: "event_flower_girl_choice2", effects: [.loseGold(50), .gainRandomPotion]),
                EventChoice(textKey: "event_flower_girl_choice3", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "collapsed_bridge",
            titleKey: "event_collapsed_bridge",
            descriptionKey: "event_collapsed_bridge_desc",
            icon: "figure.walk",
            choices: [
                EventChoice(textKey: "event_collapsed_bridge_choice1", effects: [.loseHP(25), .gainGold(75)]),
                EventChoice(textKey: "event_collapsed_bridge_choice2", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "wandering_smith",
            titleKey: "event_wandering_smith",
            descriptionKey: "event_wandering_smith_desc",
            icon: "wrench.and.screwdriver.fill",
            choices: [
                EventChoice(textKey: "event_wandering_smith_choice1", effects: [.loseGold(40), .removeRandomCard]),
                EventChoice(textKey: "event_wandering_smith_choice2", effects: [.loseGold(75), .upgradeRandomCards(2)]),
                EventChoice(textKey: "event_wandering_smith_choice3", effects: [.nothing])
            ],
            act: 1, weight: 1.0
        ),
        EventTemplate(
            id: "forgotten_shrine",
            titleKey: "event_forgotten_shrine",
            descriptionKey: "event_forgotten_shrine_desc",
            icon: "staroflife.fill",
            choices: [
                EventChoice(textKey: "event_forgotten_shrine_choice1", effects: [.loseMaxHP(10), .gainRandomRelic]),
                EventChoice(textKey: "event_forgotten_shrine_choice2", effects: [.nothing])
            ],
            act: 1, weight: 0.4
        ),
        EventTemplate(
            id: "music_box",
            titleKey: "event_music_box",
            descriptionKey: "event_music_box_desc",
            icon: "music.note",
            choices: [
                EventChoice(textKey: "event_music_box_choice1", effects: [.gainHP(20)]),
                EventChoice(textKey: "event_music_box_choice2", effects: [.gainGold(50), .randomDebuff]),
                EventChoice(textKey: "event_music_box_choice3", effects: [.gainGold(100), .addCardToDeck("doubt")])
            ],
            act: 1, weight: 0.8
        ),

        // MARK: - Act 2 Events (11 total: 3 original + 8 new)

        EventTemplate(
            id: "blood_ritual",
            titleKey: "event_blood_ritual",
            descriptionKey: "event_blood_ritual_desc",
            icon: "drop.fill",
            choices: [
                EventChoice(textKey: "event_blood_ritual_choice1", effects: [.loseHP(15), .gainMaxHP(8)]),
                EventChoice(textKey: "event_blood_ritual_choice2", effects: [.nothing])
            ],
            act: 2, weight: 1.0
        ),
        EventTemplate(
            id: "ancient_library",
            titleKey: "event_ancient_library",
            descriptionKey: "event_ancient_library_desc",
            icon: "books.vertical.fill",
            choices: [
                EventChoice(textKey: "event_ancient_library_choice1", effects: [.loseHP(5), .upgradeRandomCard, .upgradeRandomCard]),
                EventChoice(textKey: "event_ancient_library_choice2", effects: [.nothing])
            ],
            act: 2, weight: 1.0
        ),
        EventTemplate(
            id: "treasure_chest",
            titleKey: "event_treasure_chest",
            descriptionKey: "event_treasure_chest_desc",
            icon: "chest.lefthalf.filled",
            choices: [
                EventChoice(textKey: "event_treasure_chest_choice1", effects: [.gainGold(80), .loseHP(10)]),
                EventChoice(textKey: "event_treasure_chest_choice2", effects: [.gainMaxHP(3)])
            ],
            act: 2, weight: 1.0
        ),
        EventTemplate(
            id: "shadow_trade",
            titleKey: "event_shadow_trade",
            descriptionKey: "event_shadow_trade_desc",
            icon: "arrow.left.arrow.right",
            choices: [
                EventChoice(textKey: "event_shadow_trade_choice1", effects: [.removeRandomCard, .gainRandomRelic]),
                EventChoice(textKey: "event_shadow_trade_choice2", effects: [.nothing])
            ],
            act: 2, weight: 0.6
        ),
        EventTemplate(
            id: "poison_swamp",
            titleKey: "event_poison_swamp",
            descriptionKey: "event_poison_swamp_desc",
            icon: "cloud.fog.fill",
            choices: [
                EventChoice(textKey: "event_poison_swamp_choice1", effects: [.loseHP(10), .gainRandomPotion]),
                EventChoice(textKey: "event_poison_swamp_choice2", effects: [.nothing])
            ],
            act: 2, weight: 1.0
        ),
        EventTemplate(
            id: "captive_spirit",
            titleKey: "event_captive_spirit",
            descriptionKey: "event_captive_spirit_desc",
            icon: "sparkles",
            choices: [
                EventChoice(textKey: "event_captive_spirit_choice1", effects: [.upgradeRandomCards(3)]),
                EventChoice(textKey: "event_captive_spirit_choice2", effects: [.gainGold(100), .randomDebuff]),
                EventChoice(textKey: "event_captive_spirit_choice3", effects: [.gainRandomRelic, .addCardToDeck("pain")])
            ],
            act: 2, weight: 0.5
        ),
        EventTemplate(
            id: "broken_throne",
            titleKey: "event_broken_throne",
            descriptionKey: "event_broken_throne_desc",
            icon: "crown.fill",
            choices: [
                EventChoice(textKey: "event_broken_throne_choice1", effects: [.loseHP(15), .gainStrength(2)]),
                EventChoice(textKey: "event_broken_throne_choice2", effects: [.nothing])
            ],
            act: 2, weight: 0.8
        ),
        EventTemplate(
            id: "mysterious_rune",
            titleKey: "event_mysterious_rune",
            descriptionKey: "event_mysterious_rune_desc",
            icon: "seal.fill",
            choices: [
                EventChoice(textKey: "event_mysterious_rune_choice1", effects: [.loseGold(60), .gainMaxHP(5)]),
                EventChoice(textKey: "event_mysterious_rune_choice2", effects: [.loseHP(8), .upgradeRandomCards(2)])
            ],
            act: 2, weight: 0.7
        ),
        EventTemplate(
            id: "two_headed_snake",
            titleKey: "event_two_headed_snake",
            descriptionKey: "event_two_headed_snake_desc",
            icon: "eye.fill",
            choices: [
                EventChoice(textKey: "event_two_headed_snake_choice1", effects: [.gainGold(100), .loseHP(20)]),
                EventChoice(textKey: "event_two_headed_snake_choice2", effects: [.gainGold(20)])
            ],
            act: 2, weight: 1.0
        ),
        EventTemplate(
            id: "abandoned_alchemy",
            titleKey: "event_abandoned_alchemy",
            descriptionKey: "event_abandoned_alchemy_desc",
            icon: "flask.fill",
            choices: [
                EventChoice(textKey: "event_abandoned_alchemy_choice1", effects: [.gainMaxHP(10), .loseHP(10)]),
                EventChoice(textKey: "event_abandoned_alchemy_choice2", effects: [.gainGold(30)])
            ],
            act: 2, weight: 1.0
        ),
        EventTemplate(
            id: "ghost_ship",
            titleKey: "event_ghost_ship",
            descriptionKey: "event_ghost_ship_desc",
            icon: "sailboat.fill",
            choices: [
                EventChoice(textKey: "event_ghost_ship_choice1", effects: [.loseHP(25), .gainRandomRelic]),
                EventChoice(textKey: "event_ghost_ship_choice2", effects: [.gainGold(50)])
            ],
            act: 2, weight: 0.6
        ),

        // MARK: - Act 3 Events (11 total: 3 original + 8 new)

        EventTemplate(
            id: "soul_burn",
            titleKey: "event_soul_burn",
            descriptionKey: "event_soul_burn_desc",
            icon: "flame.fill",
            choices: [
                EventChoice(textKey: "event_soul_burn_choice1", effects: [.loseHP(20), .gainMaxHP(12)]),
                EventChoice(textKey: "event_soul_burn_choice2", effects: [.gainGold(100), .loseHP(15)])
            ],
            act: 3, weight: 1.0
        ),
        EventTemplate(
            id: "forbidden_altar",
            titleKey: "event_forbidden_altar",
            descriptionKey: "event_forbidden_altar_desc",
            icon: "exclamationmark.triangle.fill",
            choices: [
                EventChoice(textKey: "event_forbidden_altar_choice1", effects: [.loseHP(12), .upgradeRandomCard, .upgradeRandomCard]),
                EventChoice(textKey: "event_forbidden_altar_choice2", effects: [.loseGold(60), .gainMaxHP(6)]),
                EventChoice(textKey: "event_forbidden_altar_choice3", effects: [.gainStrength(3), .addCardToDeck("shame")])
            ],
            act: 3, weight: 1.0
        ),
        EventTemplate(
            id: "abyss_gate",
            titleKey: "event_abyss_gate",
            descriptionKey: "event_abyss_gate_desc",
            icon: "circle.hexagonpath.fill",
            choices: [
                EventChoice(textKey: "event_abyss_gate_choice1", effects: [.loseHP(8), .gainStrength(2)]),
                EventChoice(textKey: "event_abyss_gate_choice2", effects: [.nothing])
            ],
            act: 3, weight: 1.0
        ),
        EventTemplate(
            id: "doom_bell",
            titleKey: "event_doom_bell",
            descriptionKey: "event_doom_bell_desc",
            icon: "bell.and.waves.fill",
            choices: [
                EventChoice(textKey: "event_doom_bell_choice1", effects: [.loseMaxHP(5), .gainStrength(3)]),
                EventChoice(textKey: "event_doom_bell_choice2", effects: [.gainStrength(2), .addCardToDeck("regret")]),
                EventChoice(textKey: "event_doom_bell_choice3", effects: [.nothing])
            ],
            act: 3, weight: 0.5
        ),
        EventTemplate(
            id: "eye_of_abyss",
            titleKey: "event_eye_of_abyss",
            descriptionKey: "event_eye_of_abyss_desc",
            icon: "eye.circle.fill",
            choices: [
                EventChoice(textKey: "event_eye_of_abyss_choice1", effects: [.gainRandomRelic, .loseHP(30)]),
                EventChoice(textKey: "event_eye_of_abyss_choice2", effects: [.nothing])
            ],
            act: 3, weight: 0.4
        ),
        EventTemplate(
            id: "wheel_of_fate",
            titleKey: "event_wheel_of_fate",
            descriptionKey: "event_wheel_of_fate_desc",
            icon: "arrow.triangle.2.circlepath",
            choices: [
                EventChoice(textKey: "event_wheel_of_fate_choice1", effects: [.healPercent(1.0)]),
                EventChoice(textKey: "event_wheel_of_fate_choice2", effects: [.gainGold(200), .loseHP(15)]),
                EventChoice(textKey: "event_wheel_of_fate_choice3", effects: [.gainRandomRelic, .loseGold(100)])
            ],
            act: 3, weight: 0.4
        ),
        EventTemplate(
            id: "shattered_spacetime",
            titleKey: "event_shattered_spacetime",
            descriptionKey: "event_shattered_spacetime_desc",
            icon: "atom",
            choices: [
                EventChoice(textKey: "event_shattered_spacetime_choice1", effects: [.duplicateRandomCard]),
                EventChoice(textKey: "event_shattered_spacetime_choice2", effects: [.removeRandomCard, .gainRandomRelic])
            ],
            act: 3, weight: 0.6
        ),
        EventTemplate(
            id: "fallen_guardian",
            titleKey: "event_fallen_guardian",
            descriptionKey: "event_fallen_guardian_desc",
            icon: "shield.lefthalf.filled.badge.xmark",
            choices: [
                EventChoice(textKey: "event_fallen_guardian_choice1", effects: [.gainStrength(5), .loseHP(999)]),
                EventChoice(textKey: "event_fallen_guardian_choice2", effects: [.gainMaxHP(20)])
            ],
            act: 3, weight: 0.3
        ),
        EventTemplate(
            id: "final_gate",
            titleKey: "event_final_gate",
            descriptionKey: "event_final_gate_desc",
            icon: "door.left.hand.open",
            choices: [
                EventChoice(textKey: "event_final_gate_choice1", effects: [.gainRandomRelic, .gainRandomRelic, .healPercent(-0.75)]),
                EventChoice(textKey: "event_final_gate_choice2", effects: [.nothing])
            ],
            act: 3, weight: 0.3
        ),
        EventTemplate(
            id: "soul_exchange",
            titleKey: "event_soul_exchange",
            descriptionKey: "event_soul_exchange_desc",
            icon: "arrow.left.arrow.right.circle.fill",
            choices: [
                EventChoice(textKey: "event_soul_exchange_choice1", effects: [.loseMaxHP(15), .upgradeRandomCards(3)]),
                EventChoice(textKey: "event_soul_exchange_choice2", effects: [.nothing])
            ],
            act: 3, weight: 0.5
        ),
        EventTemplate(
            id: "last_merchant",
            titleKey: "event_last_merchant",
            descriptionKey: "event_last_merchant_desc",
            icon: "bag.fill.badge.plus",
            choices: [
                EventChoice(textKey: "event_last_merchant_choice1", effects: [.loseGold(30), .gainRandomPotion]),
                EventChoice(textKey: "event_last_merchant_choice2", effects: [.loseGold(60), .gainRandomRelic]),
                EventChoice(textKey: "event_last_merchant_choice3", effects: [.loseGold(40), .removeRandomCard])
            ],
            act: 3, weight: 0.8
        )
    ]

    // MARK: - Accessors

    static func randomEvent(act: Int = 1) -> EventTemplate {
        let pool = allEvents.filter { $0.act == act }
        guard !pool.isEmpty else { return allEvents[0] }
        let totalWeight = pool.reduce(0.0) { $0 + $1.weight }
        var roll = Double.random(in: 0...totalWeight)
        for event in pool {
            roll -= event.weight
            if roll <= 0 { return event }
        }
        return pool.last ?? allEvents[0]
    }
}
