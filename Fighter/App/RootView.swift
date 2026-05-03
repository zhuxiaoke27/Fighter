//
//  RootView.swift
//  Fighter
//

import SwiftUI

struct RootView: View {
    @State private var store = GameStore()

    private var currentLocale: Locale {
        switch store.settings.language {
        case .system: return Locale.current
        case .en: return Locale(identifier: "en")
        case .zhHans: return Locale(identifier: "zh-Hans")
        }
    }

    var body: some View {
        Group {
            switch store.gameState {
            case .menu:
                MainMenuView()
                    .transition(.opacity)
            case .characterSelect:
                CharacterSelectView()
                    .transition(.opacity)
            case .neow:
                NeowBonusView()
                    .transition(.opacity)
            case .map:
                MapView()
                    .transition(.opacity)
            case .combat:
                CombatView()
                    .transition(.opacity)
            case .reward:
                RewardView()
                    .transition(.opacity)
            case .shop:
                ShopView()
                    .transition(.opacity)
            case .restSite:
                RestSiteView()
                    .transition(.opacity)
            case .event:
                EventView()
                    .transition(.opacity)
            case .gameOver(let victory):
                GameOverView(victory: victory)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: store.gameState)
        .background(Theme.background)
        .environment(\.locale, currentLocale)
        .environment(store)
    }
}

