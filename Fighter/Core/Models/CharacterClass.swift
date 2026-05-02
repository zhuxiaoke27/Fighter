//
//  CharacterClass.swift
//  Fighter
//

import Foundation

enum CharacterClass: String, CaseIterable, Codable, Sendable {
    case warrior
    case assassin
    case mage

    var localizationKey: String {
        "character_\(rawValue)"
    }

    var baseHP: Int {
        switch self {
        case .warrior:  return 80
        case .assassin: return 70
        case .mage:     return 75
        }
    }

    var startingGold: Int { 99 }

    var startingDeckTemplateKeys: [String] {
        switch self {
        case .warrior:
            return Array(repeating: "strike_warrior", count: 5)
                 + Array(repeating: "defend_warrior", count: 4)
                 + ["bash_warrior"]
        case .assassin:
            return Array(repeating: "strike_assassin", count: 5)
                 + Array(repeating: "defend_assassin", count: 4)
                 + ["neutralize_assassin"]
        case .mage:
            return Array(repeating: "strike_mage", count: 4)
                 + Array(repeating: "defend_mage", count: 4)
                 + ["cast_mage"]
                 + ["survivor_mage"]
        }
    }
}
