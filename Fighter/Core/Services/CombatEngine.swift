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

        // Apply run modifier: extra boss HP
        if let modifier = store.activeModifier {
            for effect in modifier.effects {
                switch effect {
                case .extraBossHP(let multiplier):
                    for i in combat.enemies.indices where combat.enemies[i].isBoss {
                        let scaledHP = Int(Double(combat.enemies[i].maxHP) * multiplier)
                        combat.enemies[i].maxHP = scaledHP
                        combat.enemies[i].currentHP = scaledHP
                    }
                default:
                    break
                }
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
        combat.cardsPlayedThisTurn = 0

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

        // Frost: gain block at turn start
        let frostStacks = store.player.buffStacks(.frost)
        if frostStacks > 0 {
            let focusBonus = store.player.buffStacks(.focus)
            store.player.combatBlock += frostStacks + focusBonus
        }

        // Dark: deal random damage at turn start
        let darkStacks = store.player.buffStacks(.dark)
        if darkStacks > 0, let combat = store.combatState {
            let focusBonus = store.player.buffStacks(.focus)
            let damage = darkStacks + focusBonus
            let aliveIndices = combat.enemies.indices.filter { combat.enemies[$0].isAlive }
            if let idx = aliveIndices.randomElement() {
                combat.enemies[idx].currentHP -= damage
            }
        }

        triggerRelics(.onTurnStart, store: store)
    }

    // MARK: - Play Card

    static func playCard(cardID: String, targetEnemyID: UUID?, store: GameStore) {
        guard let combat = store.combatState,
              let card = combat.hand.first(where: { $0.id == cardID }) else { return }

        guard store.player.combatEnergy >= card.cost, card.cost >= 0 else { return }

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

        // Track cards played this turn for Time Eater
        combat.cardsPlayedThisTurn += 1

        // Time Eater: force end turn after 12 cards
        let hasTimeEater = combat.enemies.contains { $0.templateID == "time_eater" && $0.isAlive }
        if hasTimeEater && combat.cardsPlayedThisTurn >= 12 {
            // Time Eater devours buffs
            for i in combat.enemies.indices where combat.enemies[i].templateID == "time_eater" {
                combat.enemies[i].addBuff(BuffInstance(type: .strength, stacks: 2))
                // Inject Void into discard pile
                if let voidCard = CardDatabase.card(byKey: "void_card")?.copy() {
                    combat.discardPile.append(voidCard)
                }
            }
            // Force end player turn
            endPlayerTurn(store: store)
            return
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
            if card.isEthereal || card.isExhaust {
                combat.exhaustPile.append(card)
            } else {
                combat.discardPile.append(card)
            }
        }
        combat.hand = []

        // Status card end-of-turn effects
        var statusCardsToProcess: [Card] = []
        for card in combat.discardPile {
            if card.type == .status {
                statusCardsToProcess.append(card)
            }
        }
        for card in statusCardsToProcess {
            switch card.templateKey {
            case "burn":
                store.player.takeDamage(2)
            case "void_card":
                store.player.combatEnergy = max(0, store.player.combatEnergy - 1)
            default:
                break
            }
        }

        // Check player death from status effects
        if store.player.isDead {
            combat.combatPhase = .combatEnd
            store.endCombat(victory: false)
            return
        }

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

        // Boss mechanic checks
        checkBossMechanics(combat: combat, store: store)

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

    // MARK: - Boss Mechanics

    private static func checkBossMechanics(combat: CombatState, store: GameStore) {
        // Slime Boss: at 50% HP, split into two smaller slimes
        for i in combat.enemies.indices {
            let enemy = combat.enemies[i]
            guard enemy.isAlive else { continue }

            if enemy.templateID == "slime_boss" && enemy.currentHP <= enemy.maxHP / 2 {
                let slimeHP = enemy.currentHP / 2
                combat.enemies[i].currentHP = 0 // Remove boss

                let slimeTemplate1 = CombatEnemy(template: EnemyDatabase.cultist) // reuse as base
                var slime1 = CombatEnemy(template: EnemyTemplate(
                    id: "slime_boss_split",
                    nameKey: "enemy_slime_boss_split",
                    minHP: slimeHP, maxHP: slimeHP,
                    isBoss: false, isElite: false, act: 1,
                    actions: [
                        WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10)]), weight: 1.0),
                        WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 1), effects: [.applyDebuff(.weak, stacks: 1)]), weight: 0.5),
                    ],
                    pattern: .random
                ))
                slime1.currentHP = slimeHP
                slime1.maxHP = slimeHP

                var slime2 = CombatEnemy(template: EnemyTemplate(
                    id: "slime_boss_split",
                    nameKey: "enemy_slime_boss_split",
                    minHP: slimeHP, maxHP: slimeHP,
                    isBoss: false, isElite: false, act: 1,
                    actions: [
                        WeightedAction(action: EnemyAction(intent: .attack(10), effects: [.dealDamage(10)]), weight: 1.0),
                        WeightedAction(action: EnemyAction(intent: .debuff(.weak, stacks: 1), effects: [.applyDebuff(.weak, stacks: 1)]), weight: 0.5),
                    ],
                    pattern: .random
                ))
                slime2.currentHP = slimeHP
                slime2.maxHP = slimeHP

                determineNextIntent(for: &slime1)
                determineNextIntent(for: &slime2)
                combat.enemies.append(slime1)
                combat.enemies.append(slime2)
            }

            // Champ: enrage below 30% HP — gain strength and Metallicize
            if enemy.templateID == "the_champ" && enemy.currentHP <= enemy.maxHP * 3 / 10 {
                combat.enemies[i].addBuff(BuffInstance(type: .strength, stacks: 5))
                combat.enemies[i].addBuff(BuffInstance(type: .metallicize, stacks: 6))
            }
        }
    }

    // MARK: - Enemy AI

    private static func determineNextIntent(for enemy: inout CombatEnemy) {
        guard let template = EnemyDatabase.enemy(byID: enemy.templateID),
              !template.actions.isEmpty else {
            let damage = Int.random(in: 5...12)
            enemy.nextIntent = .attack(damage)
            enemy.nextAction = EnemyAction(intent: .attack(damage), effects: [.dealDamage(damage)])
            return
        }

        switch template.pattern {
        case .sequential:
            let index = enemy.actionIndex % template.actions.count
            let weighted = template.actions[index]
            enemy.nextIntent = weighted.action.intent
            enemy.nextAction = weighted.action
            enemy.actionIndex += 1

        case .conditional:
            if enemy.currentHP > enemy.maxHP * 3 / 4 && template.actions.contains(where: { isBuffAction($0.action) }) {
                let buffActions = template.actions.filter { isBuffAction($0.action) }
                let picked = pickWeighted(buffActions)
                enemy.nextIntent = picked.intent
                enemy.nextAction = picked
            } else if enemy.block == 0 && template.actions.contains(where: { isDefendAction($0.action) }) {
                let defendActions = template.actions.filter { isDefendAction($0.action) }
                let picked = pickWeighted(defendActions)
                enemy.nextIntent = picked.intent
                enemy.nextAction = picked
            } else {
                let attackActions = template.actions.filter { isAttackAction($0.action) }
                if attackActions.isEmpty {
                    let picked = pickWeighted(template.actions)
                    enemy.nextIntent = picked.intent
                    enemy.nextAction = picked
                } else {
                    let picked = pickWeighted(attackActions)
                    enemy.nextIntent = picked.intent
                    enemy.nextAction = picked
                }
            }

        case .random:
            let picked = pickWeighted(template.actions)
            enemy.nextIntent = picked.intent
            enemy.nextAction = picked
        }
    }

    private static func pickWeighted(_ actions: [WeightedAction]) -> EnemyAction {
        let totalWeight = actions.reduce(0.0) { $0 + $1.weight }
        var roll = Double.random(in: 0...totalWeight)
        for weighted in actions {
            roll -= weighted.weight
            if roll <= 0 { return weighted.action }
        }
        return actions.last!.action
    }

    private static func isAttackAction(_ action: EnemyAction) -> Bool {
        if case .attack = action.intent { return true }
        if case .attackMulti = action.intent { return true }
        return false
    }

    private static func isDefendAction(_ action: EnemyAction) -> Bool {
        if case .defend = action.intent { return true }
        return false
    }

    private static func isBuffAction(_ action: EnemyAction) -> Bool {
        if case .buff = action.intent { return true }
        return false
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
                // New relics
                case "happy_flower":
                    if combat.turnNumber % 3 == 0 {
                        player.combatEnergy += 1
                    }
                case "red_skull":
                    if player.currentHP <= player.maxHP / 2 {
                        player.addBuff(BuffInstance(type: .strength, stacks: 1))
                    }
                case "kunai":
                    if player.attackCardsPlayedThisCombat % 3 == 0 {
                        player.addBuff(BuffInstance(type: .dexterity, stacks: 1))
                    }
                case "wrist_blade":
                    if player.attackCardsPlayedThisCombat % 5 == 0 {
                        player.penNibActive = true
                    }
                case "pantograph":
                    if player.currentHP <= player.maxHP / 2 {
                        player.currentHP = min(player.currentHP + 5, player.maxHP)
                    }
                case "paper_crane":
                    for i in combat.enemies.indices where combat.enemies[i].isAlive {
                        if combat.enemies[i].buffStacks(.strength) > 0 {
                            combat.enemies[i].addBuff(BuffInstance(type: .weak, stacks: 1, isDurationBased: true))
                        }
                    }
                case "strange_spoon":
                    if Double.random(in: 0...1) < 0.5, !combat.exhaustPile.isEmpty {
                        let card = combat.exhaustPile.removeLast()
                        combat.discardPile.append(card)
                    }
                case "du_vu_doll":
                    let curseCount = store.player.deck.filter { $0.type == .curse }.count
                    if curseCount > 0 {
                        player.addBuff(BuffInstance(type: .strength, stacks: curseCount))
                    }
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
             (.onExhaust, .onExhaust),
             (.onDraw, .onDraw),
             (.onGainStrength, .onGainStrength),
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
