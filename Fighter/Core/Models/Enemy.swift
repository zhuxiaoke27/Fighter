//
//  Enemy.swift
//  Fighter
//

import Foundation

enum EnemyIntent: Sendable {
    case attack(Int)
    case attackMulti(damages: [(Int, Int)]) // [(damage, hits)]
    case defend(Int)
    case buff(BuffType, stacks: Int)
    case debuff(BuffType, stacks: Int)
    case unknown
}

struct EnemyAction: Sendable {
    let intent: EnemyIntent
    let effects: [Effect]
}

enum EnemyAIPattern: String, Codable, Sendable {
    case random
    case sequential
    case conditional
}

struct WeightedAction: Sendable {
    let action: EnemyAction
    let weight: Double
}

struct EnemyTemplate: Identifiable, Sendable {
    let id: String
    let nameKey: String
    let minHP: Int
    let maxHP: Int
    let isBoss: Bool
    let isElite: Bool
    let act: Int
    let actions: [WeightedAction]
    let pattern: EnemyAIPattern
}

struct CombatEnemy: Identifiable {
    let id: UUID
    let templateID: String
    var currentHP: Int
    var maxHP: Int
    var block: Int
    var buffs: [BuffInstance]
    var nextIntent: EnemyIntent?
    var nextAction: EnemyAction?
    var actionIndex: Int

    var isAlive: Bool { currentHP > 0 }

    init(template: EnemyTemplate) {
        self.id = UUID()
        self.templateID = template.id
        self.maxHP = Int.random(in: template.minHP...template.maxHP)
        self.currentHP = self.maxHP
        self.block = 0
        self.buffs = []
        self.nextIntent = nil
        self.nextAction = nil
        self.actionIndex = 0
    }
}
