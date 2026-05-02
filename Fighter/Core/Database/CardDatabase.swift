//
//  CardDatabase.swift
//  Fighter
//

import Foundation

enum CardDatabase {

    // MARK: - Warrior Starter Cards

    static let strikeWarrior = Card.newInstance(
        templateKey: "strike_warrior",
        type: .attack,
        rarity: .starter,
        cost: 1,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(6)],
        upgradedEffects: [.dealDamage(9)]
    )

    static let defendWarrior = Card.newInstance(
        templateKey: "defend_warrior",
        type: .skill,
        rarity: .starter,
        cost: 1,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.gainBlock(5)],
        upgradedEffects: [.gainBlock(8)]
    )

    static let bashWarrior = Card.newInstance(
        templateKey: "bash_warrior",
        type: .attack,
        rarity: .starter,
        cost: 2,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(8), .applyDebuff(.vulnerable, stacks: 2)],
        upgradedEffects: [.dealDamage(10), .applyDebuff(.vulnerable, stacks: 3)]
    )

    // MARK: - Warrior Common Cards

    static let angrier = Card.newInstance(
        templateKey: "anger_warrior",
        type: .attack,
        rarity: .common,
        cost: 0,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(6), .addCardToDiscard(templateKey: "anger_warrior")],
        upgradedEffects: [.dealDamage(8), .addCardToDiscard(templateKey: "anger_warrior")]
    )

    static let clash = Card.newInstance(
        templateKey: "clash_warrior",
        type: .attack,
        rarity: .common,
        cost: 0,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(14)],
        upgradedEffects: [.dealDamage(18)]
    )

    static let cleave = Card.newInstance(
        templateKey: "cleave_warrior",
        type: .attack,
        rarity: .common,
        cost: 1,
        target: .allEnemies,
        characterClass: .warrior,
        effects: [.dealDamageToAll(8)],
        upgradedEffects: [.dealDamageToAll(11)]
    )

    static let ironWave = Card.newInstance(
        templateKey: "iron_wave_warrior",
        type: .attack,
        rarity: .common,
        cost: 1,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(5), .gainBlock(5)],
        upgradedEffects: [.dealDamage(7), .gainBlock(7)]
    )

    static let armaments = Card.newInstance(
        templateKey: "armaments_warrior",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.gainBlock(5)],
        upgradedEffects: [.gainBlock(5)]
    )

    static let shoutWarrior = Card.newInstance(
        templateKey: "shout_warrior",
        type: .skill,
        rarity: .common,
        cost: 0,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.applyBuff(.strength, stacks: 1)],
        upgradedEffects: [.applyBuff(.strength, stacks: 2)]
    )

    static let warcryWarrior = Card.newInstance(
        templateKey: "warcry_warrior",
        type: .skill,
        rarity: .common,
        cost: 0,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.drawCards(1)],
        upgradedEffects: [.drawCards(2)],
        isExhaust: true
    )

    // MARK: - Warrior Uncommon Cards

    static let uppercut = Card.newInstance(
        templateKey: "uppercut_warrior",
        type: .attack,
        rarity: .uncommon,
        cost: 2,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(13), .applyDebuff(.weak, stacks: 1), .applyDebuff(.vulnerable, stacks: 1)],
        upgradedEffects: [.dealDamage(13), .applyDebuff(.weak, stacks: 2), .applyDebuff(.vulnerable, stacks: 2)]
    )

    static let inflame = Card.newInstance(
        templateKey: "inflame_warrior",
        type: .power,
        rarity: .uncommon,
        cost: 1,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.applyBuff(.strength, stacks: 2)],
        upgradedEffects: [.applyBuff(.strength, stacks: 3)]
    )

    static let metallicize = Card.newInstance(
        templateKey: "metallicize_warrior",
        type: .power,
        rarity: .uncommon,
        cost: 1,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.applyBuff(.metallicize, stacks: 3)],
        upgradedEffects: [.applyBuff(.metallicize, stacks: 4)]
    )

    // MARK: - Warrior Rare Cards

    static let bludgeon = Card.newInstance(
        templateKey: "bludgeon_warrior",
        type: .attack,
        rarity: .rare,
        cost: 3,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(32)],
        upgradedEffects: [.dealDamage(42)]
    )

    static let feed = Card.newInstance(
        templateKey: "feed_warrior",
        type: .attack,
        rarity: .rare,
        cost: 1,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(10)],
        upgradedEffects: [.dealDamage(12)]
    )

    // MARK: - Warrior Exhaust Cards

    static let trueGrit = Card.newInstance(
        templateKey: "true_grit_warrior",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.gainBlock(7), .exhaustRandomFromHand(count: 1)],
        upgradedEffects: [.gainBlock(9), .exhaustRandomFromHand(count: 1)],
        isExhaust: true
    )

    static let fiendFire = Card.newInstance(
        templateKey: "fiend_fire_warrior",
        type: .attack,
        rarity: .rare,
        cost: 2,
        target: .enemy,
        characterClass: .warrior,
        effects: [.dealDamage(7), .exhaustRandomFromHand(count: 3)],
        upgradedEffects: [.dealDamage(10), .exhaustRandomFromHand(count: 3)],
        isExhaust: true
    )

    static let sentinel = Card.newInstance(
        templateKey: "sentinel_warrior",
        type: .skill,
        rarity: .uncommon,
        cost: 1,
        target: .selfTarget,
        characterClass: .warrior,
        effects: [.gainBlock(6), .exhaustRandomFromHand(count: 1)],
        upgradedEffects: [.gainBlock(9), .exhaustRandomFromHand(count: 1)],
        isExhaust: true
    )

    // MARK: - Assassin Starter Cards

    static let strikeAssassin = Card.newInstance(
        templateKey: "strike_assassin",
        type: .attack,
        rarity: .starter,
        cost: 1,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(6)],
        upgradedEffects: [.dealDamage(9)]
    )

    static let defendAssassin = Card.newInstance(
        templateKey: "defend_assassin",
        type: .skill,
        rarity: .starter,
        cost: 1,
        target: .selfTarget,
        characterClass: .assassin,
        effects: [.gainBlock(5)],
        upgradedEffects: [.gainBlock(8)]
    )

    static let neutralizeAssassin = Card.newInstance(
        templateKey: "neutralize_assassin",
        type: .attack,
        rarity: .starter,
        cost: 0,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(3), .applyDebuff(.weak, stacks: 1)],
        upgradedEffects: [.dealDamage(4), .applyDebuff(.weak, stacks: 2)]
    )

    // MARK: - Mage Starter Cards

    static let strikeMage = Card.newInstance(
        templateKey: "strike_mage",
        type: .attack,
        rarity: .starter,
        cost: 1,
        target: .enemy,
        characterClass: .mage,
        effects: [.dealDamage(6)],
        upgradedEffects: [.dealDamage(9)]
    )

    static let defendMage = Card.newInstance(
        templateKey: "defend_mage",
        type: .skill,
        rarity: .starter,
        cost: 1,
        target: .selfTarget,
        characterClass: .mage,
        effects: [.gainBlock(5)],
        upgradedEffects: [.gainBlock(8)]
    )

    static let castMage = Card.newInstance(
        templateKey: "cast_mage",
        type: .attack,
        rarity: .starter,
        cost: 1,
        target: .enemy,
        characterClass: .mage,
        effects: [.dealDamage(7)],
        upgradedEffects: [.dealDamage(10)]
    )

    static let survivorMage = Card.newInstance(
        templateKey: "survivor_mage",
        type: .skill,
        rarity: .starter,
        cost: 1,
        target: .selfTarget,
        characterClass: .mage,
        effects: [.gainBlock(8), .drawCards(1)],
        upgradedEffects: [.gainBlock(11), .drawCards(1)],
        isExhaust: true
    )

    // MARK: - Assassin Common Cards

    static let backstab = Card.newInstance(
        templateKey: "backstab_assassin",
        type: .attack,
        rarity: .common,
        cost: 0,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(9)],
        upgradedEffects: [.dealDamage(12)]
    )

    static let poisonStab = Card.newInstance(
        templateKey: "poison_stab_assassin",
        type: .attack,
        rarity: .common,
        cost: 1,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(4), .applyDebuff(.poison, stacks: 3)],
        upgradedEffects: [.dealDamage(6), .applyDebuff(.poison, stacks: 4)]
    )

    static let dodgeAssassin = Card.newInstance(
        templateKey: "dodge_assassin",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .selfTarget,
        characterClass: .assassin,
        effects: [.gainBlock(8), .drawCards(1)],
        upgradedEffects: [.gainBlock(11), .drawCards(1)]
    )

    static let bladeDance = Card.newInstance(
        templateKey: "blade_dance_assassin",
        type: .attack,
        rarity: .common,
        cost: 1,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamageMulti(3, hits: 4)],
        upgradedEffects: [.dealDamageMulti(4, hits: 4)]
    )

    static let setupAssassin = Card.newInstance(
        templateKey: "setup_assassin",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .none,
        characterClass: .assassin,
        effects: [.gainBlock(5), .applyBuff(.dexterity, stacks: 1)],
        upgradedEffects: [.gainBlock(8), .applyBuff(.dexterity, stacks: 1)]
    )

    static let dashAssassin = Card.newInstance(
        templateKey: "dash_assassin",
        type: .attack,
        rarity: .common,
        cost: 2,
        target: .allEnemies,
        characterClass: .assassin,
        effects: [.dealDamageToAll(8), .gainBlock(5)],
        upgradedEffects: [.dealDamageToAll(10), .gainBlock(7)]
    )

    // MARK: - Assassin Uncommon Cards

    static let catalyst = Card.newInstance(
        templateKey: "catalyst_assassin",
        type: .skill,
        rarity: .uncommon,
        cost: 1,
        target: .enemy,
        characterClass: .assassin,
        effects: [.applyDebuff(.poison, stacks: 5), .drawCards(1)],
        upgradedEffects: [.applyDebuff(.poison, stacks: 7), .drawCards(1)]
    )

    static let burstAssassin = Card.newInstance(
        templateKey: "burst_assassin",
        type: .attack,
        rarity: .uncommon,
        cost: 2,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(14)],
        upgradedEffects: [.dealDamage(18)]
    )

    static let phantom = Card.newInstance(
        templateKey: "phantom_assassin",
        type: .skill,
        rarity: .uncommon,
        cost: 1,
        target: .selfTarget,
        characterClass: .assassin,
        effects: [.gainBlock(12), .applyBuff(.drawModifier, stacks: 1)],
        upgradedEffects: [.gainBlock(15), .applyBuff(.drawModifier, stacks: 1)]
    )

    // MARK: - Assassin Rare Cards

    static let endlessAgony = Card.newInstance(
        templateKey: "endless_agony_assassin",
        type: .attack,
        rarity: .rare,
        cost: 3,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(28)],
        upgradedEffects: [.dealDamage(36)],
        isExhaust: true
    )

    static let coupDeGrace = Card.newInstance(
        templateKey: "coup_de_grace_assassin",
        type: .attack,
        rarity: .rare,
        cost: 2,
        target: .enemy,
        characterClass: .assassin,
        effects: [.dealDamage(12)],
        upgradedEffects: [.dealDamage(16)]
    )

    // MARK: - Mage Common Cards

    static let arcaneBolt = Card.newInstance(
        templateKey: "arcane_bolt_mage",
        type: .attack,
        rarity: .common,
        cost: 1,
        target: .enemy,
        characterClass: .mage,
        effects: [.dealDamage(7), .applyDebuff(.vulnerable, stacks: 1)],
        upgradedEffects: [.dealDamage(9), .applyDebuff(.vulnerable, stacks: 2)]
    )

    static let frostShield = Card.newInstance(
        templateKey: "frost_shield_mage",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .selfTarget,
        characterClass: .mage,
        effects: [.gainBlock(8), .applyBuff(.artifact, stacks: 1)],
        upgradedEffects: [.gainBlock(11), .applyBuff(.artifact, stacks: 1)]
    )

    static let fireball = Card.newInstance(
        templateKey: "fireball_mage",
        type: .attack,
        rarity: .common,
        cost: 2,
        target: .allEnemies,
        characterClass: .mage,
        effects: [.dealDamageToAll(10)],
        upgradedEffects: [.dealDamageToAll(14)]
    )

    static let channelMage = Card.newInstance(
        templateKey: "channel_mage",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .none,
        characterClass: .mage,
        effects: [.gainEnergy(1), .applyBuff(.strength, stacks: 1)],
        upgradedEffects: [.gainEnergy(1), .applyBuff(.strength, stacks: 2)]
    )

    static let meditate = Card.newInstance(
        templateKey: "meditate_mage",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .selfTarget,
        characterClass: .mage,
        effects: [.drawCards(2), .discardCards(1)],
        upgradedEffects: [.drawCards(3), .discardCards(1)]
    )

    // MARK: - Mage Uncommon Cards

    static let thunder = Card.newInstance(
        templateKey: "thunder_mage",
        type: .attack,
        rarity: .uncommon,
        cost: 2,
        target: .enemy,
        characterClass: .mage,
        effects: [.dealDamage(16), .applyDebuff(.weak, stacks: 2)],
        upgradedEffects: [.dealDamage(20), .applyDebuff(.weak, stacks: 2)]
    )

    static let blizzard = Card.newInstance(
        templateKey: "blizzard_mage",
        type: .attack,
        rarity: .uncommon,
        cost: 2,
        target: .allEnemies,
        characterClass: .mage,
        effects: [.dealDamageToAll(8), .applyDebuffToAll(.weak, stacks: 1)],
        upgradedEffects: [.dealDamageToAll(11), .applyDebuffToAll(.weak, stacks: 1)]
    )

    static let barrier = Card.newInstance(
        templateKey: "barrier_mage",
        type: .skill,
        rarity: .uncommon,
        cost: 2,
        target: .selfTarget,
        characterClass: .mage,
        effects: [.gainBlock(18)],
        upgradedEffects: [.gainBlock(24)],
        isExhaust: true
    )

    // MARK: - Mage Rare Cards

    static let meteor = Card.newInstance(
        templateKey: "meteor_mage",
        type: .attack,
        rarity: .rare,
        cost: 3,
        target: .allEnemies,
        characterClass: .mage,
        effects: [.dealDamageToAll(24)],
        upgradedEffects: [.dealDamageToAll(32)],
        isExhaust: true
    )

    static let inferno = Card.newInstance(
        templateKey: "inferno_mage",
        type: .attack,
        rarity: .rare,
        cost: 2,
        target: .enemy,
        characterClass: .mage,
        effects: [.dealDamage(18)],
        upgradedEffects: [.dealDamage(24)],
        isExhaust: true
    )

    // MARK: - Neutral (Colorless) Cards

    static let deepBreath = Card.newInstance(
        templateKey: "deep_breath_neutral",
        type: .skill,
        rarity: .uncommon,
        cost: 1,
        target: .selfTarget,
        characterClass: nil,
        effects: [.drawCards(2), .gainBlock(4)],
        upgradedEffects: [.drawCards(3), .gainBlock(6)]
    )

    static let bandageUp = Card.newInstance(
        templateKey: "bandage_up_neutral",
        type: .skill,
        rarity: .uncommon,
        cost: 1,
        target: .selfTarget,
        characterClass: nil,
        effects: [.heal(5)],
        upgradedEffects: [.heal(8)],
        isExhaust: true
    )

    static let darkShackles = Card.newInstance(
        templateKey: "dark_shackles_neutral",
        type: .skill,
        rarity: .uncommon,
        cost: 1,
        target: .enemy,
        characterClass: nil,
        effects: [.applyDebuff(.weak, stacks: 3), .dealDamage(4)],
        upgradedEffects: [.applyDebuff(.weak, stacks: 4), .dealDamage(6)]
    )

    static let swiftStrike = Card.newInstance(
        templateKey: "swift_strike_neutral",
        type: .attack,
        rarity: .common,
        cost: 0,
        target: .enemy,
        characterClass: nil,
        effects: [.dealDamage(4)],
        upgradedEffects: [.dealDamage(7)]
    )

    static let safeGuard = Card.newInstance(
        templateKey: "safeguard_neutral",
        type: .skill,
        rarity: .common,
        cost: 1,
        target: .selfTarget,
        characterClass: nil,
        effects: [.gainBlock(8)],
        upgradedEffects: [.gainBlock(12)]
    )

    static let flashOfSteel = Card.newInstance(
        templateKey: "flash_of_steel_neutral",
        type: .attack,
        rarity: .common,
        cost: 0,
        target: .enemy,
        characterClass: nil,
        effects: [.dealDamage(3), .drawCards(1)],
        upgradedEffects: [.dealDamage(6), .drawCards(1)]
    )

    static let panacea = Card.newInstance(
        templateKey: "panacea_neutral",
        type: .skill,
        rarity: .uncommon,
        cost: 0,
        target: .selfTarget,
        characterClass: nil,
        effects: [.gainBlock(4), .applyBuff(.artifact, stacks: 1)],
        upgradedEffects: [.gainBlock(6), .applyBuff(.artifact, stacks: 1)],
        isExhaust: true
    )

    static let enlightenment = Card.newInstance(
        templateKey: "enlightenment_neutral",
        type: .skill,
        rarity: .rare,
        cost: 0,
        target: .selfTarget,
        characterClass: nil,
        effects: [.gainEnergy(2), .discardCards(2)],
        upgradedEffects: [.gainEnergy(2), .discardCards(1)]
    )

    static let handOfGreed = Card.newInstance(
        templateKey: "hand_of_greed_neutral",
        type: .attack,
        rarity: .rare,
        cost: 2,
        target: .enemy,
        characterClass: nil,
        effects: [.dealDamage(20)],
        upgradedEffects: [.dealDamage(28)]
    )

    static let metamorphosis = Card.newInstance(
        templateKey: "metamorphosis_neutral",
        type: .power,
        rarity: .rare,
        cost: 1,
        target: .selfTarget,
        characterClass: nil,
        effects: [.applyBuff(.strength, stacks: 2), .applyBuff(.dexterity, stacks: 2)],
        upgradedEffects: [.applyBuff(.strength, stacks: 3), .applyBuff(.dexterity, stacks: 3)],
        isExhaust: true
    )

    // MARK: - Status Cards

    static let wound = Card.newInstance(
        templateKey: "wound",
        type: .status,
        rarity: .starter,
        cost: -1,
        target: .none,
        characterClass: nil,
        effects: []
    )

    static let daze = Card.newInstance(
        templateKey: "daze",
        type: .status,
        rarity: .starter,
        cost: -1,
        target: .none,
        characterClass: nil,
        effects: [],
        isExhaust: true
    )

    static let burn = Card.newInstance(
        templateKey: "burn",
        type: .status,
        rarity: .starter,
        cost: -1,
        target: .none,
        characterClass: nil,
        effects: []
    )

    static let slimed = Card.newInstance(
        templateKey: "slimed",
        type: .status,
        rarity: .starter,
        cost: -1,
        target: .none,
        characterClass: nil,
        effects: [],
        isExhaust: true
    )

    static let voidCard = Card.newInstance(
        templateKey: "void_card",
        type: .status,
        rarity: .starter,
        cost: -1,
        target: .none,
        characterClass: nil,
        effects: [],
        isExhaust: true
    )

    static let writhe = Card.newInstance(
        templateKey: "writhe",
        type: .status,
        rarity: .starter,
        cost: -1,
        target: .none,
        characterClass: nil,
        effects: []
    )

    // MARK: - All Cards

    static let allCards: [Card] = [
        // Warrior
        strikeWarrior, defendWarrior, bashWarrior,
        angrier, clash, cleave, ironWave, armaments, shoutWarrior, warcryWarrior,
        uppercut, inflame, metallicize,
        bludgeon, feed, trueGrit, fiendFire, sentinel,
        // Assassin
        strikeAssassin, defendAssassin, neutralizeAssassin,
        backstab, poisonStab, dodgeAssassin, bladeDance, setupAssassin, dashAssassin,
        catalyst, burstAssassin, phantom,
        endlessAgony, coupDeGrace,
        // Mage
        strikeMage, defendMage, castMage, survivorMage,
        arcaneBolt, frostShield, fireball, channelMage, meditate,
        thunder, blizzard, barrier,
        meteor, inferno,
        // Neutral
        deepBreath, bandageUp, darkShackles, swiftStrike,
        safeGuard, flashOfSteel, panacea,
        enlightenment, handOfGreed, metamorphosis,
        // Status
        wound, daze, burn, slimed, voidCard, writhe
    ]

    // MARK: - Accessors

    static func card(byKey key: String) -> Card? {
        allCards.first { $0.templateKey == key }
    }

    static func cards(for character: CharacterClass) -> [Card] {
        allCards.filter { $0.characterClass == character || $0.characterClass == nil }
    }

    static func randomCards(count: Int, rarity: CardRarity, for character: CharacterClass) -> [Card] {
        let pool = cards(for: character).filter { $0.rarity == rarity }
        return Array(pool.shuffled().prefix(count))
    }

    static func startingDeck(for character: CharacterClass) -> [Card] {
        character.startingDeckTemplateKeys.compactMap { key -> Card? in
            card(byKey: key)?.copy()
        }
    }
}
