//
//  BuffType.swift
//  Fighter
//

import Foundation

enum BuffType: String, Codable, Sendable, CaseIterable {
    // Positive buffs
    case strength
    case dexterity
    case artifact
    case barricade
    case regenerate
    case metallicize
    case platedArmor
    case thorns
    case drawModifier

    // Negative debuffs
    case vulnerable
    case weak
    case frail
    case poison
    case burn

    // New buff types
    case frost
    case dark
    case focus
    case negate
    case nextCardDoubled

    // Persistent power buffs (tick each turn)
    case demonForm
    case noxiousFumes

    var isDebuff: Bool {
        switch self {
        case .vulnerable, .weak, .frail, .poison, .burn:
            return true
        default:
            return false
        }
    }

    var localizationKey: String {
        "buff_\(rawValue)"
    }
}

struct BuffInstance: Identifiable, Codable, Sendable {
    let id: UUID
    var type: BuffType
    var stacks: Int
    var isDurationBased: Bool

    init(type: BuffType, stacks: Int, isDurationBased: Bool = false) {
        self.id = UUID()
        self.type = type
        self.stacks = stacks
        self.isDurationBased = isDurationBased
    }
}
