//
//  GameStore.swift
//  Fighter
//

import Foundation
import SwiftUI

enum GameState: Sendable {
    case menu
    case characterSelect
    case map
    case combat
    case reward
    case shop
    case restSite
    case event
    case gameOver(victory: Bool)
}

enum AppLanguage: String, Codable, Sendable, CaseIterable {
    case system
    case en
    case zhHans
}

struct GameSettings: Codable, Sendable, Equatable {
    var language: AppLanguage = .system
    var hapticFeedback: Bool = true
    var showDamageNumbers: Bool = true
}

@Observable
final class GameStore {
    var gameState: GameState = .menu
    var player: PlayerState
    var combatState: CombatState?
    var mapState: MapState?
    var settings: GameSettings = GameSettings()
    var navigationPath = NavigationPath()

    // Reward state
    var rewardGold: Int = 0
    var rewardCards: [Card] = []
    var rewardRelic: RelicTemplate? = nil
    var rewardPotion: PotionTemplate? = nil
    var combatVictory: Bool? = nil
    var lastBattleWasEliteOrBoss: Bool = false

    // Shop state
    var shopCards: [Card] = []
    var shopRelics: [RelicTemplate] = []
    var shopRelicPrices: [Int] = []
    var shopPotions: [PotionTemplate] = []
    var shopPotionPrices: [Int] = []

    // Event state
    var currentEvent: EventTemplate?

    init() {
        self.player = PlayerState(characterClass: .warrior)
        if let savedSettings = SaveManager.shared.loadSettings() {
            self.settings = savedSettings
        }
    }

    // MARK: - Run Lifecycle

    func startNewRun(characterClass: CharacterClass) {
        player = PlayerState(characterClass: characterClass)
        player.deck = CardDatabase.startingDeck(for: characterClass)
        player.relics = [RelicDatabase.startingRelic(for: characterClass)]
        mapState = MapGenerator.generate(act: 1)
        gameState = .map
    }

    func startCombat(enemies: [EnemyTemplate]) {
        let combat = CombatState()
        combatState = combat
        combat.enemies = enemies.map { CombatEnemy(template: $0) }
        player.resetForCombat()
        CombatEngine.startCombat(store: self)
        gameState = .combat
    }

    func endCombat(victory: Bool) {
        combatVictory = victory
        rewardRelic = nil
        rewardPotion = nil
        if victory {
            rewardGold = Int.random(in: 20...30) + currentFloor * 2
            let characterClass = player.characterClass
            let rarity = weightedRarityRoll()
            rewardCards = CardDatabase.randomCards(count: 3, rarity: rarity, for: characterClass)
            player.gold += rewardGold

            // Elite/Boss drops relic + potion
            if lastBattleWasEliteOrBoss {
                rewardRelic = RelicDatabase.randomRelic(excluding: player.relics)
                rewardPotion = PotionDatabase.randomPotion()
            }
        }
        lastBattleWasEliteOrBoss = false
    }

    func confirmCombatEnd() {
        if combatVictory == true {
            gameState = .reward
        } else {
            gameState = .gameOver(victory: false)
            SaveManager.shared.deleteSave()
        }
        combatVictory = nil
    }

    // MARK: - Encounter Routing

    func handleNodeEncounter(_ node: MapNode) {
        player.floorsVisited += 1
        switch node.type {
        case .battle:
            lastBattleWasEliteOrBoss = false
            let enemies = EnemyDatabase.randomBattle(act: currentAct)
            startCombat(enemies: enemies)
        case .elite:
            lastBattleWasEliteOrBoss = true
            let enemies = EnemyDatabase.eliteBattle(act: currentAct)
            startCombat(enemies: enemies)
        case .boss:
            lastBattleWasEliteOrBoss = true
            let enemies = EnemyDatabase.bossBattle(act: currentAct)
            startCombat(enemies: enemies)
        case .restSite:
            gameState = .restSite
        case .shop:
            prepareShop()
            gameState = .shop
        case .event:
            currentEvent = EventDatabase.randomEvent(act: currentAct)
            gameState = .event
        case .mystery:
            let roll = Int.random(in: 0...2)
            switch roll {
            case 0:
                lastBattleWasEliteOrBoss = false
                let enemies = EnemyDatabase.randomBattle(act: currentAct)
                startCombat(enemies: enemies)
            case 1:
                currentEvent = EventDatabase.randomEvent(act: currentAct)
                gameState = .event
            default:
                prepareShop()
                gameState = .shop
            }
        }
    }

