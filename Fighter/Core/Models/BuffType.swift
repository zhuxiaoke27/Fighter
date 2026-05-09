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

    var abbreviation: String {
        switch self {
        case .strength: return "STR"
        case .dexterity: return "DEX"
        case .artifact: return "ART"
        case .barricade: return "BAR"
        case .regenerate: return "REG"
        case .metallicize: return "MET"
        case .platedArmor: return "PLT"
        case .thorns: return "THR"
        case .drawModifier: return "DRW"
        case .vulnerable: return "VUL"
        case .weak: return "WEK"
        case .frail: return "FRL"
        case .poison: return "PSN"
        case .burn: return "BRN"
        case .frost: return "FRS"
        case .dark: return "DRK"
        case .focus: return "FOC"
        case .negate: return "NEG"
        case .nextCardDoubled: return "x2"
        case .demonForm: return "DMN"
        case .noxiousFumes: return "NOX"
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
    var isRedSkullBonus: Bool

    init(type: BuffType, stacks: Int, isDurationBased: Bool = false, isRedSkullBonus: Bool = false) {
        self.id = UUID()
        self.type = type
        self.stacks = stacks
        self.isDurationBased = isDurationBased
        self.isRedSkullBonus = isRedSkullBonus
    }
}
