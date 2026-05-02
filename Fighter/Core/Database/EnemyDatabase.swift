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
        minHP: 48,
        maxHP: 54,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(11), effects: [.dealDamage(11)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .attack(6), effects: [.dealDamage(6)]), weight: 0.7),
        ],
        pattern: .random
    )

    static let jawWorm = EnemyTemplate(
        id: "jaw_worm",
        nameKey: "enemy_jaw_worm",
        minHP: 40,
        maxHP: 44,
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
        minHP: 27,
        maxHP: 31,
        isBoss: false,
        isElite: false,
        act: 1,
        actions: [
            WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10)]), weight: 1.0),
            WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 1), effects: [.applyDebuff(.weak, stacks: 1)]), weight: 0.5),
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

    // MARK: - Act 1 Boss

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

    // MARK: - Act 2 Boss

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

    // MARK: - Act 3 Boss

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

    // MARK: - All Enemies

    static let allEnemies: [EnemyTemplate] = [
        // Act 1
        cultist, jawWorm, slime,
        gremlinNob,
        slimeBoss,
        // Act 2
        byrd, chokeOrb, shellParasite,
        bronzeAutomaton,
        theChamp,
        // Act 3
        darkling, orbWalker, spiker,
        giantHead,
        timeEater
    ]

    // MARK: - Accessors

    static func enemy(byID id: String) -> EnemyTemplate? {
        allEnemies.first { $0.id == id }
    }

    static func randomBattle(act: Int) -> [EnemyTemplate] {
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
