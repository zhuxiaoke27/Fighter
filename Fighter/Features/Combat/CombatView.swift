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

    // Card fly animation
    @State private var flyCard: Card? = nil
    @State private var flyFrom: CGPoint = .zero
    @State private var flyTo: CGPoint = .zero
    @State private var flyProgress: CGFloat = 0
    @State private var flyCompletion: (() -> Void)? = nil

    // Combat log
    @State private var combatLog: [CombatLogEntry] = []
    @State private var showCombatLog = false

    // Drop zone tracking
    @State private var enemyZoneFrame: CGRect = .zero
    @State private var playerZoneFrame: CGRect = .zero
    @State private var enemyFrames: [UUID: CGRect] = [:]
    @State private var dragTargetEnemyID: UUID? = nil

    // Potion usage
    @State private var showPotionMenu: Bool = false

    // Tutorial
    @State private var showTutorial: Bool = false
    @State private var showRelics: Bool = false
    @State private var potionTargetingIndex: Int? = nil
    @State private var confirmPotionIndex: Int? = nil
    @State private var showForfeitConfirm: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                if let combat = store.combatState {
                    // Compact top bar — energy + gold + floor info
                    CombatTopBar(
                        energy: store.player.combatEnergy,
                        gold: store.player.gold,
                        floor: store.currentFloor,
                        act: store.currentAct
                    )
                    .padding(.top, 8)

                    Spacer()

                    if combat.isCombatOver {
                        combatEndView
                    } else {
                        // Enemy zone — drop target for attack cards
                        VStack {
                            EnemyRowView(
                                enemies: combat.enemies,
                                isTargetSelection: combat.combatPhase == .targetSelection || (isDragging && dragCard?.target == .enemy),
                                selectedTargetID: dragTargetEnemyID ?? combat.selectedTargetID
                            ) { enemy in
                                handleEnemyTap(enemy)
                            } onEnemyFrameUpdate: { enemyID, frame in
                                enemyFrames[enemyID] = frame
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

                        // Player character area — facing enemies, drop target for self-target cards
                        CombatPlayerAreaView(
                            characterClass: store.player.characterClass,
                            currentHP: store.player.currentHP,
                            maxHP: store.player.maxHP,
                            block: store.player.combatBlock,
                            buffs: store.player.buffs
                        )
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

                        // Pile indicators (tappable)
                        pileIndicators(combat: combat)

                        // Potion bar
                        potionBar(combat: combat)

                        Spacer()

                        // Card hand
                        CardHandView(
                            hand: combat.hand,
                            selectedCardID: combat.selectedCardID,
                            currentEnergy: store.player.combatEnergy,
                            onCardTap: { card in handleCardTap(card) },
                            onCardLongPress: { card in detailCard = card }
                        )
                        .zIndex(1)
                        .opacity(isDragging ? 0.3 : 1.0)

                        // End turn button
                        if combat.isPlayerTurn && !isDragging {
                            endTurnButton
                        }
                    }
                }
            }
            .background(
                ZStack {
                    Theme.combatBackground(for: store.currentAct)
                    ParticleField(colors: Theme.particleColors(for: store.currentAct), particleCount: 15, speedMultiplier: 0.8)
                }
            )
            .ignoresSafeArea(.container, edges: .bottom)

            // Floating card during drag
            if isDragging, let card = dragCard {
                floatingDragCard(card)
            }

            // Arrow pointer from card to target enemy during drag
            if isDragging, let targetID = dragTargetEnemyID, let targetFrame = enemyFrames[targetID] {
                dragArrowOverlay(cardPosition: dragStartPosition + dragOffset, targetCenter: CGPoint(x: targetFrame.midX, y: targetFrame.midY))
            }

            // Combat log toggle button
            if let combat = store.combatState, !combat.isCombatOver {
                VStack {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Button {
                                withAnimation(.spring(response: 0.3)) {
                                    showCombatLog.toggle()
                                }
                            } label: {
                                Image(systemName: "list.bullet.clipboard")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Theme.textSecondary)
                                    .padding(8)
                                    .background(Circle().fill(Color.white.opacity(0.08)))
                            }
                            .buttonStyle(.plain)

                            if !store.player.relics.isEmpty {
                                Button {
                                    showRelics = true
                                } label: {
                                    Image(systemName: "gem")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundStyle(Color(red: 0.70, green: 0.50, blue: 0.90))
                                        .padding(8)
                                        .background(Circle().fill(Color(red: 0.70, green: 0.50, blue: 0.90).opacity(0.12)))
                                }
                                .buttonStyle(.plain)
                            }

                            Button {
                                showForfeitConfirm = true
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(Color(red: 0.85, green: 0.30, blue: 0.25))
                                    .padding(8)
                                    .background(Circle().fill(Color(red: 0.85, green: 0.30, blue: 0.25).opacity(0.12)))
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.top, 50)
                        .padding(.trailing, 12)
                    }
                    Spacer()
                }
            }

            // Combat log panel
            if showCombatLog {
                combatLogPanel
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

            // Flying card animation overlay
            if let card = flyCard {
                flyingCardView(card)
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
        .sheet(isPresented: $showRelics) {
            RelicListView(relics: store.player.relics)
        }
        .alert(String(localized: "label_forfeit_title"), isPresented: $showForfeitConfirm) {
            Button(String(localized: "btn_forfeit_confirm"), role: .destructive) {
                SaveManager.shared.deleteSave()
                store.gameState = .menu
            }
            Button(String(localized: "btn_cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "label_forfeit_message"))
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
                    HapticManager.impact(isCrit ? .heavy : .medium)
                    spawnFloatingText(
                        "\(damage)",
                        at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.28),
                        color: Color(red: 0.95, green: 0.30, blue: 0.20),
                        isCrit: isCrit
                    )
                    let enemyName = String(localized: LocalizedStringResource(stringLiteral: combat.enemies[i].templateID))
                    addLogEntry(icon: "sword", text: String(localized: "log_damage_enemy \(damage) \(enemyName)"), color: Color(red: 0.95, green: 0.30, blue: 0.20))
                }
            }
        }
        .onChange(of: store.player.currentHP) { oldHP, newHP in
            if newHP < oldHP {
                let damage = oldHP - newHP
                HapticManager.impact(damage >= 15 ? .heavy : .light)
                spawnFloatingText(
                    "\(damage)",
                    at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55),
                    color: Color(red: 0.95, green: 0.30, blue: 0.20),
                    isCrit: damage >= 15
                )
            } else if newHP > oldHP {
                let heal = newHP - oldHP
                spawnFloatingText(
                    "+\(heal)",
                    at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.55),
                    color: Color(red: 0.30, green: 0.85, blue: 0.40),
                    isCrit: false
                )
            }
        }
        .onChange(of: store.player.combatBlock) { _, newBlock in
            if newBlock > 0 {
                spawnFloatingText(
                    "+\(newBlock)🛡",
                    at: CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.52),
                    color: Theme.blockColor,
                    isCrit: false
                )
                addLogEntry(icon: "shield", text: String(localized: "log_gain_block \(newBlock)"), color: Theme.blockColor)
            }
        }
        .gesture(dragGesture)
        .onAppear {
            if !store.settings.hasSeenCombatTutorial {
                showTutorial = true
            }
        }
        .overlay {
            if showTutorial {
                TutorialOverlay(text: String(localized: "tutorial_combat")) {
                    showTutorial = false
                    store.settings.hasSeenCombatTutorial = true
                    SaveManager.shared.saveSettings(store.settings)
                }
            }
        }
    }

    // MARK: - Flying Card Animation

    private func flyingCardView(_ card: Card) -> some View {
        let t = flyProgress
        // Ease-out curve
        let eased = 1 - (1 - t) * (1 - t)
        let pos = CGPoint(
            x: flyFrom.x + (flyTo.x - flyFrom.x) * eased,
            y: flyFrom.y + (flyTo.y - flyFrom.y) * eased
        )
        let scale = 1.0 - 0.3 * eased
        let rotation = Double(eased) * 15.0
        let opacity = 1.0 - 0.5 * eased

        return VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.cardColor(for: card.type).opacity(0.5),
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
                    Image(systemName: card.type.icon)
                        .font(.system(size: 20))
                        .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.6))
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .stroke(Theme.energyColor.opacity(0.6), lineWidth: 2)
            )
            .shadow(color: Theme.energyGlow, radius: 12, y: 4)
        }
        .scaleEffect(scale)
        .rotationEffect(.degrees(rotation))
        .opacity(opacity)
        .position(pos)
        .allowsHitTesting(false)
    }

    private func startFlyAnimation(card: Card, from start: CGPoint, to end: CGPoint, completion: @escaping () -> Void) {
        flyCard = card
        flyFrom = start
        flyTo = end
        flyProgress = 0
        flyCompletion = completion

        withAnimation(.easeOut(duration: 0.25)) {
            flyProgress = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { [flyCompletion] in
            self.flyCard = nil
            self.flyProgress = 0
            flyCompletion?()
            self.flyCompletion = nil
        }
    }

    // MARK: - Floating Drag Card

    private func floatingDragCard(_ card: Card) -> some View {
        let canPlay = card.cost >= 0 && card.cost <= store.player.combatEnergy
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
                    Image(systemName: card.type.icon)
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

    // MARK: - Drag Arrow Overlay

    private func dragArrowOverlay(cardPosition: CGPoint, targetCenter: CGPoint) -> some View {
        Canvas { context, _ in
            let arrowColor = Color(red: 0.30, green: 0.72, blue: 0.90)
            let dx = targetCenter.x - cardPosition.x
            let dy = targetCenter.y - cardPosition.y
            let length = sqrt(dx * dx + dy * dy)
            guard length > 0 else { return }
            let ux = dx / length
            let uy = dy / length

            // Draw dashed line from card to near target
            var line = Path()
            line.move(to: cardPosition)
            line.addLine(to: targetCenter)
            context.stroke(line, with: .color(arrowColor.opacity(0.6)), style: StrokeStyle(lineWidth: 2.5, dash: [8, 4]))

            // Draw arrowhead at target
            let arrowSize: CGFloat = 10
            let tip = targetCenter
            let base1 = CGPoint(x: tip.x - ux * arrowSize + uy * arrowSize * 0.5,
                                y: tip.y - uy * arrowSize - ux * arrowSize * 0.5)
            let base2 = CGPoint(x: tip.x - ux * arrowSize - uy * arrowSize * 0.5,
                                y: tip.y - uy * arrowSize + ux * arrowSize * 0.5)
            var arrow = Path()
            arrow.move(to: tip)
            arrow.addLine(to: base1)
            arrow.addLine(to: base2)
            arrow.closeSubpath()
            context.fill(arrow, with: .color(arrowColor.opacity(0.9)))

            // Glow around arrow
            context.stroke(line, with: .color(arrowColor.opacity(0.15)), style: StrokeStyle(lineWidth: 8))
        }
        .allowsHitTesting(false)
    }

    // MARK: - Drag Gesture

    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onChanged { value in
                guard let combat = store.combatState, combat.isPlayerTurn else { return }

                if dragCard == nil {
                    if let card = findCardAt(location: value.startLocation, in: combat.hand) {
                        if card.cost >= 0 && card.cost <= store.player.combatEnergy {
                            dragCard = card
                            dragStartPosition = value.startLocation
                            isDragging = true
                        }
                    }
                }

                if dragCard != nil {
                    dragOffset = value.translation

                    // Track nearest enemy for targeting
                    if dragCard?.target == .enemy {
                        let fingerPoint = dragStartPosition + dragOffset
                        dragTargetEnemyID = nearestAliveEnemy(to: fingerPoint)
                    }
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
                    if inEnemyZone, let targetID = dragTargetEnemyID {
                        let targetFrame = enemyFrames[targetID]
                        let endPt = targetFrame.map { CGPoint(x: $0.midX, y: $0.midY) } ?? finalPoint
                        startFlyAnimation(card: card, from: finalPoint, to: endPt) {
                            CombatEngine.playCard(cardID: card.id, targetEnemyID: targetID, store: store)
                            if let combat = store.combatState {
                                combat.selectedCardID = nil
                                combat.combatPhase = .playerAction
                            }
                        }
                    } else if inEnemyZone {
                        handleDropOnEnemyZone(card)
                    }
                case .allEnemies:
                    if inEnemyZone {
                        let endPt = CGPoint(x: UIScreen.main.bounds.midX, y: enemyZoneFrame.midY)
                        startFlyAnimation(card: card, from: finalPoint, to: endPt) {
                            handleDropOnAllEnemies(card)
                        }
                    }
                case .selfTarget, .none:
                    if inPlayerZone {
                        let endPt = CGPoint(x: UIScreen.main.bounds.midX, y: playerZoneFrame.midY)
                        startFlyAnimation(card: card, from: finalPoint, to: endPt) {
                            handleDropOnSelf(card)
                        }
                    }
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
        guard !hand.isEmpty else { return nil }
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
            HapticManager.impact(.light)
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
                let victory = store.combatVictory ?? true
                HapticManager.notification(victory ? .success : .error)
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
        guard let combat = store.combatState, card.cost >= 0 else { return }

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
                let targetFrame = enemyFrames[enemy.id]
                let endPt = targetFrame.map { CGPoint(x: $0.midX, y: $0.midY) } ?? CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.25)
                let startPt = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.78)
                startFlyAnimation(card: card, from: startPt, to: endPt) {
                    if card.target == .allEnemies {
                        CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
                    } else {
                        CombatEngine.playCard(cardID: card.id, targetEnemyID: enemy.id, store: store)
                    }
                    combat.selectedCardID = nil
                    combat.combatPhase = .playerAction
                }
            }
        case .selfTarget, .none:
            let endPt = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.55)
            let startPt = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.78)
            startFlyAnimation(card: card, from: startPt, to: endPt) {
                CombatEngine.playCard(cardID: card.id, targetEnemyID: nil, store: store)
                combat.selectedCardID = nil
                combat.combatPhase = .playerAction
            }
        }
    }

    private func handleEnemyTap(_ enemy: CombatEnemy) {
        guard let combat = store.combatState,
              combat.combatPhase == .targetSelection else { return }

        // Potion targeting mode
        if let potionIdx = potionTargetingIndex {
            CombatEngine.usePotion(potionIndex: potionIdx, targetEnemyID: enemy.id, store: store)
            potionTargetingIndex = nil
            combat.selectedTargetID = nil
            combat.combatPhase = .playerAction
            return
        }

        // Card targeting mode
        guard let cardID = combat.selectedCardID,
              let card = combat.hand.first(where: { $0.id == cardID }) else { return }
        combat.selectedTargetID = enemy.id
        let targetFrame = enemyFrames[enemy.id]
        let endPt = targetFrame.map { CGPoint(x: $0.midX, y: $0.midY) } ?? CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.25)
        let startPt = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.78)
        startFlyAnimation(card: card, from: startPt, to: endPt) {
            CombatEngine.playCard(cardID: cardID, targetEnemyID: enemy.id, store: store)
            combat.selectedCardID = nil
            combat.selectedTargetID = nil
            combat.combatPhase = .playerAction
        }
    }

    // MARK: - Helpers

    private func resetDrag() {
        dragCard = nil
        dragOffset = .zero
        isDragging = false
        dragTargetEnemyID = nil
    }

    private func nearestAliveEnemy(to point: CGPoint) -> UUID? {
        guard let combat = store.combatState else { return nil }
        var bestID: UUID? = nil
        var bestDist: CGFloat = .infinity
        for enemy in combat.aliveEnemies {
            guard let frame = enemyFrames[enemy.id] else { continue }
            let center = CGPoint(x: frame.midX, y: frame.midY)
            let dx = point.x - center.x
            let dy = point.y - center.y
            let dist = sqrt(dx * dx + dy * dy)
            if dist < bestDist {
                bestDist = dist
                bestID = enemy.id
            }
        }
        return bestID
    }

    private func spawnFloatingText(_ text: String, at position: CGPoint, color: Color, isCrit: Bool) {
        guard store.settings.showDamageNumbers else { return }
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


    // MARK: - Potion Bar

    private func potionBar(combat: CombatState) -> some View {
        HStack(spacing: 12) {
            ForEach(0..<3, id: \.self) { index in
                let potion = store.player.potions[index]
                Button {
                    if potion != nil {
                        confirmPotionIndex = index
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(potion != nil ? Theme.potionColor(for: potion.map { $0.id } ?? "").opacity(0.2) : Color.white.opacity(0.04))
                            .frame(width: 32, height: 32)
                        if let p = potion {
                            Image(systemName: "drop.fill")
                                .font(.system(size: 14))
                                .foregroundStyle(Theme.potionColor(for: p.id))
                        } else {
                            Circle()
                                .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                .frame(width: 32, height: 32)
                        }
                    }
                }
                .buttonStyle(.plain)
                .disabled(potion == nil || !combat.isPlayerTurn)
            }
        }
        .padding(.vertical, 4)
        .overlay {
            if let idx = confirmPotionIndex,
               let potion = store.player.potions[idx] {
                potionConfirmTooltip(potion: potion, index: idx)
            }
        }
    }

    private func potionConfirmTooltip(potion: PotionTemplate, index: Int) -> some View {
        VStack(spacing: 6) {
            Text(String(localized: LocalizedStringResource(stringLiteral: potion.nameKey)))
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)

            Text(String(localized: LocalizedStringResource(stringLiteral: potion.descriptionKey)))
                .font(.system(size: 10, weight: .regular, design: .rounded))
                .foregroundStyle(Theme.textSecondary)
                .lineLimit(2)
                .multilineTextAlignment(.center)

            Button {
                confirmPotionIndex = nil
                if let combat = store.combatState {
                    handlePotionTap(index: index, combat: combat)
                }
            } label: {
                Text(String(localized: "btn_use"))
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color(red: 0.30, green: 0.58, blue: 0.88)))
            }
            .buttonStyle(.plain)

            Button {
                confirmPotionIndex = nil
            } label: {
                Text(String(localized: "btn_cancel"))
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .frame(width: 160)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.12, green: 0.11, blue: 0.20))
                .shadow(color: .black.opacity(0.5), radius: 8, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.potionColor(for: potion.id).opacity(0.3), lineWidth: 1)
        )
        .offset(y: -60)
    }

    private func handlePotionTap(index: Int, combat: CombatState) {
        guard let potion = store.player.potions[index] else { return }

        switch potion.target {
        case .enemy:
            let alive = combat.aliveEnemies
            if alive.count == 1 {
                CombatEngine.usePotion(potionIndex: index, targetEnemyID: alive[0].id, store: store)
            } else if alive.count > 1 {
                combat.selectedCardID = nil
                combat.combatPhase = .targetSelection
                potionTargetingIndex = index
            }
        case .allEnemies, .selfTarget, .none:
            CombatEngine.usePotion(potionIndex: index, targetEnemyID: nil, store: store)
        }
    }


    // MARK: - Combat Log

    private var combatLogPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(String(localized: "label_combat_log"))
                    .font(.system(size: 13, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.3)) {
                        showCombatLog = false
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(Theme.textSecondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(red: 0.08, green: 0.07, blue: 0.12))

            Divider().background(Color.white.opacity(0.06))

            let recentLogs = Array(combatLog.suffix(20))
            ScrollView {
                ForEach(recentLogs) { entry in
                    HStack(spacing: 6) {
                        Image(systemName: entry.icon)
                            .font(.system(size: 10))
                            .foregroundStyle(entry.color)
                            .frame(width: 16)
                        Text(entry.text)
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textPrimary)
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                }
            }
            .frame(maxHeight: 280)
        }
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.10, green: 0.09, blue: 0.16))
                .shadow(color: .black.opacity(0.5), radius: 12, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
        .padding(.top, 80)
        .padding(.trailing, 12)
        .frame(maxWidth: .infinity, alignment: .topTrailing)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private func addLogEntry(icon: String, text: String, color: Color) {
        combatLog.append(CombatLogEntry(icon: icon, text: text, color: color))
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

// MARK: - Combat Log Entry

struct CombatLogEntry: Identifiable {
    let id = UUID()
    let icon: String
    let text: String
    let color: Color
}
