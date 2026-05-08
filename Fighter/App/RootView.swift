//
//  RootView.swift
//  Fighter
//

import SwiftUI

struct RootView: View {
    @State private var store = GameStore()
    @State private var previousState: GameState? = nil

    private var currentLocale: Locale {
        switch store.settings.language {
        case .system: return Locale.current
        case .en: return Locale(identifier: "en")
        case .zhHans: return Locale(identifier: "zh-Hans")
        }
    }

    private var screenTransition: AnyTransition {
        guard let prev = previousState else { return .opacity }
        let current = store.gameState

        // Returning to map from any encounter
        if current == .map && prev != .map {
            return .move(edge: .top).combined(with: .opacity)
        }
        // Returning to menu
        if current == .menu { return .opacity }

        switch (prev, current) {
        // Menu -> CharacterSelect: slide up
        case (.menu, .characterSelect):
            return .move(edge: .bottom).combined(with: .opacity)
        // CharacterSelect -> Neow/Map: zoom in
        case (.characterSelect, .neow), (.characterSelect, .map):
            return .scale(scale: 0.85).combined(with: .opacity)
        // Map -> Combat: dramatic zoom
        case (.map, .combat):
            return .asymmetric(
                insertion: .scale(scale: 1.1).combined(with: .opacity),
                removal: .scale(scale: 0.9).combined(with: .opacity)
            )
        // Map -> Event: slide from right
        case (.map, .event):
            return .move(edge: .trailing).combined(with: .opacity)
        // Map -> Shop: slide up
        case (.map, .shop):
            return .move(edge: .bottom).combined(with: .opacity)
        // Map -> RestSite: gentle fade
        case (.map, .restSite):
            return .opacity
        // Combat -> Reward: slide up celebration
        case (.combat, .reward):
            return .asymmetric(
                insertion: .move(edge: .bottom).combined(with: .scale(scale: 0.95)),
                removal: .scale(scale: 0.95).combined(with: .opacity)
            )
        // Combat -> GameOver: slow fade
        case (.combat, .gameOver):
            return .opacity
        // Neow -> Map: zoom in
        case (.neow, .map):
            return .scale(scale: 0.85).combined(with: .opacity)
        default:
            return .opacity
        }
    }

    private var transitionAnimation: Animation {
        let current = store.gameState
        if case .gameOver = current { return .easeInOut(duration: 0.6) }
        if current == .menu { return .easeInOut(duration: 0.5) }
        return .easeInOut(duration: 0.35)
    }

    var body: some View {
        Group {
            switch store.gameState {
            case .menu:
                MainMenuView()
            case .characterSelect:
                CharacterSelectView()
            case .neow:
                NeowBonusView()
            case .map:
                MapView()
            case .combat:
                CombatView()
            case .reward:
                RewardView()
            case .shop:
                ShopView()
            case .restSite:
                RestSiteView()
            case .event:
                EventView()
            case .gameOver(let victory):
                GameOverView(victory: victory)
            }
        }
        .id(store.gameState)
        .transition(screenTransition)
        .animation(transitionAnimation, value: store.gameState)
        .background(Theme.background)
        .environment(\.locale, currentLocale)
        .environment(store)
        .onChange(of: store.gameState) { _, newState in
            if previousState != newState {
                previousState = store.gameState
            }
        }
    }
}

