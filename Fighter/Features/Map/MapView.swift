//
//  MapView.swift
//  Fighter
//

import SwiftUI

struct MapView: View {
    @Environment(GameStore.self) private var store
    @State private var showDeck = false
    @State private var showRelics = false
    @State private var hasAppeared = false
    @State private var showQuitConfirm = false
    @State private var showTutorial = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.08, blue: 0.18),
                    Color(red: 0.06, green: 0.05, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                mapHeader
                    .padding(.top, 16)

                if let mapState = store.mapState {
                    mapContent(mapState: mapState)
                }
            }

            if showTutorial {
                TutorialOverlay(text: String(localized: "tutorial_map")) {
                    showTutorial = false
                    store.settings.hasSeenMapTutorial = true
                    SaveManager.shared.saveSettings(store.settings)
                }
            }
        }
        .sheet(isPresented: $showDeck) {
            DeckView(deck: store.player.deck)
        }
        .sheet(isPresented: $showRelics) {
            RelicListView(relics: store.player.relics)
        }
        .alert(String(localized: "label_quit_confirm_title"), isPresented: $showQuitConfirm) {
            Button(String(localized: "btn_quit"), role: .destructive) {
                store.quitToMenu()
            }
            Button(String(localized: "btn_cancel"), role: .cancel) {}
        } message: {
            Text(String(localized: "label_quit_confirm_message"))
        }
    }

    private var mapHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: "label_act \(store.currentAct)"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                Text(String(localized: "label_floor \(store.currentFloor)"))
                    .font(Theme.captionFont)
                    .foregroundStyle(Theme.textSecondary)
            }

            Spacer()

            HStack(spacing: 4) {
                Image(systemName: "rectangle.stack")
                    .font(.system(size: 12))
                Text("\(store.player.deck.count)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Theme.textSecondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.white.opacity(0.06)))
            .onTapGesture { showDeck = true }

            if !store.player.relics.isEmpty {
                Button {
                    showRelics = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "gem")
                            .font(.system(size: 12))
                        Text("\(store.player.relics.count)")
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                    }
                    .foregroundStyle(Color(red: 0.70, green: 0.50, blue: 0.90))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color(red: 0.70, green: 0.50, blue: 0.90).opacity(0.1)))
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 3) {
                Image(systemName: "coins")
                    .font(.system(size: 12))
                Text("\(store.player.gold)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Theme.energyColor)
            .padding(.leading, 8)

            Button {
                showQuitConfirm = true
            } label: {
                Image(systemName: "xmark.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
            .padding(.leading, 6)
        }
        .padding(.horizontal, Theme.padding)
    }

    private func mapContent(mapState: MapState) -> some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    ForEach(Array(mapState.floors.enumerated().reversed()), id: \.offset) { floorIndex, nodes in
                        mapFloorSection(nodes: nodes, floorIndex: floorIndex, mapState: mapState)
                            .id(floorIndex)
                    }
                }
                .padding(.vertical, 40)
            }
            .onAppear {
                guard !hasAppeared else { return }
                hasAppeared = true
                if !store.settings.hasSeenMapTutorial {
                    showTutorial = true
                }
                // First time: scroll to boss (top), then animate down to current position
                let targetFloor = mapState.currentFloor
                // Start at the boss floor (top of reversed list)
                let bossFloor = mapState.floors.count - 1
                proxy.scrollTo(bossFloor, anchor: .top)
                // Animate down to current position after a brief pause
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(.easeInOut(duration: 1.2)) {
                        proxy.scrollTo(targetFloor, anchor: .center)
                    }
                }
            }
            .onChange(of: mapState.currentFloor) { _, newFloor in
                withAnimation(.easeInOut(duration: 0.5)) {
                    proxy.scrollTo(newFloor, anchor: .center)
                }
            }
            // Trigger scroll when returning to map (combat/reward/event/shop -> map)
            .onChange(of: store.gameState) { _, newState in
                if newState == .map {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            proxy.scrollTo(mapState.currentFloor, anchor: .center)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Floor Section (nodes + connection lines to next floor)

    private func mapFloorSection(nodes: [MapNode], floorIndex: Int, mapState: MapState) -> some View {
        VStack(spacing: 0) {
            // Floor label
            if floorIndex == MapGenerator.bossFloor {
                Text(String(localized: "label_boss"))
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.90))
                    .padding(.bottom, 4)
            } else if floorIndex == MapGenerator.restBeforeBoss {
                Text(String(localized: "label_rest"))
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.30, green: 0.72, blue: 0.42))
                    .padding(.bottom, 4)
            }

            // Nodes row
            HStack(spacing: 24) {
                ForEach(nodes) { node in
                    MapNodeView(node: node) {
                        guard node.isAccessible && !node.isVisited else { return }
                        mapState.visitNode(id: node.id)
                        store.handleNodeEncounter(node)
                    }
                    .frame(width: 44, height: 44)
                }
            }
            .frame(maxWidth: .infinity)

            // Connection lines to the floor below (next floor in traversal order)
            // Floors are displayed in reversed order, so "below" = lower index
            let nextFloorIndex = floorIndex - 1
            if nextFloorIndex >= 0 {
                let nextFloor = mapState.floors[nextFloorIndex]
                connectionLines(from: nodes, to: nextFloor, spacing: 36, mapState: mapState)
            } else {
                Spacer().frame(height: 36)
            }
        }
    }

    // MARK: - Connection Lines

    private func connectionLines(from: [MapNode], to: [MapNode], spacing: CGFloat, mapState: MapState) -> some View {
        Canvas { context, canvasSize in
            let nodeSize: CGFloat = 44
            let halfNode = nodeSize / 2
            let lineTop: CGFloat = 0
            let lineBottom = spacing

            let totalNodes = CGFloat(from.count)
            let nodeSpacing: CGFloat = 24 + nodeSize
            let totalWidth = totalNodes * nodeSize + (totalNodes - 1) * 24
            let startX = (canvasSize.width - totalWidth) / 2 + halfNode

            var fromPositions: [UUID: CGPoint] = [:]
            for (i, node) in from.enumerated() {
                let x = startX + CGFloat(i) * nodeSpacing
                fromPositions[node.id] = CGPoint(x: x, y: lineTop)
            }

            let toTotalNodes = CGFloat(to.count)
            let toTotalWidth = toTotalNodes * nodeSize + (toTotalNodes - 1) * 24
            let toStartX = (canvasSize.width - toTotalWidth) / 2 + halfNode
            let toNodeSpacing: CGFloat = 24 + nodeSize

            var toPositions: [UUID: CGPoint] = [:]
            for (i, node) in to.enumerated() {
                let x = toStartX + CGFloat(i) * toNodeSpacing
                toPositions[node.id] = CGPoint(x: x, y: lineBottom)
            }

            // Build lookup for accessible node IDs
            let accessibleNodeIDs = Set(to.filter { $0.isAccessible }.map(\.id))

            // Draw lines with enhanced visibility
            for fromNode in from {
                guard let fromPoint = fromPositions[fromNode.id] else { continue }
                for connectionID in fromNode.connections {
                    guard let toPoint = toPositions[connectionID] else { continue }

                    // Determine path state
                    let isVisitedPath = fromNode.isVisited
                    let isAccessiblePath = fromNode.isAccessible && accessibleNodeIDs.contains(connectionID)

                    let color: Color
                    let lineWidth: CGFloat
                    if isVisitedPath {
                        color = Color.white.opacity(0.45)
                        lineWidth = 2.5
                    } else if isAccessiblePath {
                        color = Color(red: 0.30, green: 0.72, blue: 0.90)
                        lineWidth = 2.5
                    } else {
                        color = Color.white.opacity(0.12)
                        lineWidth = 1.5
                    }

                    var path = Path()
                    path.move(to: fromPoint)
                    path.addLine(to: toPoint)
                    context.stroke(path, with: .color(color), lineWidth: lineWidth)

                    // Draw arrowhead near the bottom node
                    let arrowSize: CGFloat = 5
                    let dy = toPoint.y - fromPoint.y
                    let dx = toPoint.x - fromPoint.x
                    let length = sqrt(dx * dx + dy * dy)
                    guard length > 0 else { continue }
                    let ux = dx / length
                    let uy = dy / length
                    // Arrow tip at toPoint, offset up by halfNode so it doesn't overlap the node
                    let tipY = toPoint.y - halfNode * 0.3
                    let tipX = toPoint.x - ux * (toPoint.y - tipY) * (dx / max(abs(dx), 0.01))
                    let actualTip = CGPoint(x: toPoint.x, y: tipY)
                    let base1 = CGPoint(x: actualTip.x - ux * arrowSize + uy * arrowSize * 0.6,
                                        y: actualTip.y - uy * arrowSize - ux * arrowSize * 0.6)
                    let base2 = CGPoint(x: actualTip.x - ux * arrowSize - uy * arrowSize * 0.6,
                                        y: actualTip.y - uy * arrowSize + ux * arrowSize * 0.6)

                    var arrow = Path()
                    arrow.move(to: actualTip)
                    arrow.addLine(to: base1)
                    arrow.addLine(to: base2)
                    arrow.closeSubpath()
                    context.fill(arrow, with: .color(color.opacity(0.8)))

                    // Glow for accessible paths
                    if isAccessiblePath {
                        var glowPath = Path()
                        glowPath.move(to: fromPoint)
                        glowPath.addLine(to: toPoint)
                        context.stroke(glowPath, with: .color(color.opacity(0.2)), lineWidth: lineWidth + 4)
                    }
                }
            }
        }
        .frame(height: spacing)
    }
}
