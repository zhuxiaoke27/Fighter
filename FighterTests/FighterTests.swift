//
//  FighterTests.swift
//  FighterTests
//
//  Created by zhuhaozheng on 2026/5/1.
//

import Testing
@testable import Fighter

struct FighterTests {

    // MARK: - CardEvaluator.calculateDamage

    @Test("Base damage equals base value with no modifiers")
    func calculateDamageBase() {
        let result = CardEvaluator.calculateDamage(base: 10, strength: 0, targetVulnerable: false, playerWeak: false)
        #expect(result == 10)
    }

    @Test("Strength adds to base damage")
    func calculateDamageWithStrength() {
        let result = CardEvaluator.calculateDamage(base: 6, strength: 4, targetVulnerable: false, playerWeak: false)
        #expect(result == 10)
    }

    @Test("Negative strength reduces damage but not below 0")
    func calculateDamageNegativeStrength() {
        let result = CardEvaluator.calculateDamage(base: 3, strength: -5, targetVulnerable: false, playerWeak: false)
        #expect(result == 0)
    }

    @Test("Vulnerable target takes 50% more damage")
    func calculateDamageVulnerable() {
        // base 10 + str 0 = 10, * 1.5 = 15
        let result = CardEvaluator.calculateDamage(base: 10, strength: 0, targetVulnerable: true, playerWeak: false)
        #expect(result == 15)
    }

    @Test("Weak player deals 25% less damage")
    func calculateDamageWeak() {
        // base 10 + str 0 = 10, * 0.75 = 7 (Int(7.5) = 7)
        let result = CardEvaluator.calculateDamage(base: 10, strength: 0, targetVulnerable: false, playerWeak: true)
        #expect(result == 7)
    }

    @Test("Vulnerable and weak combine correctly")
    func calculateDamageVulnerableAndWeak() {
        // base 10 + str 2 = 12, * 1.5 = 18, * 0.75 = 13 (Int(13.5) = 13)
        let result = CardEvaluator.calculateDamage(base: 10, strength: 2, targetVulnerable: true, playerWeak: true)
        #expect(result == 13)
    }

    @Test("Zero base damage stays zero")
    func calculateDamageZeroBase() {
        let result = CardEvaluator.calculateDamage(base: 0, strength: 0, targetVulnerable: true, playerWeak: false)
        #expect(result == 0)
    }

    // MARK: - CardEvaluator.calculateBlock

    @Test("Base block equals base value with no modifiers")
    func calculateBlockBase() {
        let result = CardEvaluator.calculateBlock(base: 5, dexterity: 0, frail: false)
        #expect(result == 5)
    }

    @Test("Dexterity adds to block")
    func calculateBlockWithDexterity() {
        let result = CardEvaluator.calculateBlock(base: 5, dexterity: 3, frail: false)
        #expect(result == 8)
    }

    @Test("Frail reduces block by 25%")
    func calculateBlockFrail() {
        // base 8 + dex 0 = 8, * 0.75 = 6
        let result = CardEvaluator.calculateBlock(base: 8, dexterity: 0, frail: true)
        #expect(result == 6)
    }

    @Test("Block minimum is 0")
    func calculateBlockMinimum() {
        let result = CardEvaluator.calculateBlock(base: 0, dexterity: 0, frail: true)
        #expect(result == 0)
    }

    @Test("Frail and dexterity combine correctly")
    func calculateBlockFrailAndDexterity() {
        // base 8 + dex 4 = 12, * 0.75 = 9
        let result = CardEvaluator.calculateBlock(base: 8, dexterity: 4, frail: true)
        #expect(result == 9)
    }

    // MARK: - PlayerState

    @Test("PlayerState initializes with character class defaults")
    func playerStateInit() {
        let player = PlayerState(characterClass: .warrior)
        #expect(player.maxHP == 80)
        #expect(player.currentHP == 80)
        #expect(player.gold == 99)
        #expect(player.deck.isEmpty)
        #expect(player.relics.isEmpty)
    }

    @Test("takeDamage reduces HP")
    func playerTakeDamage() {
        let player = PlayerState(characterClass: .warrior)
        let damage = player.takeDamage(20)
        #expect(damage == 20)
        #expect(player.currentHP == 60)
        #expect(player.combatBlock == 0)
    }

    @Test("takeDamage is absorbed by block first")
    func playerTakeDamageBlocked() {
        let player = PlayerState(characterClass: .warrior)
        player.combatBlock = 10
        let damage = player.takeDamage(15)
        #expect(damage == 5)
        #expect(player.currentHP == 75)
        #expect(player.combatBlock == 0)
    }

    @Test("takeDamage fully blocked")
    func playerTakeDamageFullyBlocked() {
        let player = PlayerState(characterClass: .warrior)
        player.combatBlock = 20
        let damage = player.takeDamage(15)
        #expect(damage == 0)
        #expect(player.currentHP == 80)
        #expect(player.combatBlock == 5)
    }

