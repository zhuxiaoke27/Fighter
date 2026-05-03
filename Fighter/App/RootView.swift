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
        .background(Theme.background)
        .environment(\.locale, currentLocale)
        .environment(store)
    }
}

