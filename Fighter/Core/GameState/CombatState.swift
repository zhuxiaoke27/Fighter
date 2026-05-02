//
//  CombatState.swift
//  Fighter
//

import Foundation

enum CombatPhase: Sendable {
    case playerAction
    case targetSelection
    case enemyTurn
    case combatEnd
}

@Observable
final class CombatState {
    var turnNumber: Int = 0
    var drawPile: [Card] = []
    var hand: [Card] = []
    var discardPile: [Card] = []
    var exhaustPile: [Card] = []
    var enemies: [CombatEnemy] = []
    var isPlayerTurn: Bool = true
    var combatPhase: CombatPhase = .playerAction
    var selectedCardID: String? = nil
    var selectedTargetID: UUID? = nil
    var cardsPlayedThisTurn: Int = 0

    var drawPileCount: Int { drawPile.count }
    var discardPileCount: Int { discardPile.count }
    var exhaustPileCount: Int { exhaustPile.count }

    var isCombatOver: Bool {
        enemies.allSatisfy { !$0.isAlive }
    }

    var aliveEnemies: [CombatEnemy] {
        enemies.filter(\.isAlive)
    }

    func enemy(byID id: UUID) -> CombatEnemy? {
        enemies.first(where: { $0.id == id })
    }

    func enemyIndex(byID id: UUID) -> Int? {
        enemies.firstIndex(where: { $0.id == id })
    }

    func removeCardFromHand(id: String) -> Card? {
        guard let index = hand.firstIndex(where: { $0.id == id }) else { return nil }
        return hand.remove(at: index)
    }
}
