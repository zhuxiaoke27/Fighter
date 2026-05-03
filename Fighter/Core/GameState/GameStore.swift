//
//  GameStore.swift
//  Fighter
//

import Foundation
import SwiftUI

enum GameState: Sendable, Equatable {
    case menu
    case characterSelect
    case neow
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
    var hasSeenMapTutorial: Bool = false
    var hasSeenCombatTutorial: Bool = false
    var hasSeenShopTutorial: Bool = false
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
    var rewardBossRelics: [RelicTemplate] = []
    var combatVictory: Bool? = nil
    var lastBattleWasEliteOrBoss: Bool = false

    // Shop state
    var shopCards: [Card] = []
    var shopRelics: [RelicTemplate] = []
    var shopRelicPrices: [Int] = []
    var shopPotions: [PotionTemplate] = []
    var shopPotionPrices: [Int] = []
    var hasRemovedCardThisShopVisit: Bool = false

    // Event state
    var currentEvent: EventTemplate?

    // Run modifier (season rules)
    var activeModifier: RunModifier? = nil

    init() {
        self.player = PlayerState(characterClass: .warrior)
        if let savedSettings = SaveManager.shared.loadSettings() {
            self.settings = savedSettings
        }
    }

    // MARK: - Run Lifecycle

    func quitToMenu() {
        gameState = .menu
        combatState = nil
        mapState = nil
        currentEvent = nil
        combatVictory = nil
    }

    func startNewRun(characterClass: CharacterClass) {
        player = PlayerState(characterClass: characterClass)
        player.deck = CardDatabase.startingDeck(for: characterClass)
        player.relics = [RelicDatabase.startingRelic(for: characterClass)]
        mapState = MapGenerator.generate(act: 1)

        // Apply run modifier effects
        if let modifier = activeModifier {
            for effect in modifier.effects {
                switch effect {
                case .startWithCurse(let cardKey):
                    if let curseCard = CardDatabase.card(byKey: cardKey)?.copy() {
                        player.deck.append(curseCard)
                    }
                case .bonusGoldPerFloor(let amount):
                    player.gold += amount
                default:
                    break
                }
            }
        }

        gameState = .neow
    }

    func startCombat(enemies: [EnemyTemplate]) {
        let combat = CombatState()
        combatState = combat
        combat.enemies = enemies.map { CombatEnemy(template: $0) }
        player.resetForCombat()

        // Safety: ensure deck is not empty
        if player.deck.isEmpty {
            if let strike = CardDatabase.card(byKey: "strike_warrior")?.copy() {
                player.deck.append(strike)
            }
        }

        CombatEngine.startCombat(store: self)
        gameState = .combat
    }