    @Test("takeDamage does not go below 0 HP")
    func playerTakeDamageLethal() {
        let player = PlayerState(characterClass: .warrior)
        _ = player.takeDamage(100)
        #expect(player.currentHP == 0)
        #expect(player.isDead)
    }

    @Test("addBuff stacks same type")
    func playerAddBuffStacks() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .strength, stacks: 3))
        player.addBuff(BuffInstance(type: .strength, stacks: 2))
        #expect(player.buffStacks(.strength) == 5)
    }

    @Test("addBuff different types coexist")
    func playerAddBuffDifferentTypes() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .strength, stacks: 3))
        player.addBuff(BuffInstance(type: .dexterity, stacks: 2))
        #expect(player.buffStacks(.strength) == 3)
        #expect(player.buffStacks(.dexterity) == 2)
    }

    @Test("removeBuff removes all stacks of a type")
    func playerRemoveBuff() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .strength, stacks: 5))
        player.removeBuff(.strength)
        #expect(player.buffStacks(.strength) == 0)
    }

    @Test("hasDebuff returns true for debuff with stacks")
    func playerHasDebuff() {
        let player = PlayerState(characterClass: .warrior)
        #expect(!player.hasDebuff(.weak))
        player.addBuff(BuffInstance(type: .weak, stacks: 2, isDurationBased: true))
        #expect(player.hasDebuff(.weak))
    }

    @Test("tickBuffs reduces duration-based buff stacks")
    func playerTickBuffs() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .vulnerable, stacks: 2, isDurationBased: true))
        player.tickBuffs()
        #expect(player.buffStacks(.vulnerable) == 1)
        player.tickBuffs()
        #expect(player.buffStacks(.vulnerable) == 0)
    }

    @Test("tickBuffs removes expired buffs")
    func playerTickBuffsRemovesExpired() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .weak, stacks: 1, isDurationBased: true))
        player.tickBuffs()
        #expect(player.buffStacks(.weak) == 0)
        #expect(player.buffs.first(where: { $0.type == .weak }) == nil)
    }

    @Test("tickBuffs does not affect non-duration buffs")
    func playerTickBuffsNonDuration() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .strength, stacks: 5))
        player.tickBuffs()
        #expect(player.buffStacks(.strength) == 5)
    }

    @Test("negate buff prevents next damage")
    func playerNegateBuff() {
        let player = PlayerState(characterClass: .warrior)
        player.addBuff(BuffInstance(type: .negate, stacks: 1))
        let damage = player.takeDamage(50)
        #expect(damage == 0)
        #expect(player.currentHP == 80)
        #expect(player.buffStacks(.negate) == 0)
    }

    @Test("resetForCombat applies permanent bonuses")
    func playerResetForCombat() {
        let player = PlayerState(characterClass: .warrior)
        player.permanentStrengthBonus = 3
        player.permanentDexterityBonus = 2
        player.permanentBlockBonus = 5
        player.resetForCombat()
        #expect(player.buffStacks(.strength) == 3)
        #expect(player.buffStacks(.dexterity) == 2)
        #expect(player.combatBlock == 5)
    }

    // MARK: - CardEvaluator.drawCards

    @Test("drawCards moves cards from draw pile to hand")
    func drawCardsBasic() {
        let combat = CombatState()
        let store = GameStore()
        store.combatState = combat

        for _ in 0..<5 {
            if let card = CardDatabase.card(byKey: "strike_warrior") {
                combat.drawPile.append(card.copy())
            }
        }

        CardEvaluator.drawCards(3, combat: combat, store: store)

        #expect(combat.hand.count == 3)
        #expect(combat.drawPile.count == 2)
    }

    @Test("drawCards respects hand limit of 10")
    func drawCardsHandLimit() {
        let combat = CombatState()
        let store = GameStore()
        store.combatState = combat

        // Fill hand to 9
        for _ in 0..<9 {
            if let card = CardDatabase.card(byKey: "strike_warrior") {
                combat.hand.append(card.copy())
            }
        }
        // Add cards to draw pile
        for _ in 0..<5 {
            if let card = CardDatabase.card(byKey: "strike_warrior") {
                combat.drawPile.append(card.copy())
            }
        }

        CardEvaluator.drawCards(5, combat: combat, store: store)

        #expect(combat.hand.count == 10)
    }

    @Test("drawCards shuffles discard pile when draw pile is empty")
    func drawCardsShufflesDiscard() {
        let combat = CombatState()
        let store = GameStore()
        store.combatState = combat

        // Put cards in discard, not draw pile
        for _ in 0..<3 {
            if let card = CardDatabase.card(byKey: "strike_warrior") {
                combat.discardPile.append(card.copy())
            }
        }

        CardEvaluator.drawCards(2, combat: combat, store: store)

        #expect(combat.hand.count == 2)
        #expect(combat.discardPile.isEmpty)
    }
}
