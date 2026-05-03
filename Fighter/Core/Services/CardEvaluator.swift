//
//  CardEvaluator.swift
//  Fighter
//

import Foundation

struct CardEvaluator {

    static func resolve(
        _ effects: [Effect],
        card: Card,
        targetEnemyIndex: Int?,
        store: GameStore
    ) {
        for effect in effects {
            resolveSingle(effect, card: card, targetEnemyIndex: targetEnemyIndex, store: store)
        }
    }

    private static func resolveSingle(
        _ effect: Effect,
        card: Card,
        targetEnemyIndex: Int?,
        store: GameStore
    ) {
        guard let combat = store.combatState else { return }
        let player = store.player

        switch effect {
        case .dealDamage(let amount):
            guard let idx = targetEnemyIndex, combat.enemies.indices.contains(idx) else { return }
            var finalDamage = calculateDamage(
                base: amount,
                strength: player.buffStacks(.strength),
                targetVulnerable: combat.enemies[idx].buffs.contains(where: { $0.type == .vulnerable && $0.stacks > 0 }),
                playerWeak: player.hasDebuff(.weak)
            )
            if player.penNibActive {
                finalDamage *= 2
                player.penNibActive = false
            }
            applyDamage(finalDamage, toEnemyAtIndex: idx, combat: combat)

        case .dealDamageMulti(let amount, let hits):
            guard let idx = targetEnemyIndex, combat.enemies.indices.contains(idx) else { return }
            let finalDamage = calculateDamage(
                base: amount,
                strength: player.buffStacks(.strength),
                targetVulnerable: combat.enemies[idx].buffs.contains(where: { $0.type == .vulnerable && $0.stacks > 0 }),
                playerWeak: player.hasDebuff(.weak)
            )
            for _ in 0..<hits {
                applyDamage(finalDamage, toEnemyAtIndex: idx, combat: combat)
                guard combat.enemies[idx].isAlive else { break }
            }

        case .dealDamageToAll(let amount):
            for i in combat.enemies.indices where combat.enemies[i].isAlive {
                let finalDamage = calculateDamage(
                    base: amount,
                    strength: player.buffStacks(.strength),
                    targetVulnerable: combat.enemies[i].buffs.contains(where: { $0.type == .vulnerable && $0.stacks > 0 }),
                    playerWeak: player.hasDebuff(.weak)
                )
                applyDamage(finalDamage, toEnemyAtIndex: i, combat: combat)
            }

        case .gainBlock(let amount):
            let finalBlock = calculateBlock(
                base: amount,
                dexterity: player.buffStacks(.dexterity),
                frail: player.hasDebuff(.frail)
            )
            player.combatBlock += finalBlock

        case .applyBuff(let type, let stacks):
            player.addBuff(BuffInstance(type: type, stacks: stacks))

        case .applyBuffToAll(let type, let stacks):
            for i in combat.enemies.indices where combat.enemies[i].isAlive {
                combat.enemies[i].addBuff(BuffInstance(type: type, stacks: stacks))
            }

        case .applyDebuff(let type, let stacks):
            guard let idx = targetEnemyIndex, combat.enemies.indices.contains(idx) else { return }
            // Artifact: block debuff if enemy has stacks
            if combat.enemies[idx].buffStacks(.artifact) > 0 {
                if let aIdx = combat.enemies[idx].buffs.firstIndex(where: { $0.type == .artifact }) {
                    combat.enemies[idx].buffs[aIdx].stacks -= 1
                    if combat.enemies[idx].buffs[aIdx].stacks <= 0 {
                        combat.enemies[idx].buffs.remove(at: aIdx)
                    }
                }
            } else {
                combat.enemies[idx].addBuff(BuffInstance(type: type, stacks: stacks, isDurationBased: true))
            }

        case .applyDebuffToAll(let type, let stacks):
            for i in combat.enemies.indices where combat.enemies[i].isAlive {
                // Artifact: block debuff if enemy has stacks
                if combat.enemies[i].buffStacks(.artifact) > 0 {
                    if let aIdx = combat.enemies[i].buffs.firstIndex(where: { $0.type == .artifact }) {
                        combat.enemies[i].buffs[aIdx].stacks -= 1
                        if combat.enemies[i].buffs[aIdx].stacks <= 0 {
                            combat.enemies[i].buffs.remove(at: aIdx)
                        }
                    }
                } else {
                    combat.enemies[i].addBuff(BuffInstance(type: type, stacks: stacks, isDurationBased: true))
                }
            }

        case .drawCards(let count):
            drawCards(count, combat: combat)

        case .discardCards(let count):
            for _ in 0..<count where !combat.hand.isEmpty {
                let c = combat.hand.removeLast()
                combat.discardPile.append(c)
            }

        case .exhaustFromHand:
            if let idx = combat.hand.firstIndex(where: { $0.id == card.id }) {
                let c = combat.hand.remove(at: idx)
                combat.exhaustPile.append(c)
                CombatEngine.triggerRelics(.onExhaust, store: store)
            }

        case .exhaustRandomFromHand(let count):
            for _ in 0..<count {
                guard !combat.hand.isEmpty else { break }
                let idx = Int.random(in: 0..<combat.hand.count)
                let c = combat.hand.remove(at: idx)
                combat.exhaustPile.append(c)
            }

        case .returnFromDiscard(let count):
            let available = combat.discardPile
            let toReturn = Array(available.suffix(min(count, available.count)))
            for c in toReturn {
                if let idx = combat.discardPile.firstIndex(where: { $0.id == c.id }) {
                    combat.discardPile.remove(at: idx)
                    combat.hand.append(c)
                }
            }

        case .gainEnergy(let amount):
            player.combatEnergy += amount

        case .gainEnergyNextTurn(let amount):
            player.energyNextTurnBonus += amount

        case .heal(let amount):
            player.currentHP = min(player.currentHP + amount, player.maxHP)

        case .addCardToHand(let templateKey):
            if let newCard = CardDatabase.card(byKey: templateKey) {
                combat.hand.append(newCard.copy())
            }

        case .addCardToDiscard(let templateKey):
            if let newCard = CardDatabase.card(byKey: templateKey) {
                combat.discardPile.append(newCard.copy())
            }

        case .addCardToDrawPile(let templateKey):
            if let newCard = CardDatabase.card(byKey: templateKey) {
                combat.drawPile.append(newCard.copy())
            }

        case .removeFromCombat(let templateKey):
            combat.hand.removeAll { $0.templateKey == templateKey }
            combat.drawPile.removeAll { $0.templateKey == templateKey }
            combat.discardPile.removeAll { $0.templateKey == templateKey }

        case .ifHasDebuff(let buffType, let thenEffects):
            if player.hasDebuff(buffType) {
                resolve(thenEffects, card: card, targetEnemyIndex: targetEnemyIndex, store: store)
            }

        case .ifHPBelow(let threshold, let thenEffects):
            if player.currentHP < threshold {
                resolve(thenEffects, card: card, targetEnemyIndex: targetEnemyIndex, store: store)
            }

        case .ifCardInHand(let cardType, let thenEffects):
            if combat.hand.contains(where: { $0.type == cardType }) {
                resolve(thenEffects, card: card, targetEnemyIndex: targetEnemyIndex, store: store)
            }

        case .doubleStrength:
            let currentStr = player.buffStacks(.strength)
            if currentStr > 0 {
                player.addBuff(BuffInstance(type: .strength, stacks: currentStr))
            }

        case .doublePoison:
            guard let idx = targetEnemyIndex, combat.enemies.indices.contains(idx) else { return }
            let currentPoison = combat.enemies[idx].buffStacks(.poison)
            if currentPoison > 0 {
                combat.enemies[idx].addBuff(BuffInstance(type: .poison, stacks: currentPoison))
            }

        case .duplicateNextSkill:
            player.addBuff(BuffInstance(type: .drawModifier, stacks: 1)) // reuse as "duplicate next" marker
            // Simplified: draws 1 extra card as benefit proxy

        case .damageEqualToBlock:
            guard let idx = targetEnemyIndex, combat.enemies.indices.contains(idx) else { return }
            let blockDamage = player.combatBlock
            let finalDamage = calculateDamage(base: blockDamage, strength: player.buffStacks(.strength), targetVulnerable: combat.enemies[idx].buffs.contains(where: { $0.type == .vulnerable && $0.stacks > 0 }), playerWeak: player.hasDebuff(.weak))
            applyDamage(finalDamage, toEnemyAtIndex: idx, combat: combat)

        case .healOnKill(let amount):
            guard let idx = targetEnemyIndex, combat.enemies.indices.contains(idx) else { return }
            if !combat.enemies[idx].isAlive {
                player.currentHP = min(player.currentHP + amount, player.maxHP)
            }

        case .applyFrost(let stacks):
            player.addBuff(BuffInstance(type: .frost, stacks: stacks))

        case .applyDark(let stacks):
            player.addBuff(BuffInstance(type: .dark, stacks: stacks))

        case .applyFocus(let stacks):
            player.addBuff(BuffInstance(type: .focus, stacks: stacks))

        case .preventNextDamage:
            player.addBuff(BuffInstance(type: .negate, stacks: 1))

        case .doubleNextCard:
            player.addBuff(BuffInstance(type: .negate, stacks: -1)) // reuse as marker (hacky but works)

        case .randomEnemyDamage(let amount):
            let alive = combat.enemies.indices.filter { combat.enemies[$0].isAlive }
            if let idx = alive.randomElement() {
                applyDamage(amount, toEnemyAtIndex: idx, combat: combat)
            }

        case .composite(let innerEffects):
            resolve(innerEffects, card: card, targetEnemyIndex: targetEnemyIndex, store: store)
        }
    }

