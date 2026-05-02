//
//  MapState.swift
//  Fighter
//

import Foundation

enum MapNodeType: String, Codable, Sendable {
    case battle
    case hardBattle
    case elite
    case boss
    case restSite
    case shop
    case event
    case mystery

    var iconName: String {
        switch self {
        case .battle:     return "cross.sword"
        case .hardBattle: return "flame.circle"
        case .elite:      return "star.shield"
        case .boss:       return "crown"
        case .restSite:   return "flame"
        case .shop:       return "cart"
        case .event:      return "questionmark"
        case .mystery:    return "questionmark.folder"
        }
    }

    var localizationKey: String {
        "map_node_\(rawValue)"
    }
}

struct MapNode: Identifiable, Codable {
    let id: UUID
    let floor: Int
    let column: Int
    let type: MapNodeType
    var connections: [UUID]
    var isVisited: Bool
    var isAccessible: Bool

    init(
        id: UUID = UUID(),
        floor: Int,
        column: Int,
        type: MapNodeType,
        connections: [UUID] = [],
        isVisited: Bool = false,
        isAccessible: Bool = false
    ) {
        self.id = id
        self.floor = floor
        self.column = column
        self.type = type
        self.connections = connections
        self.isVisited = isVisited
        self.isAccessible = isAccessible
    }
}

@Observable
final class MapState {
    let act: Int
    var floors: [[MapNode]] = []
    var currentNodeID: UUID?
    var currentFloor: Int = 0

    init(act: Int) {
        self.act = act
    }

    // MARK: - Codable Support

    struct CodableDTO: Codable, Sendable {
        let act: Int
        let floors: [[MapNode]]
        let currentNodeID: UUID?
        let currentFloor: Int
    }

    convenience init(from dto: CodableDTO) {
        self.init(act: dto.act)
        self.floors = dto.floors
        self.currentNodeID = dto.currentNodeID
        self.currentFloor = dto.currentFloor
    }

    var dto: CodableDTO {
        CodableDTO(
            act: act,
            floors: floors,
            currentNodeID: currentNodeID,
            currentFloor: currentFloor
        )
    }

    func accessibleNodes() -> [MapNode] {
        guard let currentID = currentNodeID else {
            return floors.first ?? []
        }
        guard let current = findNode(id: currentID) else { return [] }
        return current.connections.compactMap { findNode(id: $0) }.filter { !$0.isVisited }
    }

    func visitNode(id: UUID) {
        guard let floorIndex = floors.firstIndex(where: { $0.contains(where: { $0.id == id }) }),
              let nodeIndex = floors[floorIndex].firstIndex(where: { $0.id == id }) else { return }

        floors[floorIndex][nodeIndex].isVisited = true
        currentNodeID = id
        currentFloor = floorIndex

        for connectionID in floors[floorIndex][nodeIndex].connections {
            for fi in floors.indices {
                for ni in floors[fi].indices {
                    if floors[fi][ni].id == connectionID && !floors[fi][ni].isVisited {
                        floors[fi][ni].isAccessible = true
                    }
                }
            }
        }
    }

    private func findNode(id: UUID) -> MapNode? {
        for floor in floors {
            if let node = floor.first(where: { $0.id == id }) {
                return node
            }
        }
        return nil
    }
}
