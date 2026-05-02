//
//  MapGenerator.swift
//  Fighter
//

import Foundation

enum MapGenerator {
    static let floorsPerAct = 16
    static let bossFloor = 15
    static let restBeforeBoss = 14

    static func generate(act: Int) -> MapState {
        let mapState = MapState(act: act)
        var floors: [[MapNode]] = []

        // Floor 0: starting nodes
        let startNodes = [
            MapNode(floor: 0, column: 0, type: .battle, isAccessible: true),
            MapNode(floor: 0, column: 1, type: .battle, isAccessible: true),
            MapNode(floor: 0, column: 2, type: .battle, isAccessible: true)
        ]
        floors.append(startNodes)

        // Floors 1-13: random nodes
        for floorIndex in 1...13 {
            let nodeCount = Int.random(in: 3...4)
            let nodes = (0..<nodeCount).map { col in
                MapNode(floor: floorIndex, column: col, type: weightedRandomType(floorIndex: floorIndex, act: act))
            }
            floors.append(nodes)
        }

        // Floor 14: rest site before boss
        floors.append([
            MapNode(floor: 14, column: 1, type: .restSite)
        ])

        // Floor 15: boss
        floors.append([
            MapNode(floor: 15, column: 1, type: .boss)
        ])

        // Connect floors
        for floorIndex in 0..<(floors.count - 1) {
            connectFloors(from: floors[floorIndex], to: floors[floorIndex + 1], floors: &floors, fromIndex: floorIndex)
        }

        mapState.floors = floors
        return mapState
    }

    private static func connectFloors(from: [MapNode], to: [MapNode], floors: inout [[MapNode]], fromIndex: Int) {
        for sourceIdx in from.indices {
            let source = from[sourceIdx]
            let connectionCount = Int.random(in: 1...min(2, to.count))

            let sortedDests = to.enumerated()
                .sorted { abs($0.element.column - source.column) < abs($1.element.column - source.column) }

            let connections = sortedDests.prefix(connectionCount).map(\.element.id)
            floors[fromIndex][sourceIdx].connections = connections
        }
    }

    private static func weightedRandomType(floorIndex: Int, act: Int) -> MapNodeType {
        let roll = Double.random(in: 0...1)

        let eliteBonus = Double(act - 1) * 0.06
        let restPenalty = Double(act - 1) * 0.04
        let hardBattleChance = floorIndex >= 4 ? 0.08 + Double(act - 1) * 0.04 : 0

        if floorIndex <= 3 {
            if roll < 0.60 { return .battle }
            if roll < 0.78 { return .event }
            if roll < 0.88 { return .shop }
            if roll < 0.95 + eliteBonus { return .elite }
            return .restSite
        } else if floorIndex <= 9 {
            if roll < 0.35 { return .battle }
            if roll < 0.35 + hardBattleChance { return .hardBattle }
            if roll < 0.55 { return .event }
            if roll < 0.70 { return .shop }
            if roll < 0.88 + eliteBonus { return .elite }
            return .restSite
        } else {
            if roll < 0.25 { return .battle }
            if roll < 0.25 + hardBattleChance { return .hardBattle }
            if roll < 0.45 { return .event }
            if roll < 0.60 + eliteBonus { return .elite }
            if roll < 0.80 + restPenalty { return .shop }
            return .restSite
        }
    }
}
