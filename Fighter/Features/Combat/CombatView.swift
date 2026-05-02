//
//  CombatView.swift
//  Fighter
//

import SwiftUI

struct CombatView: View {
    @Environment(GameStore.self) private var store

    // Card detail overlay
    @State private var detailCard: Card? = nil

    // Pile browsing
    @State private var browsePile: PileType? = nil

    // Drag state
    @State private var dragCard: Card? = nil
    @State private var dragOffset: CGSize = .zero
    @State private var dragStartPosition: CGPoint = .zero
    @State private var isDragging: Bool = false

    // Animation state
    @State private var floatingTexts: [FloatingText] = []
    @State private var isEnemyTurnTransition = false
    @State private var previousTurnFlag = false

    // Drop zone tracking
    @State private var enemyZoneFrame: CGRect = .zero
    @State private var playerZoneFrame: CGRect = .zero

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if let combat = store.combatState {
                    // Player status zone — drop target for self-target cards
                    PlayerStatusView(
                        currentHP: store.player.currentHP,
                        maxHP: store.player.maxHP,
                        block: store.player.combatBlock,
                        energy: store.player.combatEnergy,
                        gold: store.player.gold,
                        buffs: store.player.buffs
                    )
                    .padding(.top, 8)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear { playerZoneFrame = geo.frame(in: .global) }
                                .onChange(of: geo.size) { _, _ in playerZoneFrame = geo.frame(in: .global) }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(
                                isDragging && dragCard?.target == .selfTarget ? Theme.energyColor.opacity(0.5) : Color.clear,
                                lineWidth: 2
                            )
                    )

                    Spacer()

