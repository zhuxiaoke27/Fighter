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
    }

    // MARK: - Save

    func save(store: GameStore) {
        guard case .map = store.gameState,
              let mapState = store.mapState else { return }

        let run = SavedRun(
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
            settings: store.settings
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
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let run = try? decoder.decode(SavedRun.self, from: data) else {
            return false
        }

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

        store.player = player
        store.mapState = MapState(from: run.mapState)
        store.settings = run.settings
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
