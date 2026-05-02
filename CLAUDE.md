# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Fighter is a Slay the Spire-style roguelike deck-building card game for iOS, built with SwiftUI (iOS 17+). Three character classes (Warrior, Assassin, Mage) progress through 3 acts, each with procedurally generated maps containing battles, elites, bosses, events, shops, and rest sites.

## Build & Run

```bash
# Build (from project root)
xcodebuild -project Fighter.xcodeproj -scheme Fighter -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Alternative simulator
xcodebuild -project Fighter.xcodeproj -scheme Fighter -destination 'platform=iOS Simulator,name=iPhone 16' build
```

No external dependencies (no SPM packages, CocoaPods, or Carthage). Pure Xcode project.

## Architecture

### State Machine Navigation

All screen routing is driven by `GameStore.gameState: GameState` (an enum: `.menu`, `.characterSelect`, `.map`, `.combat`, `.reward`, `.shop`, `.restSite`, `.event`, `.gameOver`). `RootView` switches on this enum to display exactly one feature view at a time. There is no NavigationStack — transitions are forward-only mutations of `gameState`.

### State Management

Uses Swift's `@Observable` macro (Observation framework, not Combine/ObservableObject). State flows through a single `GameStore` injected via `.environment(store)`:

- **GameStore** (`Core/GameState/GameStore.swift`) — Central state machine. Owns `player`, `combatState`, `mapState`, and handles all game flow transitions.
- **PlayerState** (`Core/GameState/PlayerState.swift`) — Run-level stats (HP, gold, deck, relics, potions) + combat-level stats (energy, block, buffs).
- **CombatState** (`Core/GameState/CombatState.swift`) — Draw/hand/discard/exhaust piles, enemy instances, combat phase.
- **MapState** (`Core/GameState/MapState.swift`) — 16-floor procedural map per act.

### Effect Composition System

The `Effect` enum (`Core/Models/Effect.swift`) is the universal mechanic vocabulary. Cards, relics, and potions all compose from the same Effect set. `CardEvaluator` (`Core/Services/CardEvaluator.swift`) is the single resolver that handles all effect resolution.

Adding a new card = arranging existing Effects. Adding a new mechanic = new Effect case + handler in CardEvaluator.

### Game Loop

```
MainMenu -> CharacterSelect -> Map -> (Combat | Event | Shop | RestSite) -> Map -> ... -> GameOver
```

`CombatEngine` (`Core/Services/CombatEngine.swift`) manages the turn loop: begin turn -> player plays cards -> end turn -> enemy actions -> check win/loss -> repeat.

### Data Layer

All game data is hardcoded as static arrays in enum-based database types under `Core/Database/`:
- **CardDatabase** — 47 cards (15 Warrior, 13 Assassin, 14 Mage, 10 Neutral)
- **EnemyDatabase** — 14 enemies across 3 acts
- **RelicDatabase** — 13 relics (3 starter, 3 common, 4 uncommon, 5 rare)
- **PotionDatabase** — 7 potions
- **EventDatabase** — 36 events

### Persistence

`SaveManager` (`Core/Services/SaveManager.swift`) uses `UserDefaults` + `JSONEncoder/Decoder`. Saves between encounters only (when `gameState == .map`). `MapState` uses a nested `CodableDTO` pattern since `@Observable` classes aren't directly Codable.

## Key Conventions

- All UI is portrait layout
- Localization is prepared via `String(localized:)` but `.xcstrings` files don't exist yet
- Relic effects: most go through `CardEvaluator.resolve()`, but several are hard-coded in `CombatEngine.triggerRelics()` with combat-counter logic (shuriken, pen_nib, orichalcum, etc.)
- `GameSettings.language` supports `.system`, `.en`, `.zhHans`

## Directory Layout

```
Fighter/
  App/              — Entry point (FighterApp.swift) + RootView
  Core/
    Models/         — Card, Enemy, Relic, Potion, Event, Effect, BuffType, CharacterClass
    GameState/      — GameStore, PlayerState, CombatState, MapState
    Database/       — Static data catalogs (CardDatabase, EnemyDatabase, etc.)
    Services/       — CombatEngine, CardEvaluator, MapGenerator, SaveManager
  Features/         — One folder per screen (Combat, Map, Shop, Event, etc.)
  Shared/           — Theme.swift (colors, fonts, spacing constants)
```
