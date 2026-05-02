//
//  MapView.swift
//  Fighter
//

import SwiftUI

struct MapView: View {
    @Environment(GameStore.self) private var store
    @State private var showDeck = false
    @State private var hasAppeared = false

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
        }
        .sheet(isPresented: $showDeck) {
            DeckView(deck: store.player.deck)
        }
    }

    private var mapHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Act \(store.currentAct)")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                Text("Floor \(store.currentFloor)")
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

            HStack(spacing: 3) {
                Image(systemName: "coins")
                    .font(.system(size: 12))
                Text("\(store.player.gold)")
                    .font(.system(size: 12, weight: .bold, design: .rounded))
            }
            .foregroundStyle(Theme.energyColor)
            .padding(.leading, 8)
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
                Text("BOSS")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.90))
                    .padding(.bottom, 4)
            } else if floorIndex == MapGenerator.restBeforeBoss {
                Text("REST")
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
                connectionLines(from: nodes, to: nextFloor, spacing: 36)
            } else {
                Spacer().frame(height: 36)
            }
        }
    }

    // MARK: - Connection Lines

    private func connectionLines(from: [MapNode], to: [MapNode], spacing: CGFloat) -> some View {
        Canvas { context, canvasSize in
            let nodeSize: CGFloat = 44
            let halfNode = nodeSize / 2
            let lineTop: CGFloat = 0
            let lineBottom = spacing

            // Calculate node centers within the HStack
            // HStack spacing = 24, nodes are centered in the full width
            let totalNodes = CGFloat(from.count)
            let nodeSpacing: CGFloat = 24 + nodeSize // 44 + 24 gap
            let totalWidth = totalNodes * nodeSize + (totalNodes - 1) * 24
            let startX = (canvasSize.width - totalWidth) / 2 + halfNode

            // Build position maps
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

            // Draw lines
            for fromNode in from {
                guard let fromPoint = fromPositions[fromNode.id] else { continue }
                for connectionID in fromNode.connections {
                    guard let toPoint = toPositions[connectionID] else { continue }
                    var path = Path()
                    path.move(to: fromPoint)
                    path.addLine(to: toPoint)

                    let isVisitedPath = fromNode.isVisited
                    let color: Color = isVisitedPath
                        ? Color.white.opacity(0.18)
                        : Color.white.opacity(0.07)
                    context.stroke(path, with: .color(color), lineWidth: 1)
                }
            }
        }
        .frame(height: spacing)
    }
}