                    if combat.isCombatOver {
                        combatEndView
                    } else {
                        // Enemy zone — drop target for attack cards
                        VStack {
                            EnemyRowView(
                                enemies: combat.enemies,
                                isTargetSelection: combat.combatPhase == .targetSelection || (isDragging && dragCard?.target == .enemy),
                                selectedTargetID: combat.selectedTargetID
                            ) { enemy in
                                handleEnemyTap(enemy)
                            }
                        }
                        .padding(.vertical, 8)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear { enemyZoneFrame = geo.frame(in: .global) }
                                    .onChange(of: geo.size) { _, _ in enemyZoneFrame = geo.frame(in: .global) }
                            }
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(
                                    isDragging && (dragCard?.target == .enemy || dragCard?.target == .allEnemies) ? Color(red: 0.90, green: 0.30, blue: 0.25).opacity(0.5) : Color.clear,
                                    lineWidth: 2
                                )
                        )

                        Spacer()

                        // Pile indicators (tappable)
                        pileIndicators(combat: combat)

                        Spacer()

                        // Card hand
                        CardHandView(
                            hand: combat.hand,
                            selectedCardID: combat.selectedCardID,
                            currentEnergy: store.player.combatEnergy,
                            onCardTap: { card in handleCardTap(card) },
                            onCardLongPress: { card in detailCard = card }
                        )
                        .opacity(isDragging ? 0.3 : 1.0)

                        // End turn button
                        if combat.isPlayerTurn && !isDragging {
                            endTurnButton
                        }
                    }
                }
            }
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.10, green: 0.08, blue: 0.18),
                        Color(red: 0.06, green: 0.05, blue: 0.10)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea(.container, edges: .bottom)

            // Floating card during drag
            if isDragging, let card = dragCard {
                floatingDragCard(card)
            }

            // Card detail overlay
            if let card = detailCard {
                CardDetailView(card: card) {
                    detailCard = nil
                }
            }

            // Floating damage/heal numbers
            ForEach(floatingTexts) { ft in
                Text(ft.text)
                    .font(.system(size: ft.isCrit ? 22 : 16, weight: .heavy, design: .rounded))
                    .foregroundStyle(ft.color)
                    .shadow(color: .black.opacity(0.6), radius: 2)
                    .position(ft.position)
                    .opacity(ft.opacity)
                    .offset(y: ft.offset)
            }

            // Enemy turn transition overlay
            if isEnemyTurnTransition {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)
                Text(String(localized: "label_enemy_turn"))
                    .font(.system(size: 28, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.90, green: 0.30, blue: 0.25))
                    .shadow(color: .black.opacity(0.5), radius: 4)
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }
        }
        .sheet(item: $browsePile) { pile in
            if let combat = store.combatState {
                PileBrowseView(
                    pileType: pile,
                    cards: {
                        switch pile {
                        case .draw:    return combat.drawPile
                        case .discard: return combat.discardPile
                        case .exhaust: return combat.exhaustPile
                        }
                    }()
                )
            }
        }
        .onChange(of: store.combatState?.isPlayerTurn ?? true) { _, isPlayerTurn in
            if !isPlayerTurn && !previousTurnFlag {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isEnemyTurnTransition = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.3)) {
                        isEnemyTurnTransition = false
                    }
                }
            }
            previousTurnFlag = isPlayerTurn
        }
        .onChange(of: store.combatState?.enemies.map(\.currentHP) ?? []) { oldHPs, newHPs in
            guard let combat = store.combatState else { return }
            for i in 0..<min(oldHPs.count, newHPs.count) {
                let oldHP = oldHPs[i]
                let newHP = newHPs[i]
                if newHP < oldHP {
                    let damage = oldHP - newHP
                    let isCrit = damage >= 20
                    spawnFloatingText(
                        "\(damage)",
                        at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.32),
                        color: Color(red: 0.95, green: 0.30, blue: 0.20),
                        isCrit: isCrit
                    )
                }
            }
        }
        .onChange(of: store.player.currentHP) { oldHP, newHP in
            if newHP < oldHP {
                let damage = oldHP - newHP
                spawnFloatingText(
                    "\(damage)",
                    at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.08),
                    color: Color(red: 0.95, green: 0.30, blue: 0.20),
                    isCrit: damage >= 15
                )
            } else if newHP > oldHP {
                let heal = newHP - oldHP
                spawnFloatingText(
                    "+\(heal)",
                    at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.08),
                    color: Color(red: 0.30, green: 0.85, blue: 0.40),
                    isCrit: false
                )
            }
        }
        .onChange(of: store.player.combatBlock) { _, newBlock in
            if newBlock > 0 {
                spawnFloatingText(
                    "+\(newBlock)🛡",
                    at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.12),
                    color: Theme.blockColor,
                    isCrit: false
                )
            }
        }
        .gesture(dragGesture)
    }

    // MARK: - Floating Drag Card

    private func floatingDragCard(_ card: Card) -> some View {
        let canPlay = card.cost <= store.player.combatEnergy
        let finalPoint = dragStartPosition + dragOffset
        let inEnemyZone = enemyZoneFrame.contains(finalPoint)
        let inPlayerZone = playerZoneFrame.contains(finalPoint)
        let validTarget = (inEnemyZone && (card.target == .enemy || card.target == .allEnemies)) ||
                          (inPlayerZone && (card.target == .selfTarget || card.target == .none))

        return VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.cardColor(for: card.type).opacity(0.4),
                                Color(red: 0.10, green: 0.09, blue: 0.16)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: Theme.cardWidth, height: Theme.cardHeight)

                VStack(spacing: 4) {
                    Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                        .font(Theme.cardTitleFont)
                        .foregroundStyle(Theme.textPrimary)
                        .lineLimit(1)
                    Image(systemName: typeIcon(for: card.type))
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.6))
                }
            }
            .scaleEffect(validTarget ? 1.1 : 1.0)
            .opacity(canPlay ? 1.0 : 0.5)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(
                        !canPlay ? Color.red.opacity(0.5) :
                        validTarget ? Theme.energyColor :
                        Theme.cardColor(for: card.type).opacity(0.5),
                        lineWidth: 2
                    )
            )
            .shadow(color: validTarget ? Theme.energyGlow : .black.opacity(0.5), radius: validTarget ? 16 : 8, y: 4)
        }
        .offset(dragOffset)
        .position(dragStartPosition)
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged { value in
                guard let combat = store.combatState, combat.isPlayerTurn else { return }

                if dragCard == nil {
                    if let card = findCardAt(location: value.startLocation, in: combat.hand) {
                        if card.cost <= store.player.combatEnergy {
                            dragCard = card
                            dragStartPosition = value.startLocation
                            isDragging = true
                        }
                    }
                }

                if dragCard != nil {
                    dragOffset = value.translation
                }
            }
            .onEnded { _ in
                guard let card = dragCard else {
                    resetDrag()
                    return
                }

                let finalPoint = dragStartPosition + dragOffset
                let inEnemyZone = enemyZoneFrame.contains(finalPoint)
                let inPlayerZone = playerZoneFrame.contains(finalPoint)

                switch card.target {
                case .enemy:
                    if inEnemyZone { handleDropOnEnemyZone(card) }
                case .allEnemies:
                    if inEnemyZone { handleDropOnAllEnemies(card) }
                case .selfTarget, .none:
                    if inPlayerZone { handleDropOnSelf(card) }
                }

                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    resetDrag()
                }
            }
    }

    // MARK: - Drop Handlers

    private func handleDropOnEnemyZone(_ card: Card) {
        guard let combat = store.combatState else { return }
        let alive = combat.aliveEnemies
        if alive.count == 1 {
            CombatEngine.playCard(cardID: card.id, targetEnemyID: alive[0].id, store: store)
            combat.selectedCardID = nil
            combat.combatPhase = .playerAction
        } else if card.target == .allEnemies {
            CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
            combat.selectedCardID = nil
            combat.combatPhase = .playerAction
        } else {
            // Multiple enemies — enter target selection (tap to target)
            combat.selectedCardID = card.id
            combat.combatPhase = .targetSelection
        }
    }

    private func handleDropOnAllEnemies(_ card: Card) {
        guard let combat = store.combatState else { return }
        CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
        combat.selectedCardID = nil
        combat.combatPhase = .playerAction
    }

    private func handleDropOnSelf(_ card: Card) {
        guard let combat = store.combatState else { return }
        CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
        combat.selectedCardID = nil
        combat.combatPhase = .playerAction
    }

    // MARK: - Card Location Helper

    private func findCardAt(location: CGPoint, in hand: [Card]) -> Card? {
        guard let combat = store.combatState else { return nil }
        // Prefer the selected card
        if let selectedID = combat.selectedCardID,
           let selected = hand.first(where: { $0.id == selectedID }) {
            return selected
        }
        // Estimate which card based on horizontal position
        let cardSpacing: CGFloat = Theme.cardWidth - 12
        let totalWidth = CGFloat(hand.count) * cardSpacing
        let startX = (UIScreen.main.bounds.width - totalWidth) / 2
        let relativeX = location.x - startX
        if relativeX < 0 || relativeX > totalWidth + Theme.cardWidth { return nil }
        let index = min(max(Int(relativeX / cardSpacing), 0), hand.count - 1)
        return hand[index]
    }

    // MARK: - Pile Indicators (tappable)

    private func pileIndicators(combat: CombatState) -> some View {
        HStack(spacing: 0) {
            Button { browsePile = .draw } label: {
                HStack(spacing: 5) {
                    Image(systemName: "rectangle.stack.fill")
                        .font(.system(size: 11))
                    Text("\(combat.drawPileCount)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.06)))
            }
            .buttonStyle(.plain)

            Spacer()

            if combat.exhaustPileCount > 0 {
                Button { browsePile = .exhaust } label: {
                    HStack(spacing: 5) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 11))
                        Text("\(combat.exhaustPileCount)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color.orange.opacity(0.7))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.orange.opacity(0.08)))
                }
                .buttonStyle(.plain)
            }

            Spacer()

            Button { browsePile = .discard } label: {
                HStack(spacing: 5) {
                    Image(systemName: "rectangle.stack.badge.plus")
                        .font(.system(size: 11))
                    Text("\(combat.discardPileCount)")
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                }
                .foregroundStyle(Theme.textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Capsule().fill(Color.white.opacity(0.06)))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.padding)
        .padding(.vertical, 4)
    }

    // MARK: - End Turn Button

    private var endTurnButton: some View {
        Button {
            CombatEngine.endPlayerTurn(store: store)
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.system(size: 16, weight: .semibold))
                Text(String(localized: "btn_end_turn"))
                    .font(Theme.buttonFont)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 36)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.28, green: 0.62, blue: 0.35),
                        Color(red: 0.18, green: 0.48, blue: 0.25)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(Capsule())
            .shadow(color: Color(red: 0.28, green: 0.62, blue: 0.35).opacity(0.4), radius: 8, y: 3)
            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
        }
        .buttonStyle(.plain)
        .padding(.bottom, 8)
    }

    // MARK: - Combat End

    private var combatEndView: some View {
        VStack(spacing: 24) {
            let victory = store.combatVictory ?? true

            Image(systemName: victory ? "trophy.fill" : "skull.fill")
                .font(.system(size: 56, weight: .medium))
                .foregroundStyle(victory ? Theme.energyColor : Color(red: 0.85, green: 0.22, blue: 0.18))
                .shadow(color: victory ? Theme.energyGlow : Color.red.opacity(0.4), radius: 12)
                .padding(.bottom, 4)

            Text(victory ? String(localized: "label_victory") : String(localized: "label_defeat"))
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(victory ? Theme.energyColor : Color(red: 0.90, green: 0.30, blue: 0.25))

            Button {
                store.confirmCombatEnd()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                    Text(String(localized: "btn_continue"))
                        .font(Theme.buttonFont)
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.30, green: 0.58, blue: 0.88),
                            Color(red: 0.20, green: 0.45, blue: 0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(Capsule())
                .shadow(color: Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.4), radius: 8, y: 3)
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Card/Enemy Tap Handlers

    private func handleCardTap(_ card: Card) {
        guard let combat = store.combatState else { return }

        if combat.selectedCardID == card.id {
            combat.selectedCardID = nil
            combat.selectedTargetID = nil
            combat.combatPhase = .playerAction
            return
        }

        combat.selectedCardID = card.id
        combat.selectedTargetID = nil

        switch card.target {
        case .enemy, .allEnemies:
            combat.combatPhase = .targetSelection
            let alive = combat.aliveEnemies
            if alive.count == 1 {
                let enemy = alive[0]
                combat.selectedTargetID = enemy.id
                if card.target == .allEnemies {
                    CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
                } else {
                    CombatEngine.playCard(cardID: card.id, targetEnemyID: enemy.id, store: store)
                }
                combat.selectedCardID = nil
                combat.combatPhase = .playerAction
            }
        case .selfTarget, .none:
            CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
            combat.selectedCardID = nil
            combat.combatPhase = .playerAction
        }
    }

    private func handleEnemyTap(_ enemy: CombatEnemy) {
        guard let combat = store.combatState,
              let cardID = combat.selectedCardID,
              combat.combatPhase == .targetSelection else { return }

        combat.selectedTargetID = enemy.id
        CombatEngine.playCard(cardID: cardID, targetEnemyID: enemy.id, store: store)
        combat.selectedCardID = nil
        combat.selectedTargetID = nil
        combat.combatPhase = .playerAction
    }

    // MARK: - Helpers

    private func resetDrag() {
        dragCard = nil
        dragOffset = .zero
        isDragging = false
    }

    private func spawnFloatingText(_ text: String, at position: CGPoint, color: Color, isCrit: Bool) {
        let id = UUID()
        let ft = FloatingText(id: id, text: text, position: position, color: color, isCrit: isCrit)
        floatingTexts.append(ft)

        withAnimation(.easeOut(duration: 0.8)) {
            if let idx = floatingTexts.firstIndex(where: { $0.id == id }) {
                floatingTexts[idx].offset = -50
                floatingTexts[idx].opacity = 0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            floatingTexts.removeAll { $0.id == id }
        }
    }

    private func typeIcon(for type: CardType) -> String {
        switch type {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }
}

// MARK: - CGPoint + CGSize

private extension CGPoint {
    static func + (lhs: CGPoint, rhs: CGSize) -> CGPoint {
        CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
    }
}

// MARK: - Floating Text Model

struct FloatingText: Identifiable {
    let id: UUID
    let text: String
    let position: CGPoint
    let color: Color
    let isCrit: Bool
    var offset: CGFloat = 0
    var opacity: Double = 1.0
}
