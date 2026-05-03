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

        // Philosopher's Stone: enemies gain strength at combat start
        if store.player.relics.contains(where: { $0.id == "philosophers_stone" }) {
            for i in combat.enemies.indices {
                combat.enemies[i].addBuff(BuffInstance(type: .strength, stacks: 1))
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

        CardEvaluator.drawCards(cardsToDrawPerTurn, combat: combat, store: store)

        // Draw modifier buff: draw extra cards
        let drawMod = store.player.buffStacks(.drawModifier)
        if drawMod > 0 {
            CardEvaluator.drawCards(drawMod, combat: combat, store: store)
        }

        triggerRelics(.onDraw, store: store)

        // Innate cards: ensure they are in the opening hand
        if combat.turnNumber == 1 {
            var innateCards: [Card] = []
            for card in combat.drawPile where card.isInnate {
                if let idx = combat.drawPile.firstIndex(where: { $0.id == card.id }) {
                    innateCards.append(combat.drawPile.remove(at: idx))
                }
            }
            while combat.hand.count + innateCards.count > 10,
                  let nonInnateIdx = combat.hand.firstIndex(where: { !$0.isInnate }) {
                let removed = combat.hand.remove(at: nonInnateIdx)
                combat.drawPile.append(removed)
            }
            combat.hand.append(contentsOf: innateCards)
        }

        let metallicize = store.player.buffStacks(.metallicize)
        if metallicize > 0 {
            store.player.combatBlock += metallicize
        }

        // Persistent power buffs
        let demonFormStacks = store.player.buffStacks(.demonForm)
        if demonFormStacks > 0 {
            store.player.addBuff(BuffInstance(type: .strength, stacks: demonFormStacks))
        }
        let noxiousFumesStacks = store.player.buffStacks(.noxiousFumes)
        if noxiousFumesStacks > 0 {
            for i in combat.enemies.indices where combat.enemies[i].isAlive {
                combat.enemies[i].addBuff(BuffInstance(type: .poison, stacks: noxiousFumesStacks))
            }
        }

        // Plated Armor: gain block at turn start
        let platedArmor = store.player.buffStacks(.platedArmor)
        if platedArmor > 0 {
            store.player.combatBlock += platedArmor
        }

        // Regenerate: heal at turn start
        let regenStacks = store.player.buffStacks(.regenerate)
        if regenStacks > 0 {
            let healed = min(regenStacks, store.player.maxHP - store.player.currentHP)
            store.player.currentHP += healed
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
                store.player.totalDamageDealt += damage
            }
        }

        triggerRelics(.onTurnStart, store: store)
    }

    // MARK: - Play Card

    static func playCard(cardID: String, targetEnemyID: UUID?, store: GameStore) {
        guard let combat = store.combatState,
              let card = combat.hand.first(where: { $0.id == cardID }) else { return }

        // Normality: block if 3+ cards played this turn
        if combat.hand.contains(where: { $0.templateKey == "normality" }) && combat.cardsPlayedThisTurn >= 3 {
            return
        }

        guard store.player.combatEnergy >= card.cost, card.cost >= 0 else { return }

        // Clash restriction: can only play if all cards in hand are attacks
        if card.templateKey == "clash_warrior" {
            let allAttacks = combat.hand.allSatisfy { $0.type == .attack }
            guard allAttacks else { return }
        }

        store.player.combatEnergy -= card.cost
        combat.removeCardFromHand(id: card.id)

        let targetIndex: Int? = if let targetID = targetEnemyID {
            combat.enemies.firstIndex(where: { $0.id == targetID })
        } else {
            nil
        }

        CardEvaluator.resolve(card.resolvedEffects, card: card, targetEnemyIndex: targetIndex, store: store)

        // Pain: take 1 damage when playing any card while Pain is in hand
        if combat.hand.contains(where: { $0.templateKey == "pain" }) {
            store.player.takeDamage(1)
        }

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
            triggerRelics(.onExhaust, store: store)
        } else {
            combat.discardPile.append(card)
        }

        // Check for enemy kills from card play
        let hadKill = combat.enemies.contains { !$0.isAlive }
        if hadKill {
            triggerRelics(.onEnemyKilled, store: store)
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

        // Curse card end-of-turn effects (before hand is cleared)
        var curseCards: [Card] = []
        for card in combat.hand where card.type == .curse {
            curseCards.append(card)
        }
        for card in curseCards {
            switch card.templateKey {
            case "decay": store.player.takeDamage(2)
            case "doubt": store.player.addBuff(BuffInstance(type: .weak, stacks: 1, isDurationBased: true))
            case "regret": store.player.takeDamage(combat.hand.count)
            case "shame": store.player.addBuff(BuffInstance(type: .frail, stacks: 1, isDurationBased: true))
            default: break
            }
        }

        // Runic Pyramid: retain hand at end of turn (only exhaust ethereal/exhaust cards)
        let hasRunicPyramid = store.player.relics.contains(where: { $0.id == "runic_pyramid" })
        if hasRunicPyramid {
            var retained: [Card] = []
            for card in combat.hand {
                if card.isEthereal || card.isExhaust {
                    combat.exhaustPile.append(card)
                } else {
                    retained.append(card)
                }
            }
            combat.hand = retained
        } else {
            // Status card end-of-turn effects (process from hand before discarding)
            for card in combat.hand where card.type == .status {
                switch card.templateKey {
                case "burn":
                    store.player.takeDamage(2)
                case "void_card":
                    store.player.combatEnergy = max(0, store.player.combatEnergy - 1)
                default:
                    break
                }
            }

            // Fire Breathing: deal damage if hand contains curse/status
            if store.player.relics.contains(where: { $0.id == "fire_breathing" }) {
                let hasCurseOrStatus = combat.hand.contains(where: { $0.type == .curse || $0.type == .status })
                if hasCurseOrStatus {
                    for i in combat.enemies.indices where combat.enemies[i].isAlive {
                        combat.enemies[i].currentHP -= 2
                        store.player.totalDamageDealt += 2
                    }
                }
            }

            for card in combat.hand {
                if card.isEthereal || card.isExhaust {
                    combat.exhaustPile.append(card)
                } else {
                    combat.discardPile.append(card)
                }
            }
            combat.hand = []
        }

        // Trigger exhaust relics for ethereal/exhaust cards that were discarded
        let hasExhaustPileCards = !combat.exhaustPile.isEmpty
        if hasExhaustPileCards {
            triggerRelics(.onExhaust, store: store)
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
                // Juzu Bracelet: normal enemies skip their first attack
                let isNormalEnemy = !combat.enemies[i].isBoss && !combat.enemies[i].isElite
                let hasJuzuBracelet = store.player.relics.contains(where: { $0.id == "juzu_bracelet" })
                if isNormalEnemy && hasJuzuBracelet && combat.turnNumber == 1 {
                    // Skip attack action for normal enemies on turn 1
                    determineNextIntent(for: &combat.enemies[i])
                    continue
                }
                for effect in action.effects {
                    switch effect {
                    case .dealDamage(let amount):
                        let strength = combat.enemies[i].buffStacks(.strength)
                        var finalDamage = amount + strength
                        // Paper Krane: enemies with Weak deal 25% less damage
                        if store.player.relics.contains(where: { $0.id == "paper_krane" })
                            && combat.enemies[i].buffStacks(.weak) > 0 {
                            finalDamage = max(1, finalDamage * 3 / 4)
                        }
                        store.player.takeDamage(finalDamage)
                        triggerRelics(.onDamageTaken, store: store)
                        // Thorns: reflect damage back to attacker
                        let thornsStacks = store.player.buffStacks(.thorns)
                        if thornsStacks > 0 {
                            combat.enemies[i].currentHP -= thornsStacks
                            store.player.totalDamageDealt += thornsStacks
                        }
                    case .gainBlock(let amount):
                        combat.enemies[i].block += amount
                    case .applyDebuff(let type, let stacks):
                        // Artifact: block debuff if player has stacks
                        if store.player.buffStacks(.artifact) > 0 {
                            if let aIdx = store.player.buffs.firstIndex(where: { $0.type == .artifact }) {
                                store.player.buffs[aIdx].stacks -= 1
                                if store.player.buffs[aIdx].stacks <= 0 {
                                    store.player.buffs.remove(at: aIdx)
                                }
                            }
                        } else {
                            store.player.addBuff(BuffInstance(type: type, stacks: stacks, isDurationBased: true))
                        }
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
                store.player.totalDamageDealt += poisonStacks
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
            triggerRelics(.onEnemyKilled, store: store)
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
        var newEnemies: [CombatEnemy] = []
        for i in combat.enemies.indices {
            let enemy = combat.enemies[i]
            guard enemy.isAlive else { continue }

            if enemy.templateID == "slime_boss" && enemy.currentHP <= enemy.maxHP / 2 {
                let slimeHP = enemy.currentHP / 2
                combat.enemies[i].currentHP = 0 // Remove boss

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
                newEnemies.append(slime1)
                newEnemies.append(slime2)
            }

            // Champ: enrage below 30% HP — gain strength and Metallicize (only once)
            if enemy.templateID == "the_champ" && enemy.currentHP <= enemy.maxHP * 3 / 10
               && !enemy.buffs.contains(where: { $0.type == .metallicize }) {
                combat.enemies[i].addBuff(BuffInstance(type: .strength, stacks: 5))
                combat.enemies[i].addBuff(BuffInstance(type: .metallicize, stacks: 6))
            }
        }
        combat.enemies.append(contentsOf: newEnemies)
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
        guard let last = actions.last else {
            return EnemyAction(intent: .attack(5), effects: [.dealDamage(5)])
        }
        let totalWeight = actions.reduce(0.0) { $0 + $1.weight }
        var roll = Double.random(in: 0...totalWeight)
        for weighted in actions {
            roll -= weighted.weight
            if roll <= 0 { return weighted.action }
        }
        return last.action
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
        let combat = store.combatState
        let player = store.player

        for relic in player.relics {
            for relicEffect in relic.effects {
                guard matchesTrigger(relicEffect.trigger, event: event) else { continue }

                // Special-case relics that need combat counters
                switch relic.id {
                case "shuriken":
                    if player.attackCardsPlayedThisCombat > 0 && player.attackCardsPlayedThisCombat % 3 == 0 {
                        player.addBuff(BuffInstance(type: .strength, stacks: 1))
                    }
                case "pen_nib":
                    if player.attackCardsPlayedThisCombat > 0 && player.attackCardsPlayedThisCombat % 5 == 0 {
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
                    if let combat = store.combatState,
                       let randomCard = CardDatabase.randomCard() {
                        let copy = randomCard.copy()
                        combat.hand.append(copy)
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
                    if let combat, combat.turnNumber % 3 == 0 {
                        player.combatEnergy += 1
                    }
                case "red_skull":
                    if player.currentHP <= player.maxHP / 2 {
                        player.addBuff(BuffInstance(type: .strength, stacks: 1))
                    }
                case "kunai":
                    if player.attackCardsPlayedThisCombat > 0 && player.attackCardsPlayedThisCombat % 3 == 0 {
                        player.addBuff(BuffInstance(type: .dexterity, stacks: 1))
                    }
                case "wrist_blade":
                    player.combatBlock += 2
                case "pantograph":
                    if player.currentHP <= player.maxHP / 2 {
                        player.currentHP = min(player.currentHP + 5, player.maxHP)
                    }
                // New common relics
                case "juzu_bracelet":
                    break // handled in executeEnemyTurn — normal enemies skip first attack
                case "orichalcum_heavy":
                    if player.combatBlock == 0 {
                        player.combatBlock += 4
                    }
                // New uncommon relics
                case "champion_belt":
                    break // handled in CardEvaluator — when applying vulnerable, also apply 1 weak
                case "fire_breathing":
                    break // handled in endPlayerTurn — checks hand for curse/status cards
                case "paper_krane":
                    break // handled in takeDamage — enemies with weak deal 25% less damage
                case "thread_and_needle":
                    player.addBuff(BuffInstance(type: .platedArmor, stacks: 4))
                // New rare relics
                case "snecko_eye":
                    if let combat {
                        CardEvaluator.drawCards(2, combat: combat, store: store)
                        // Randomize all card costs in hand to 0-3
                        for i in combat.hand.indices {
                            combat.hand[i].cost = Int.random(in: 0...3)
                        }
                        // Also randomize draw pile
                        for i in combat.drawPile.indices {
                            combat.drawPile[i].cost = Int.random(in: 0...3)
                        }
                    }
                case "runic_pyramid":
                    break // handled in endPlayerTurn — skip discarding hand
                // New boss relics
                case "empty_cage":
                    break // handled in GameStore — remove 2 cards from deck at run start
                case "busted_crown":
                    player.combatEnergy += 1
                    // Card rewards show only 2 cards — handled in RewardView
                case "astrolabe":
                    break // handled in GameStore — transform 3 cards at run start
                case "fusion_hammer_rework":
                    player.combatEnergy += 1
                    // Cannot upgrade at rest sites — handled in RestSiteView
                case "paper_crane":
                    if let combat {
                        for i in combat.enemies.indices where combat.enemies[i].isAlive {
                            if combat.enemies[i].buffStacks(.strength) > 0 {
                                combat.enemies[i].addBuff(BuffInstance(type: .weak, stacks: 1, isDurationBased: true))
                            }
                        }
                    }
                case "strange_spoon":
                    if let combat, Double.random(in: 0...1) < 0.5, !combat.exhaustPile.isEmpty {
                        let card = combat.exhaustPile.removeLast()
                        combat.discardPile.append(card)
                    }
                case "du_vu_doll":
                    let curseCount = store.player.deck.filter { $0.type == .curse }.count
                    if curseCount > 0 {
                        player.addBuff(BuffInstance(type: .strength, stacks: curseCount))
                    }
                // Boss relics
                case "philosophers_stone":
                    player.combatEnergy += 1
                case "cursed_key":
                    player.combatEnergy += 1
                case "inserter":
                    // Inserter: gain 1 max HP when combat ends with all enemies dead
                    break // handled in GameStore.endCombat
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

    // MARK: - Card Added Trigger (works outside combat)

    static func triggerOnCardAdded(store: GameStore) {
        let player = store.player
        for relic in player.relics {
            for relicEffect in relic.effects {
                guard matchesTrigger(relicEffect.trigger, event: .onCardAdded) else { continue }
                switch relic.id {
                case "ceramic_fish":
                    player.gold += 5
                case "darkstone_periapt":
                    player.currentHP = min(player.currentHP + 5, player.maxHP)
                case "peace_pipe":
                    player.currentHP = min(player.currentHP + 3, player.maxHP)
                default:
                    break
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
