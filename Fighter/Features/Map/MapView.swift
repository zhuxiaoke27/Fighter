//
//  MapView.swift
//  Fighter
//

import SwiftUI

struct MapView: View {
    @Environment(GameStore.self) private var store
    @State private var showDeck = false

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
                VStack(spacing: 36) {
                    ForEach(Array(mapState.floors.enumerated().reversed()), id: \.offset) { floorIndex, nodes in
                        mapFloorRow(nodes: nodes, floorIndex: floorIndex, mapState: mapState)
                            .id(floorIndex)
                    }
                }
                .padding(.vertical, 40)
            }
            .onChange(of: mapState.currentFloor) { _, newFloor in
                withAnimation {
                    proxy.scrollTo(newFloor, anchor: .center)
                }
            }
        }
    }

    private func mapFloorRow(nodes: [MapNode], floorIndex: Int, mapState: MapState) -> some View {
        VStack(spacing: 8) {
            if floorIndex == MapGenerator.bossFloor {
                Text("BOSS")
                    .font(.system(size: 11, weight: .heavy, design: .rounded))
                    .foregroundStyle(Color(red: 0.70, green: 0.35, blue: 0.90))
            } else if floorIndex == MapGenerator.restBeforeBoss {
                Text("REST")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.30, green: 0.72, blue: 0.42))
            }

            HStack(spacing: 24) {
                ForEach(nodes) { node in
                    MapNodeView(node: node) {
                        guard node.isAccessible && !node.isVisited else { return }
                        mapState.visitNode(id: node.id)
                        store.handleNodeEncounter(node)
                    }
                }
            }
        }
    }
}
