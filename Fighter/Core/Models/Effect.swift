//
//  Effect.swift
//  Fighter
//

import Foundation

/// All possible effects a card or relic can produce.
/// Adding a new card = composing existing Effect values.
/// Adding a truly new mechanic = new case + handler in CardEvaluator.
enum Effect: Codable, Sendable, Equatable {
    // MARK: - Damage
    case dealDamage(Int)
    case dealDamageMulti(Int, hits: Int)
    case dealDamageToAll(Int)

    // MARK: - Block
    case gainBlock(Int)

    // MARK: - Buff / Debuff
    case applyBuff(BuffType, stacks: Int)
    case applyBuffToAll(BuffType, stacks: Int)
    case applyDebuff(BuffType, stacks: Int)
    case applyDebuffToAll(BuffType, stacks: Int)

    // MARK: - Card Manipulation
    case drawCards(Int)
    case discardCards(Int)
    case exhaustFromHand
    case exhaustRandomFromHand(count: Int)
    case returnFromDiscard(count: Int)

    // MARK: - Energy
    case gainEnergy(Int)
    case gainEnergyNextTurn(Int)

    // MARK: - Healing
    case heal(Int)

    // MARK: - Meta
    case addCardToHand(templateKey: String)
    case addCardToDiscard(templateKey: String)
    case addCardToDrawPile(templateKey: String)
    case removeFromCombat(templateKey: String)

    // MARK: - Conditional
    case ifHasDebuff(BuffType, then: [Effect])
    case ifHPBelow(Int, then: [Effect])
    case ifCardInHand(CardType, then: [Effect])

    // MARK: - New Mechanics
    case doubleStrength
    case doublePoison
    case duplicateNextSkill
    case damageEqualToBlock
    case healOnKill(Int)
    case applyFrost(Int)
    case applyDark(Int)
    case applyFocus(Int)
    case preventNextDamage
    case doubleNextCard
    case randomEnemyDamage(Int)

    // MARK: - Composite
    case composite([Effect])
}
