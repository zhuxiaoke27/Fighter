//
//  PlayerState.swift
//  Fighter
//

import Foundation

@Observable
final class PlayerState {
    let characterClass: CharacterClass

    // Run-level stats
    var maxHP: Int
    var currentHP: Int
    var gold: Int
    var deck: [Card]
    var relics: [RelicTemplate] = []
    var potions: [PotionTemplate?] = [nil, nil, nil]

    // Combat-level (reset each combat)
    var combatEnergy: Int = 0
    var combatBlock: Int = 0
    var buffs: [BuffInstance] = []
    var energyNextTurnBonus: Int = 0
    var attackCardsPlayedThisCombat: Int = 0
    var penNibActive: Bool = false

    // Run statistics
    var enemiesKilled: Int = 0
    var cardsPlayed: Int = 0
    var totalDamageDealt: Int = 0
    var floorsVisited: Int = 0

    // Permanent stat bonuses from events (persist across combats)
    var permanentStrengthBonus: Int = 0
    var permanentDexterityBonus: Int = 0

    init(characterClass: CharacterClass) {
        self.characterClass = characterClass
        self.maxHP = characterClass.baseHP
        self.currentHP = characterClass.baseHP
        self.gold = characterClass.startingGold
        self.deck = []
    }

    func resetForCombat() {
        combatEnergy = 0
        combatBlock = 0
        buffs = []
        energyNextTurnBonus = 0
        attackCardsPlayedThisCombat = 0
        penNibActive = false

        // Apply permanent stat bonuses from events
        if permanentStrengthBonus > 0 {
            buffs.append(BuffInstance(type: .strength, stacks: permanentStrengthBonus))
        }
        if permanentDexterityBonus > 0 {
            buffs.append(BuffInstance(type: .dexterity, stacks: permanentDexterityBonus))
        }
    }

    func buffStacks(_ type: BuffType) -> Int {
        buffs.first(where: { $0.type == type })?.stacks ?? 0
    }

    func hasDebuff(_ type: BuffType) -> Bool {
        buffs.contains(where: { $0.type == type && $0.stacks > 0 })
    }

    func addBuff(_ buff: BuffInstance) {
        if let index = buffs.firstIndex(where: { $0.type == buff.type }) {
            buffs[index].stacks += buff.stacks
        } else {
            buffs.append(buff)
        }
    }

    func removeBuff(_ type: BuffType) {
        buffs.removeAll(where: { $0.type == type })
    }

    func tickBuffs() {
        for i in buffs.indices where buffs[i].isDurationBased {
            buffs[i].stacks -= 1
        }
        buffs.removeAll(where: { $0.isDurationBased && $0.stacks <= 0 })
    }

    func takeDamage(_ amount: Int) -> Int {
        // Negate buff: prevent next damage
        if buffs.contains(where: { $0.type == .negate && $0.stacks > 0 }) {
            if let idx = buffs.firstIndex(where: { $0.type == .negate }) {
                buffs[idx].stacks -= 1
                if buffs[idx].stacks <= 0 { buffs.remove(at: idx) }
            }
            return 0
        }

        var remaining = amount
        if combatBlock > 0 {
            if combatBlock >= remaining {
                combatBlock -= remaining
                remaining = 0
            } else {
                remaining -= combatBlock
                combatBlock = 0
            }
        }
        currentHP -= remaining
        if currentHP < 0 { currentHP = 0 }

        // Plated Armor: lose 1 stack when taking unblocked damage
        if remaining > 0 {
            if let paIdx = buffs.firstIndex(where: { $0.type == .platedArmor && $0.stacks > 0 }) {
                buffs[paIdx].stacks -= 1
                if buffs[paIdx].stacks <= 0 { buffs.remove(at: paIdx) }
            }
        }

        return remaining
    }

    var isDead: Bool { currentHP <= 0 }
}
