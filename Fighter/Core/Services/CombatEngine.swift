//
//  CombatEngine.swift
//  Fighter
//

import Foundation

enum CombatEngine {

    static let baseEnergyPerTurn = 3
    static let cardsToDrawPerTurn = 5

    // MARK: - Start Combat

    static func startCombat(store: GameStore) {
        guard let combat = store.combatState else { return }

        combat.drawPile = store.player.deck.shuffled()
        combat.discardPile = []
        combat.exhaustPile = []
        combat.hand = []
        combat.turnNumber = 0

        // Scale enemy HP based on act (Act 2: +10%, Act 3: +20%)
        let act = store.currentAct
        if act > 1 {
            let multiplier = 1.0 + Double(act - 1) * 0.1
            for i in combat.enemies.indices {
                let scaledHP = Int(Double(combat.enemies[i].maxHP) * multiplier)
                combat.enemies[i].maxHP = scaledHP
                combat.enemies[i].currentHP = scaledHP
            }
        }

        for i in combat.enemies.indices {
            determineNextIntent(for: &combat.enemies[i])
        }

        beginPlayerTurn(store: store)
        triggerRelics(.onCombatStart, store: store)
    }

    // MARK: - Player Turn

    static func beginPlayerTurn(store: GameStore) {
        guard let combat = store.combatState else { return }

        combat.turnNumber += 1
        combat.isPlayerTurn = true
        combat.combatPhase = .playerAction
        combat.selectedCardID = nil
        combat.selectedTargetID = nil

        if !store.player.hasDebuff(.barricade) {
            if store.player.relics.contains(where: { $0.id == "calipers" }) {
                store.player.combatBlock = store.player.combatBlock / 2
            } else {
                store.player.combatBlock = 0
            }
        }

        store.player.combatEnergy = baseEnergyPerTurn + store.player.energyNextTurnBonus
        store.player.energyNextTurnBonus = 0

        CardEvaluator.drawCards(cardsToDrawPerTurn, combat: combat)

        store.player.tickBuffs()

        let metallicize = store.player.buffStacks(.metallicize)
        if metallicize > 0 {
            store.player.combatBlock += metallicize
        }

        triggerRelics(.onTurnStart, store: store)
    }

    // MARK: - Play Card

    static func playCard(cardID: String, targetEnemyID: UUID?, store: GameStore) {
        guard let combat = store.combatState,
              let card = combat.hand.first(where: { $0.id == cardID }) else { return }

        guard store.player.combatEnergy >= card.cost else { return }

        store.player.combatEnergy -= card.cost
        combat.removeCardFromHand(id: card.id)

        let targetIndex: Int? = if let targetID = targetEnemyID {
            combat.enemies.firstIndex(where: { $0.id == targetID })
        } else {
            nil
        }

        CardEvaluator.resolve(card.resolvedEffects, card: card, targetEnemyIndex: targetIndex, store: store)

        // Track attack cards for relic counters
        if card.type == .attack {
            store.player.attackCardsPlayedThisCombat += 1
        }

        // Run statistics
        store.player.cardsPlayed += 1

        triggerRelics(.onCardPlayed(card.type), store: store)

        if card.isExhaust || card.type == .power {
            combat.exhaustPile.append(card)
        } else {
            combat.discardPile.append(card)
        }

        if combat.isCombatOver {
            combat.combatPhase = .combatEnd
            store.player.enemiesKilled += combat.enemies.filter { !$0.isAlive }.count
            store.endCombat(victory: true)
        }
    }

    // MARK: - End Player Turn

    static func endPlayerTurn(store: GameStore) {
        guard let combat = store.combatState else { return }

        combat.isPlayerTurn = false
        combat.combatPhase = .enemyTurn
        combat.selectedCardID = nil
        combat.selectedTargetID = nil

        for card in combat.hand {
            if card.isEthereal {
                combat.exhaustPile.append(card)
            } else {
                combat.discardPile.append(card)
            }
        }
        combat.hand = []

        if !store.player.hasDebuff(.barricade) {
            store.player.combatBlock = 0
        }

        store.player.tickBuffs()

        triggerRelics(.onTurnEnd, store: store)

        executeEnemyTurn(store: store)
    }

    // MARK: - Enemy Turn

    private static func executeEnemyTurn(store: GameStore) {
        guard let combat = store.combatState else { return }

        for i in combat.enemies.indices where combat.enemies[i].isAlive {
            // Reset block
            combat.enemies[i].block = 0

            // Execute enemy action
            if let action = combat.enemies[i].nextAction {
                for effect in action.effects {
                    switch effect {
                    case .dealDamage(let amount):
                        let strength = combat.enemies[i].buffStacks(.strength)
                        let finalDamage = amount + strength
                        store.player.takeDamage(finalDamage)
                        triggerRelics(.onDamageTaken, store: store)
                    case .gainBlock(let amount):
                        combat.enemies[i].block += amount
                    case .applyDebuff(let type, let stacks):
                        store.player.addBuff(BuffInstance(type: type, stacks: stacks, isDurationBased: true))
                    case .applyBuff(let type, let stacks):
                        combat.enemies[i].addBuff(BuffInstance(type: type, stacks: stacks))
                    default:
                        break
                    }
                }
            }

            // Tick duration-based buffs
            for j in combat.enemies[i].buffs.indices where combat.enemies[i].buffs[j].isDurationBased {
                combat.enemies[i].buffs[j].stacks -= 1
            }
            combat.enemies[i].buffs.removeAll(where: { $0.isDurationBased && $0.stacks <= 0 })

            // Poison damage
            let poisonStacks = combat.enemies[i].buffStacks(.poison)
            if poisonStacks > 0 {
                combat.enemies[i].currentHP -= poisonStacks
                if let poisonIdx = combat.enemies[i].buffs.firstIndex(where: { $0.type == .poison }) {
                    combat.enemies[i].buffs[poisonIdx].stacks -= 1
                    if combat.enemies[i].buffs[poisonIdx].stacks <= 0 {
                        combat.enemies[i].buffs.remove(at: poisonIdx)
                    }
                }
            }

            if !combat.enemies[i].isAlive { continue }

            // Determine next intent
            determineNextIntent(for: &combat.enemies[i])
        }

        if combat.isCombatOver {
            combat.combatPhase = .combatEnd
            store.endCombat(victory: true)
            return
        }

        if store.player.isDead {
            combat.combatPhase = .combatEnd
            store.endCombat(victory: false)
            return
        }

        beginPlayerTurn(store: store)
    }

