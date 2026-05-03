//
//  SaveManager.swift
//  Fighter
//

import Foundation

final class SaveManager {
    static let shared = SaveManager()

    private let saveKey = "fighter_saved_run"
    private let settingsKey = "fighter_settings"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    struct SavedRun: Codable, Sendable {
        let version: Int
        let characterClass: CharacterClass
        let maxHP: Int
        let currentHP: Int
        let gold: Int
        let deck: [Card]
        let relics: [RelicTemplate]
        let potions: [PotionTemplate?]
        let enemiesKilled: Int
        let cardsPlayed: Int
        let totalDamageDealt: Int
        let floorsVisited: Int
        let mapState: MapState.CodableDTO
        let settings: GameSettings
        let permanentStrengthBonus: Int
        let permanentDexterityBonus: Int
        let permanentBlockBonus: Int
        let activeModifier: RunModifier?
        let consecutiveNonRareRolls: Int
        let lastBattleWasEliteOrBoss: Bool
    }

    private static let currentVersion = 4

    // MARK: - Save

    func save(store: GameStore) {
        guard case .map = store.gameState,
              let mapState = store.mapState else { return }

        let run = SavedRun(
            version: Self.currentVersion,
            characterClass: store.player.characterClass,
            maxHP: store.player.maxHP,
            currentHP: store.player.currentHP,
            gold: store.player.gold,
            deck: store.player.deck,
            relics: store.player.relics,
            potions: store.player.potions,
            enemiesKilled: store.player.enemiesKilled,
            cardsPlayed: store.player.cardsPlayed,
            totalDamageDealt: store.player.totalDamageDealt,
            floorsVisited: store.player.floorsVisited,
            mapState: mapState.dto,
            settings: store.settings,
            permanentStrengthBonus: store.player.permanentStrengthBonus,
            permanentDexterityBonus: store.player.permanentDexterityBonus,
            permanentBlockBonus: store.player.permanentBlockBonus,
            activeModifier: store.activeModifier,
            consecutiveNonRareRolls: store.consecutiveNonRareRolls,
            lastBattleWasEliteOrBoss: store.lastBattleWasEliteOrBoss
        )

        if let data = try? encoder.encode(run) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    // MARK: - Load

    var hasSavedRun: Bool {
        UserDefaults.standard.data(forKey: saveKey) != nil
    }

    func load(into store: GameStore) -> Bool {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else {
            return false
        }

        // Try decoding with current version
        guard let run = try? decoder.decode(SavedRun.self, from: data) else {
            // Old save without version field — delete incompatible save
            deleteSave()
            return false
        }

        // Future: add migration logic here if version < currentVersion

        let player = PlayerState(characterClass: run.characterClass)
        player.maxHP = run.maxHP
        player.currentHP = run.currentHP
        player.gold = run.gold
        player.deck = run.deck
        player.relics = run.relics
        player.potions = run.potions
        player.enemiesKilled = run.enemiesKilled
        player.cardsPlayed = run.cardsPlayed
        player.totalDamageDealt = run.totalDamageDealt
        player.floorsVisited = run.floorsVisited
        player.permanentStrengthBonus = run.permanentStrengthBonus
        player.permanentDexterityBonus = run.permanentDexterityBonus
        player.permanentBlockBonus = run.permanentBlockBonus

        store.player = player
        store.mapState = MapState(from: run.mapState)
        store.settings = run.settings
        store.activeModifier = run.activeModifier
        store.consecutiveNonRareRolls = run.consecutiveNonRareRolls
        store.lastBattleWasEliteOrBoss = run.lastBattleWasEliteOrBoss
        store.combatState = nil
        store.gameState = .map

        return true
    }

    // MARK: - Delete

    func deleteSave() {
        UserDefaults.standard.removeObject(forKey: saveKey)
    }

    // MARK: - Settings

    func saveSettings(_ settings: GameSettings) {
        if let data = try? encoder.encode(settings) {
            UserDefaults.standard.set(data, forKey: settingsKey)
        }
    }

    func loadSettings() -> GameSettings? {
        guard let data = UserDefaults.standard.data(forKey: settingsKey),
              let settings = try? decoder.decode(GameSettings.self, from: data) else {
            return nil
        }
        return settings
    }
}