    // MARK: - Damage Calculation

    private static func calculateDamage(
        base: Int,
        strength: Int,
        targetVulnerable: Bool,
        playerWeak: Bool
    ) -> Int {
        var damage = base + strength
        if targetVulnerable { damage = Int(Double(damage) * 1.5) }
        if playerWeak { damage = Int(Double(damage) * 0.75) }
        return max(0, damage)
    }

    private static func calculateBlock(
        base: Int,
        dexterity: Int,
        frail: Bool
    ) -> Int {
        var block = base + dexterity
        if frail { block = Int(Double(block) * 0.75) }
        return max(0, block)
    }

    private static func applyDamage(_ damage: Int, toEnemyAtIndex idx: Int, combat: CombatState) {
        var remaining = damage
        if combat.enemies[idx].block > 0 {
            if combat.enemies[idx].block >= remaining {
                combat.enemies[idx].block -= remaining
                remaining = 0
            } else {
                remaining -= combat.enemies[idx].block
                combat.enemies[idx].block = 0
            }
        }
        combat.enemies[idx].currentHP -= remaining
    }

    static func drawCards(_ count: Int, combat: CombatState) {
        for _ in 0..<count {
            if combat.drawPile.isEmpty {
                shuffleDiscardIntoDraw(combat: combat)
            }
            if let c = combat.drawPile.popLast(), combat.hand.count < 10 {
                combat.hand.append(c)
            }
        }
    }

    static func shuffleDiscardIntoDraw(combat: CombatState) {
        combat.drawPile = combat.discardPile.shuffled()
        combat.discardPile = []
    }
}

// MARK: - CombatEnemy Buff Helpers

extension CombatEnemy {
    mutating func addBuff(_ buff: BuffInstance) {
        if let index = buffs.firstIndex(where: { $0.type == buff.type }) {
            buffs[index].stacks += buff.stacks
        } else {
            buffs.append(buff)
        }
    }

    func buffStacks(_ type: BuffType) -> Int {
        buffs.first(where: { $0.type == type })?.stacks ?? 0
    }
}

// MARK: - Card Copy Helper

extension Card {
    func copy() -> Card {
        Card.newInstance(
            templateKey: templateKey,
            type: type,
            rarity: rarity,
            cost: cost,
            target: target,
            characterClass: characterClass,
            effects: effects,
            upgradedEffects: upgradedEffects,
            isExhaust: isExhaust,
            isInnate: isInnate,
            isEthereal: isEthereal,
            tags: tags
        )
    }
}