    // MARK: - State Transitions Back to Map

    func completeReward(addedCard: Card?, tookRelic: Bool = false, tookPotion: Bool = false) {
        if let card = addedCard {
            player.deck.append(card)
        }
        if tookRelic, let relic = rewardRelic {
            player.relics.append(relic)
        }
        if tookPotion, let potion = rewardPotion {
            receivePotion(potion)
        }
        combatState = nil

        // Multi-act progression
        if isActComplete {
            let nextAct = currentAct + 1
            if nextAct > 3 {
                gameState = .gameOver(victory: true)
                SaveManager.shared.deleteSave()
            } else {
                mapState = MapGenerator.generate(act: nextAct)
                gameState = .map
                SaveManager.shared.save(store: self)
            }
        } else {
            gameState = .map
            SaveManager.shared.save(store: self)
        }
    }

    func completeRestSite() {
        gameState = .map
        SaveManager.shared.save(store: self)
    }

    func completeShop() {
        gameState = .map
        SaveManager.shared.save(store: self)
    }

    func completeEvent() {
        currentEvent = nil
        gameState = .map
        SaveManager.shared.save(store: self)
    }

    // MARK: - Run End

    func endRun(victory: Bool) {
        gameState = .gameOver(victory: victory)
        SaveManager.shared.deleteSave()
    }

    // MARK: - Shop Preparation

    private func prepareShop() {
        let characterClass = player.characterClass
        let pool = CardDatabase.cards(for: characterClass).filter { $0.rarity != .starter }
        shopCards = Array(pool.shuffled().prefix(5))

        // Relics: 1-2 random non-starter relics
        let relicCount = Int.random(in: 1...2)
        shopRelics = (0..<relicCount).map { _ in
            RelicDatabase.randomRelic(excluding: player.relics)
        }
        shopRelicPrices = shopRelics.map { relic in
            switch relic.rarity {
            case .common: return 150
            case .uncommon: return 250
            case .rare: return 400
            default: return 150
            }
        }

        // Potions: 1-2 random potions
        let potionCount = Int.random(in: 1...2)
        shopPotions = (0..<potionCount).map { _ in PotionDatabase.randomPotion() }
        shopPotionPrices = shopPotions.map { potion in
            switch potion.rarity {
            case .common: return 50
            case .uncommon: return 75
            case .rare: return 120
            default: return 50
            }
        }
    }

    func purchaseRelic(at index: Int) {
        guard index < shopRelics.count else { return }
        let relic = shopRelics[index]
        let price = shopRelicPrices[index]
        guard player.gold >= price else { return }
        player.gold -= price
        player.relics.append(relic)
        shopRelics.remove(at: index)
        shopRelicPrices.remove(at: index)
    }

    func purchasePotion(at index: Int) {
        guard index < shopPotions.count else { return }
        let potion = shopPotions[index]
        let price = shopPotionPrices[index]
        guard player.gold >= price else { return }
        guard player.potions.contains(where: { $0 == nil }) else { return }
        player.gold -= price
        if let slot = player.potions.firstIndex(where: { $0 == nil }) {
            player.potions[slot] = potion
        }
        shopPotions.remove(at: index)
        shopPotionPrices.remove(at: index)
    }

    func receivePotion(_ potion: PotionTemplate) {
        if let slot = player.potions.firstIndex(where: { $0 == nil }) {
            player.potions[slot] = potion
        }
    }

    // MARK: - Helpers

    var currentAct: Int {
        mapState?.act ?? 1
    }

    var currentFloor: Int {
        mapState?.currentFloor ?? 0
    }

    var isActComplete: Bool {
        guard let map = mapState else { return false }
        let bossFloor = map.floors.last
        let bossVisited = bossFloor?.allSatisfy { $0.isVisited } ?? false
        return bossVisited
    }

    private func weightedRarityRoll() -> CardRarity {
        let roll = Double.random(in: 0...1)
        if roll < 0.60 { return .common }
        if roll < 0.90 { return .uncommon }
        return .rare
    }
}
