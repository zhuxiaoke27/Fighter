//
//  Ascension.swift
//  Fighter
//

import Foundation

enum AscensionLevel: Int, Codable, Sendable, CaseIterable {
    case none = 0
    case asc1 = 1, asc2 = 2, asc3 = 3, asc4 = 4, asc5 = 5
    case asc6 = 6, asc7 = 7, asc8 = 8, asc9 = 9, asc10 = 10
    case asc11 = 11, asc12 = 12, asc13 = 13, asc14 = 14, asc15 = 15
    case asc16 = 16, asc17 = 17, asc18 = 18, asc19 = 19, asc20 = 20

    var displayName: String {
        self == .none ? "Normal" : "Ascension \(rawValue)"
    }

    var isActive: Bool { self != .none }
}

enum AscensionModifier: String, CaseIterable, Codable, Sendable, Identifiable {
    case lessGold = "asc1"
    case lessHealing = "asc2"
    case tougherElites = "asc3"
    case lessPotions = "asc4"
    case lessRewards = "asc5"
    case tougherBosses = "asc6"
    case lessMaxHP = "asc7"
    case harderEvents = "asc8"
    case tougherNormal = "asc9"
    case startCursed = "asc10"
    case lessGold2 = "asc11"
    case lessHealing2 = "asc12"
    case tougherElites2 = "asc13"
    case lessPotions2 = "asc14"
    case lessRewards2 = "asc15"
    case tougherBosses2 = "asc16"
    case lessMaxHP2 = "asc17"
    case harderEvents2 = "asc18"
    case tougherNormal2 = "asc19"
    case nightmare = "asc20"

    var level: Int { Int(rawValue.replacingOccurrences(of: "asc", with: "")) ?? 0 }

    var id: String { rawValue }

    var descriptionKey: String { "asc_\(rawValue)_desc" }
}