    // MARK: - Enemy AI

    private static func determineNextIntent(for enemy: inout CombatEnemy) {
        let roll = Double.random(in: 0...1)
        if roll < 0.6 {
            let damage = Int.random(in: 5...12)
            enemy.nextIntent = .attack(damage)
            enemy.nextAction = EnemyAction(intent: .attack(damage), effects: [.dealDamage(damage)])
        } else if roll < 0.85 {
            let blockAmount = Int.random(in: 4...8)
            enemy.nextIntent = .defend(blockAmount)
            enemy.nextAction = EnemyAction(intent: .defend(blockAmount), effects: [.gainBlock(blockAmount)])
        } else {
            let damage = Int.random(in: 8...15)
            enemy.nextIntent = .attack(damage)
            enemy.nextAction = EnemyAction(intent: .attack(damage), effects: [.dealDamage(damage)])
        }
    }

    // MARK: - Relic Triggers

    static func triggerRelics(_ event: RelicTrigger, store: GameStore) {
        guard let combat = store.combatState else { return }
        let player = store.player

        for relic in player.relics {
            for relicEffect in relic.effects {
                guard matchesTrigger(relicEffect.trigger, event: event) else { continue }

                // Special-case relics that need combat counters
                switch relic.id {
                case "shuriken":
                    if player.attackCardsPlayedThisCombat % 3 == 0 {
                        player.addBuff(BuffInstance(type: .strength, stacks: 1))
                    }
                case "pen_nib":
                    if player.attackCardsPlayedThisCombat % 5 == 0 {
                        player.penNibActive = true
                    }
                case "orichalcum":
                    if player.combatBlock == 0 {
                        player.combatBlock += 6
                    }
                case "meat_on_the_bone":
                    if player.currentHP <= player.maxHP / 2 {
                        player.currentHP = min(player.currentHP + 12, player.maxHP)
                    }
                // Rare relics
                case "dead_branch":
                    if let combat = store.combatState, combat.hand.count > 1,
                       Double.random(in: 0...1) < 0.3 {
                        if let idx = combat.hand.indices.randomElement() {
                            let c = combat.hand.remove(at: idx)
                            combat.exhaustPile.append(c)
                        }
                    }
                case "calipers":
                    break
                case "torsion":
                    player.addBuff(BuffInstance(type: .strength, stacks: 1))
                case "fossilized_helix":
                    player.combatEnergy += 1
                case "chemical_x":
                    player.combatBlock += 5
                default:
                    // Generic: resolve effect through CardEvaluator
                    CardEvaluator.resolve(
                        [relicEffect.effect],
                        card: Card.placeholder,
                        targetEnemyIndex: nil,
                        store: store
                    )
                }
            }
        }
    }

    private static func matchesTrigger(_ relicTrigger: RelicTrigger, event: RelicTrigger) -> Bool {
        switch (relicTrigger, event) {
        case (.onCombatStart, .onCombatStart),
             (.onTurnStart, .onTurnStart),
             (.onTurnEnd, .onTurnEnd),
             (.onDamageTaken, .onDamageTaken),
             (.onDamageDealt, .onDamageDealt),
             (.onEnemyKilled, .onEnemyKilled),
             (.onPotionUsed, .onPotionUsed),
             (.onGoldGained, .onGoldGained),
             (.onCardAdded, .onCardAdded),
             (.onShuffle, .onShuffle),
             (.passive, .passive):
            return true
        case (.onCardPlayed(let relicType), .onCardPlayed(let eventType)):
            return relicType == eventType
        default:
            return false
        }
    }

    // MARK: - Potion Use

    static func usePotion(potionIndex: Int, targetEnemyID: UUID?, store: GameStore) {
        guard let combat = store.combatState,
              potionIndex >= 0, potionIndex < store.player.potions.count,
              let potion = store.player.potions[potionIndex] else { return }

        let targetIndex: Int? = if let targetID = targetEnemyID {
            combat.enemies.firstIndex(where: { $0.id == targetID })
        } else {
            nil
        }

        CardEvaluator.resolve(
            potion.effects,
            card: Card.placeholder,
            targetEnemyIndex: targetIndex,
            store: store
        )

        store.player.potions[potionIndex] = nil
        triggerRelics(.onPotionUsed, store: store)

        if combat.isCombatOver {
            combat.combatPhase = .combatEnd
            store.endCombat(victory: true)
        }
    }
}
