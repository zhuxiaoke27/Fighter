//
//  EnemyDatabase.swift
//  Fighter
//

import Foundation

enum EnemyDatabase {

    // MARK: - Act 1 Basic Enemies

    static let cultist = EnemyTemplate(
        id: "cultist",
        nameKey: "enemy_cultist",
        minHP: 40,
        maxHP: 46,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .attack(6), effects: [.dealDamage(6)]), weight: 1.0),
        ],
        pattern: .sequential
    )

    static let jawWorm = EnemyTemplate(
        id: "jaw_worm",
        nameKey: "enemy_jaw_worm",
        minHP: 34,
        maxHP: 40,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(11), effects: [.dealDamage(11)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(6), effects: [.gainBlock(6), .dealDamage(5)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .attack(7), effects: [.dealDamage(7)]), weight: 0.8),
        ],
        pattern: .random
    )

    static let slime = EnemyTemplate(
        id: "slime",
        nameKey: "enemy_slime",
        minHP: 24,
        maxHP: 28,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(8), effects: [.dealDamage(8)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 1), effects: [.applyDebuff(.weak, stacks: 1)]), weight: 0.5),
        ],
        pattern: .random
    )

    static let fungusBeast = EnemyTemplate(
        id: "fungus_beast",
        nameKey: "enemy_fungus_beast",
        minHP: 36,
        maxHP: 42,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(6), effects: [.dealDamage(6)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10)]), weight: 0.5),
        ],
        pattern: .conditional
    )

    static let blueSlime = EnemyTemplate(
        id: "blue_slime",
        nameKey: "enemy_blue_slime",
        minHP: 20,
        maxHP: 24,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(5), effects: [.dealDamage(5)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 1), effects: [.applyDebuff(.weak, stacks: 1)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .debuff(.frail, stacks: 1), effects: [.applyDebuff(.frail, stacks: 1)]), weight: 0.5),
        ],
        pattern: .random
    )

    // MARK: - Act 1 Elite

    static let gremlinNob = EnemyTemplate(
        id: "gremlin_nob",
        nameKey: "enemy_gremlin_nob",
        minHP: 82,
        maxHP: 86,
        isBoss: false,
        isElite: true,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(14), effects: [.dealDamage(14)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 2), effects: [.applyBuff(.strength, stacks: 2)]), weight: 0.5),
        ],
        pattern: .conditional
    )

    static let lagavulin = EnemyTemplate(
        id: "lagavulin",
        nameKey: "enemy_lagavulin",
        minHP: 109,
        maxHP: 111,
        isBoss: false,
        isElite: true,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(18), effects: [.dealDamage(18)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 1), effects: [.applyDebuff(.weak, stacks: 1), .applyDebuff(.vulnerable, stacks: 1)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .defend(12), effects: [.gainBlock(12)]), weight: 0.4),
        ],
        pattern: .sequential
    )

    static let gremlinLeader = EnemyTemplate(
        id: "gremlin_leader",
        nameKey: "enemy_gremlin_leader",
        minHP: 100,
        maxHP: 106,
        isBoss: false,
        isElite: true,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(12), effects: [.dealDamage(12)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.7),
            WeightedAction(action: EnemyAction(intent: .defend(10), effects: [.gainBlock(10)]), weight: 0.5),
        ],
        pattern: .conditional
    )

    // MARK: - Act 1 Bosses

    static let slimeBoss = EnemyTemplate(
        id: "slime_boss",
        nameKey: "enemy_slime_boss",
        minHP: 140,
        maxHP: 140,
        isBoss: true,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(18), effects: [.dealDamage(18)]), weight: 0.3),
            WeightedAction(action: EnemyAction(intent: .defend(12), effects: [.gainBlock(12), .dealDamage(10)]), weight: 0.3),
            WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10), .dealDamage(10)]), weight: 0.4),
        ],
        pattern: .sequential
    )

    static let hexaghost = EnemyTemplate(
        id: "hexaghost",
        nameKey: "enemy_hexaghost",
        minHP: 160,
        maxHP: 160,
        isBoss: true,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(15), effects: [.dealDamage(15)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(12), effects: [.gainBlock(12), .dealDamage(8)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .attack(20), effects: [.dealDamage(20)]), weight: 0.3),
        ],
        pattern: .sequential
    )

    static let guardian = EnemyTemplate(
        id: "guardian",
        nameKey: "enemy_guardian",
        minHP: 180,
        maxHP: 180,
        isBoss: true,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(16), effects: [.dealDamage(16)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(20), effects: [.gainBlock(20)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .attack(24), effects: [.dealDamage(24)]), weight: 0.3),
        ],
        pattern: .conditional
    )

    // MARK: - Act 2 Basic Enemies

    static let byrd = EnemyTemplate(
        id: "byrd",
        nameKey: "enemy_byrd",
        minHP: 52,
        maxHP: 58,
        isBoss: false,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(11), effects: [.dealDamage(11)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(12), effects: [.gainBlock(12)]), weight: 0.4),
            WeightedAction(action: EnemyAction(intent: .attack(19), effects: [.dealDamage(19)]), weight: 0.25),
        ],
        pattern: .random
    )

    static let chokeOrb = EnemyTemplate(
        id: "choke_orb",
        nameKey: "enemy_choke_orb",
        minHP: 48,
        maxHP: 54,
        isBoss: false,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(8), effects: [.dealDamage(8), .applyDebuff(.poison, stacks: 2)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(10), effects: [.gainBlock(10)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .debuff(.vulnerable, stacks: 1), effects: [.applyDebuff(.vulnerable, stacks: 1)]), weight: 0.4),
        ],
        pattern: .random
    )

    static let shellParasite = EnemyTemplate(
        id: "shell_parasite",
        nameKey: "enemy_shell_parasite",
        minHP: 60,
        maxHP: 66,
        isBoss: false,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(12), effects: [.dealDamage(12)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(15), effects: [.gainBlock(15)]), weight: 0.85),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 1), effects: [.applyBuff(.strength, stacks: 1)]), weight: 0.6),
        ],
        pattern: .random
    )

    static let sphericGuardian = EnemyTemplate(
        id: "spheric_guardian",
        nameKey: "enemy_spheric_guardian",
        minHP: 55,
        maxHP: 60,
        isBoss: false,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .defend(12), effects: [.gainBlock(12)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .attack(9), effects: [.dealDamage(9)]), weight: 0.8),
            WeightedAction(action: EnemyAction(intent: .debuff(.vulnerable, stacks: 2), effects: [.applyDebuff(.vulnerable, stacks: 2)]), weight: 0.5),
        ],
        pattern: .sequential
    )

    static let chosen = EnemyTemplate(
        id: "chosen",
        nameKey: "enemy_chosen",
        minHP: 50,
        maxHP: 56,
        isBoss: false,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(12), effects: [.dealDamage(12)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 2), effects: [.applyDebuff(.weak, stacks: 2)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 2), effects: [.applyBuff(.strength, stacks: 2)]), weight: 0.5),
        ],
        pattern: .random
    )

    // MARK: - Act 2 Elite

    static let bronzeAutomaton = EnemyTemplate(
        id: "bronze_automaton",
        nameKey: "enemy_bronze_automaton",
        minHP: 96,
        maxHP: 102,
        isBoss: false,
        isElite: true,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(14), effects: [.dealDamage(14)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(18), effects: [.gainBlock(18)]), weight: 0.65),
            WeightedAction(action: EnemyAction(intent: .attack(22), effects: [.dealDamage(22), .applyBuff(.strength, stacks: 1)]), weight: 0.55),
        ],
        pattern: .conditional
    )

    static let bookOfStabbing = EnemyTemplate(
        id: "book_of_stabbing",
        nameKey: "enemy_book_of_stabbing",
        minHP: 120,
        maxHP: 126,
        isBoss: false,
        isElite: true,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attackMulti(damages: [(3, 5)]), effects: [.dealDamage(3), .dealDamage(3), .dealDamage(3), .dealDamage(3), .dealDamage(3)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .attack(20), effects: [.dealDamage(20)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 2), effects: [.applyBuff(.strength, stacks: 2)]), weight: 0.45),
        ],
        pattern: .conditional
    )

    static let giantWorm = EnemyTemplate(
        id: "giant_worm",
        nameKey: "enemy_giant_worm",
        minHP: 110,
        maxHP: 116,
        isBoss: false,
        isElite: true,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(16), effects: [.dealDamage(16)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(20), effects: [.gainBlock(20)]), weight: 0.7),
            WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10), .applyDebuff(.weak, stacks: 2)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.3),
        ],
        pattern: .conditional
    )

    // MARK: - Act 2 Bosses

    static let theChamp = EnemyTemplate(
        id: "the_champ",
        nameKey: "enemy_the_champ",
        minHP: 180,
        maxHP: 180,
        isBoss: true,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(16), effects: [.dealDamage(16)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(20), effects: [.gainBlock(20)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 2), effects: [.applyDebuff(.weak, stacks: 2)]), weight: 0.4),
            WeightedAction(action: EnemyAction(intent: .attack(22), effects: [.dealDamage(22)]), weight: 0.3),
        ],
        pattern: .sequential
    )

    static let collector = EnemyTemplate(
        id: "collector",
        nameKey: "enemy_collector",
        minHP: 200,
        maxHP: 200,
        isBoss: true,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(14), effects: [.dealDamage(14)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 2), effects: [.applyDebuff(.weak, stacks: 2)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.4),
            WeightedAction(action: EnemyAction(intent: .attack(18), effects: [.dealDamage(18), .applyDebuff(.poison, stacks: 3)]), weight: 0.3),
        ],
        pattern: .random
    )

    static let bronzeAutomatonPrime = EnemyTemplate(
        id: "bronze_automaton_prime",
        nameKey: "enemy_bronze_automaton_prime",
        minHP: 220,
        maxHP: 220,
        isBoss: true,
        isElite: false,
        act: 2,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(20), effects: [.dealDamage(20)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(24), effects: [.gainBlock(24)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .attack(30), effects: [.dealDamage(30)]), weight: 0.3),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 4), effects: [.applyBuff(.strength, stacks: 4)]), weight: 0.2),
        ],
        pattern: .sequential
    )

    // MARK: - Act 3 Basic Enemies

    static let darkling = EnemyTemplate(
        id: "darkling",
        nameKey: "enemy_darkling",
        minHP: 65,
        maxHP: 72,
        isBoss: false,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(14), effects: [.dealDamage(14)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.vulnerable, stacks: 2), effects: [.applyDebuff(.vulnerable, stacks: 2)]), weight: 0.5),
        ],
        pattern: .random
    )

    static let orbWalker = EnemyTemplate(
        id: "orb_walker",
        nameKey: "enemy_orb_walker",
        minHP: 58,
        maxHP: 64,
        isBoss: false,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10), .applyDebuff(.poison, stacks: 3)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(14), effects: [.gainBlock(14)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .attack(18), effects: [.dealDamage(18)]), weight: 0.3),
        ],
        pattern: .random
    )

    static let spiker = EnemyTemplate(
        id: "spiker",
        nameKey: "enemy_spiker",
        minHP: 70,
        maxHP: 76,
        isBoss: false,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(12), effects: [.dealDamage(12)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 2), effects: [.applyBuff(.strength, stacks: 2)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 2), effects: [.applyDebuff(.weak, stacks: 2)]), weight: 0.4),
        ],
        pattern: .random
    )

    static let spireGrowth = EnemyTemplate(
        id: "spire_growth",
        nameKey: "enemy_spire_growth",
        minHP: 68,
        maxHP: 74,
        isBoss: false,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(16), effects: [.dealDamage(16)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 2), effects: [.applyBuff(.strength, stacks: 2)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .attack(22), effects: [.dealDamage(22)]), weight: 0.4),
        ],
        pattern: .conditional
    )

    static let transmogrifier = EnemyTemplate(
        id: "transmogrifier",
        nameKey: "enemy_transmogrifier",
        minHP: 60,
        maxHP: 66,
        isBoss: false,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(14), effects: [.dealDamage(14)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.vulnerable, stacks: 2), effects: [.applyDebuff(.vulnerable, stacks: 2)]), weight: 0.6),
            WeightedAction(action: EnemyAction(intent: .debuff(.poison, stacks: 4), effects: [.applyDebuff(.poison, stacks: 4)]), weight: 0.5),
        ],
        pattern: .random
    )

    // MARK: - Act 3 Elite

    static let giantHead = EnemyTemplate(
        id: "giant_head",
        nameKey: "enemy_giant_head",
        minHP: 120,
        maxHP: 128,
        isBoss: false,
        isElite: true,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(18), effects: [.dealDamage(18)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .attack(25), effects: [.dealDamage(25)]), weight: 0.35),
        ],
        pattern: .conditional
    )

    static let nemesis = EnemyTemplate(
        id: "nemesis",
        nameKey: "enemy_nemesis",
        minHP: 140,
        maxHP: 146,
        isBoss: false,
        isElite: true,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(22), effects: [.dealDamage(22)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.vulnerable, stacks: 2), effects: [.applyDebuff(.vulnerable, stacks: 2)]), weight: 0.7),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 4), effects: [.applyBuff(.strength, stacks: 4)]), weight: 0.4),
        ],
        pattern: .sequential
    )

    static let reptomancer = EnemyTemplate(
        id: "reptomancer",
        nameKey: "enemy_reptomancer",
        minHP: 130,
        maxHP: 136,
        isBoss: false,
        isElite: true,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(16), effects: [.dealDamage(16)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .attack(30), effects: [.dealDamage(30)]), weight: 0.3),
            WeightedAction(action: EnemyAction(intent: .defend(16), effects: [.gainBlock(16)]), weight: 0.5),
        ],
        pattern: .conditional
    )

    // MARK: - Act 3 Bosses

    static let timeEater = EnemyTemplate(
        id: "time_eater",
        nameKey: "enemy_time_eater",
        minHP: 240,
        maxHP: 240,
        isBoss: true,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(20), effects: [.dealDamage(20)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .defend(22), effects: [.gainBlock(22)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 2), effects: [.applyDebuff(.weak, stacks: 2), .applyDebuff(.vulnerable, stacks: 2)]), weight: 0.4),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 2), effects: [.applyBuff(.strength, stacks: 2)]), weight: 0.3),
        ],
        pattern: .sequential
    )

    static let corruptHeart = EnemyTemplate(
        id: "corrupt_heart",
        nameKey: "enemy_corrupt_heart",
        minHP: 300,
        maxHP: 300,
        isBoss: true,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(25), effects: [.dealDamage(25)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .attack(40), effects: [.dealDamage(40)]), weight: 0.3),
            WeightedAction(action: EnemyAction(intent: .debuff(.vulnerable, stacks: 3), effects: [.applyDebuff(.vulnerable, stacks: 3)]), weight: 0.4),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 3), effects: [.applyBuff(.strength, stacks: 3)]), weight: 0.3),
        ],
        pattern: .sequential
    )

    static let awakenedOne = EnemyTemplate(
        id: "awakened_one",
        nameKey: "enemy_awakened_one",
        minHP: 260,
        maxHP: 260,
        isBoss: true,
        isElite: false,
        act: 3,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(22), effects: [.dealDamage(22)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 2), effects: [.applyDebuff(.weak, stacks: 2)]), weight: 0.5),
            WeightedAction(action: EnemyAction(intent: .attack(35), effects: [.dealDamage(35)]), weight: 0.3),
            WeightedAction(action: EnemyAction(intent: .buff(.strength, stacks: 4), effects: [.applyBuff(.strength, stacks: 4)]), weight: 0.4),
        ],
        pattern: .conditional
    )

    // MARK: - All Enemies

    static let allEnemies: [EnemyTemplate] = [
        // Act 1
        cultist, jawWorm, slime, fungusBeast, blueSlime,
        gremlinNob, lagavulin, gremlinLeader,
        slimeBoss, hexaghost, guardian,
        // Act 2
        byrd, chokeOrb, shellParasite, sphericGuardian, chosen,
        bronzeAutomaton, bookOfStabbing, giantWorm,
        theChamp, collector, bronzeAutomatonPrime,
        // Act 3
        darkling, orbWalker, spiker, spireGrowth, transmogrifier,
        giantHead, nemesis, reptomancer,
        timeEater, corruptHeart, awakenedOne
    ]

    // MARK: - Multi-Enemy Encounters

    struct MultiEnemyEncounter {
        let enemyIDs: [String]
        let act: Int
        let isElite: Bool
    }

    static let multiEncounters: [MultiEnemyEncounter] = [
        // Act 1
        MultiEnemyEncounter(enemyIDs: ["blue_slime", "blue_slime"], act: 1, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["slime", "slime"], act: 1, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["slime", "blue_slime"], act: 1, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["cultist", "blue_slime"], act: 1, isElite: false),
        // Act 2
        MultiEnemyEncounter(enemyIDs: ["byrd", "byrd"], act: 2, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["choke_orb", "shell_parasite"], act: 2, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["byrd", "choke_orb"], act: 2, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["chosen", "spheric_guardian"], act: 2, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["fungus_beast", "fungus_beast"], act: 2, isElite: false),
        // Act 3
        MultiEnemyEncounter(enemyIDs: ["darkling", "darkling"], act: 3, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["orb_walker", "spiker"], act: 3, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["darkling", "darkling", "darkling"], act: 3, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["giant_head", "spire_growth"], act: 3, isElite: false),
        MultiEnemyEncounter(enemyIDs: ["orb_walker", "orb_walker"], act: 3, isElite: false),
    ]

    // MARK: - Accessors

    static func enemy(byID id: String) -> EnemyTemplate? {
        allEnemies.first { $0.id == id }
    }

    static func randomBattle(act: Int) -> [EnemyTemplate] {
        // 25% chance of multi-enemy encounter
        if Double.random(in: 0...1) < 0.25 {
            let multis = multiEncounters.filter { $0.act == act && !$0.isElite }
            if let encounter = multis.randomElement() {
                let templates = encounter.enemyIDs.compactMap { enemy(byID: $0) }
                if !templates.isEmpty { return templates }
            }
        }
        let normal = allEnemies.filter { $0.act == act && !$0.isElite && !$0.isBoss }
        guard let enemy = normal.randomElement() else { return [cultist] }
        return [enemy]
    }

    static func eliteBattle(act: Int) -> [EnemyTemplate] {
        let elites = allEnemies.filter { $0.act == act && $0.isElite }
        guard let elite = elites.randomElement() else { return [cultist] }
        return [elite]
    }

    static func bossBattle(act: Int) -> [EnemyTemplate] {
        let bosses = allEnemies.filter { $0.act == act && $0.isBoss }
        guard let boss = bosses.randomElement() else { return [cultist] }
        return [boss]
    }
}
