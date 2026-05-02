//
//  RootView.swift
//  Fighter
//

import SwiftUI

struct RootView: View {
    @State private var store = GameStore()

    var body: some View {
        Group {
            switch store.gameState {
            case .menu:
                MainMenuView()
            case .characterSelect:
                CharacterSelectView()
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
        .environment(store)
    }
}

