//
//  UnlockStore.swift
//  Fighter
//

import Foundation

final class UnlockStore {
    static let shared = UnlockStore()

    private let key = "fighter_unlocks"
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    private(set) var state: UnlockState = UnlockState()

    private init() {
        load()
    }

    // MARK: - Persistence

    func save() {
        if let data = try? encoder.encode(state) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? decoder.decode(UnlockState.self, from: data) else {
            return
        }
        state = decoded
    }

    // MARK: - Queries

    func isUnlocked(_ content: UnlockableContent) -> Bool {
        state.unlocked.contains(content)
    }

    // MARK: - Unlock Checking

    @discardableResult
    func checkAndUnlock(statistics: GameStatistics) -> [UnlockableContent] {
        let newlyUnlocked = state.checkUnlocks(statistics: statistics)
        if !newlyUnlocked.isEmpty {
            save()
        }
        return newlyUnlocked
    }

    // MARK: - Reset

    func reset() {
        state = UnlockState()
        save()
    }
}
