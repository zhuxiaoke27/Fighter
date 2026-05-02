//
//  RelicDatabase.swift
//  Fighter
//

import Foundation

struct RelicDatabase {

    static let allRelics: [RelicTemplate] = [
        // MARK: - Starter relics (one per class)
        RelicTemplate(
            id: "burning_blood",
            nameKey: "relic_burning_blood",
            descriptionKey: "relic_burning_blood_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .heal(6))
            ],
            rarity: .starter
        ),
        RelicTemplate(
            id: "ring_of_snakes",
            nameKey: "relic_ring_of_snakes",
            descriptionKey: "relic_ring_of_snakes_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .drawCards(1))
            ],
            rarity: .starter
        ),
        RelicTemplate(
            id: "cracked_core",
            nameKey: "relic_cracked_core",
            descriptionKey: "relic_cracked_core_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyBuffToAll(.strength, stacks: 1))
            ],
            rarity: .starter
        ),

        // MARK: - Common relics
        RelicTemplate(
            id: "anchor",
            nameKey: "relic_anchor",
            descriptionKey: "relic_anchor_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .gainBlock(10))
            ],
            rarity: .common
        ),
        RelicTemplate(
            id: "bag_of_marbles",
            nameKey: "relic_bag_of_marbles",
            descriptionKey: "relic_bag_of_marbles_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyDebuffToAll(.vulnerable, stacks: 1))
            ],
            rarity: .common
        ),
        RelicTemplate(
            id: "ceramic_fish",
            nameKey: "relic_ceramic_fish",
            descriptionKey: "relic_ceramic_fish_desc",
            effects: [
                RelicEffect(trigger: .onCardAdded, effect: .gainEnergy(1))
            ],
            rarity: .common
        ),

        // MARK: - Uncommon relics
        RelicTemplate(
            id: "orichalcum",
            nameKey: "relic_orichalcum",
            descriptionKey: "relic_orichalcum_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .uncommon
        ),
        RelicTemplate(
            id: "shuriken",
            nameKey: "relic_shuriken",
            descriptionKey: "relic_shuriken_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon
        ),
        RelicTemplate(
            id: "pen_nib",
            nameKey: "relic_pen_nib",
            descriptionKey: "relic_pen_nib_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon
        ),
        RelicTemplate(
            id: "meat_on_the_bone",
            nameKey: "relic_meat_on_the_bone",
            descriptionKey: "relic_meat_on_the_bone_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .uncommon
        ),

        // MARK: - Rare relics

        RelicTemplate(
            id: "dead_branch",
            nameKey: "relic_dead_branch",
            descriptionKey: "relic_dead_branch_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .rare
        ),
        RelicTemplate(
            id: "calipers",
            nameKey: "relic_calipers",
            descriptionKey: "relic_calipers_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .rare
        ),
        RelicTemplate(
            id: "torsion",
            nameKey: "relic_torsion",
            descriptionKey: "relic_torsion_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .rare
        ),
        RelicTemplate(
            id: "fossilized_helix",
            nameKey: "relic_fossilized_helix",
            descriptionKey: "relic_fossilized_helix_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .composite([]))
            ],
            rarity: .rare
        ),
        RelicTemplate(
            id: "chemical_x",
            nameKey: "relic_chemical_x",
            descriptionKey: "relic_chemical_x_desc",
            effects: [
                RelicEffect(trigger: .onPotionUsed, effect: .composite([]))
            ],
            rarity: .rare
        )
    ]

    // MARK: - Lookup

    static func startingRelic(for characterClass: CharacterClass) -> RelicTemplate {
        switch characterClass {
        case .warrior:  return allRelics.first { $0.id == "burning_blood" }!
        case .assassin: return allRelics.first { $0.id == "ring_of_snakes" }!
        case .mage:     return allRelics.first { $0.id == "cracked_core" }!
        }
    }

    static func randomRelic(rarity: CardRarity? = nil, excluding owned: [RelicTemplate] = []) -> RelicTemplate {
        let ownedIDs = Set(owned.map(\.id))
        var pool = allRelics.filter { !ownedIDs.contains($0.id) && $0.rarity != .starter }
        if let rarity {
            pool = pool.filter { $0.rarity == rarity }
        }
        return pool.randomElement() ?? allRelics[3]
    }
}