    func endCombat(victory: Bool) {
        combatVictory = victory
        rewardRelic = nil
        rewardPotion = nil
        if victory {
            // Inserter relic: gain 1 max HP on combat victory
            if player.relics.contains(where: { $0.id == "inserter" }) {
                player.maxHP += 1
                player.currentHP = min(player.currentHP + 1, player.maxHP)
            }

            if lastBattleWasEliteOrBoss {
                // Elite/Boss: better gold + guaranteed uncommon/rare cards
                rewardGold = Int.random(in: 30...50) + currentFloor * 3
                let characterClass = player.characterClass
                let rarityRoll = Double.random(in: 0...1)
                let rarity: CardRarity = rarityRoll < 0.4 ? .rare : .uncommon
                let cardCount = player.relics.contains(where: { $0.id == "busted_crown" }) ? 2 : 3
                rewardCards = CardDatabase.randomCards(count: cardCount, rarity: rarity, for: characterClass)

                // Guaranteed relic + potion
                rewardRelic = RelicDatabase.randomRelic(excluding: player.relics)
                rewardPotion = PotionDatabase.randomPotion()
            } else {
                rewardGold = Int.random(in: 20...30) + currentFloor * 2
                let characterClass = player.characterClass
                let rarity = weightedRarityRoll()
                let cardCount = player.relics.contains(where: { $0.id == "busted_crown" }) ? 2 : 3
                rewardCards = CardDatabase.randomCards(count: cardCount, rarity: rarity, for: characterClass)
            }
            player.gold += rewardGold
        }

        // Boss relic choice after defeating a boss
        if victory, let combat = combatState, combat.enemies.contains(where: { $0.isBoss }) {
            rewardBossRelics = RelicDatabase.randomBossRelics(excluding: player.relics)
        } else {
            rewardBossRelics = []
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

    func takeBossRelic(at index: Int) {
        guard index < rewardBossRelics.count else { return }
        let relic = rewardBossRelics[index]
        player.relics.append(relic)
        rewardBossRelics = []

        // Boss relic acquisition effects
        switch relic.id {
        case "empty_cage":
            // Remove 2 random non-starter cards from deck
            let removableIndices = player.deck.indices.filter { player.deck[$0].rarity != .starter }
            let toRemove = Array(removableIndices.shuffled().prefix(2)).sorted(by: >)
            for idx in toRemove {
                player.deck.remove(at: idx)
            }
        case "astrolabe":
            // Transform 3 random non-starter cards to same-rarity random cards
            let transformableIndices = player.deck.indices.filter { player.deck[$0].rarity != .starter }
            let toTransform = Array(transformableIndices.shuffled().prefix(3))
            for idx in toTransform {
                let oldCard = player.deck[idx]
                let newCard = CardDatabase.randomCards(count: 1, rarity: oldCard.rarity, for: player.characterClass).first ?? oldCard
                player.deck[idx] = newCard
            }
        case "cursed_key":
            // Add a random curse card to deck
            if let curse = CardDatabase.randomCurse() {
                player.deck.append(curse)
                CombatEngine.triggerOnCardAdded(store: self)
            }
        default:
            break
        }
    }

    // MARK: - Encounter Routing

    func handleNodeEncounter(_ node: MapNode) {
        player.floorsVisited += 1
        switch node.type {
        case .battle:
            lastBattleWasEliteOrBoss = false
            let enemies = EnemyDatabase.randomBattle(act: currentAct)
            startCombat(enemies: enemies)
        case .hardBattle:
            lastBattleWasEliteOrBoss = true
            let enemies = EnemyDatabase.eliteBattle(act: currentAct)
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
            CombatEngine.triggerOnCardAdded(store: self)
        }
        if tookRelic, let relic = rewardRelic {
            player.relics.append(relic)
        }
        if tookPotion, let potion = rewardPotion {
            receivePotion(potion)
        }
        combatState = nil
        rewardBossRelics = []
        rewardRelic = nil
        rewardPotion = nil
        rewardCards = []

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
        hasRemovedCardThisShopVisit = false
        let characterClass = player.characterClass
        let pool = CardDatabase.cards(for: characterClass).filter { $0.rarity != .starter }
        shopCards = Array(pool.shuffled().prefix(5))

        // Relics: 1-2 random non-starter relics (no duplicates)
        let relicCount = Int.random(in: 1...2)
        var selectedRelics: [RelicTemplate] = []
        for _ in 0..<relicCount {
            let relic = RelicDatabase.randomRelic(excluding: player.relics + selectedRelics)
            selectedRelics.append(relic)
        }
        shopRelics = selectedRelics
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

    // Rarity gauge: consecutive misses increase rare chance
    var consecutiveNonRareRolls: Int = 0

    private func weightedRarityRoll() -> CardRarity {
        let roll = Double.random(in: 0...1)
        let rareThreshold = min(0.10 + Double(consecutiveNonRareRolls) * 0.05, 0.33)
        if roll < 0.60 - rareThreshold * 0.5 {
            consecutiveNonRareRolls += 1
            return .common
        }
        if roll < 0.90 - rareThreshold {
            consecutiveNonRareRolls += 1
            return .uncommon
        }
        consecutiveNonRareRolls = 0
        return .rare
    }

    // MARK: - Neow Bonus

    func completeNeow() {
        gameState = .map
        SaveManager.shared.save(store: self)
    }
}
