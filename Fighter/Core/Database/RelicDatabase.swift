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
            rarity: .starter,
            tags: [.starter, .warrior, .defensive]
        ),
        RelicTemplate(
            id: "ring_of_snakes",
            nameKey: "relic_ring_of_snakes",
            descriptionKey: "relic_ring_of_snakes_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .drawCards(1))
            ],
            rarity: .starter,
            tags: [.starter, .assassin, .utility]
        ),
        RelicTemplate(
            id: "cracked_core",
            nameKey: "relic_cracked_core",
            descriptionKey: "relic_cracked_core_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyBuffToAll(.strength, stacks: 1))
            ],
            rarity: .starter,
            tags: [.starter, .mage, .offensive]
        ),

        // MARK: - Common relics
        RelicTemplate(
            id: "anchor",
            nameKey: "relic_anchor",
            descriptionKey: "relic_anchor_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .gainBlock(10))
            ],
            rarity: .common,
            tags: [.common, .defensive]
        ),
        RelicTemplate(
            id: "bag_of_marbles",
            nameKey: "relic_bag_of_marbles",
            descriptionKey: "relic_bag_of_marbles_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyDebuffToAll(.vulnerable, stacks: 1))
            ],
            rarity: .common,
            tags: [.common, .offensive]
        ),
        RelicTemplate(
            id: "ceramic_fish",
            nameKey: "relic_ceramic_fish",
            descriptionKey: "relic_ceramic_fish_desc",
            effects: [
                RelicEffect(trigger: .onCardAdded, effect: .gainEnergy(1))
            ],
            rarity: .common,
            tags: [.common, .economic]
        ),
        RelicTemplate(
            id: "darkstone_periapt",
            nameKey: "relic_darkstone_periapt",
            descriptionKey: "relic_darkstone_periapt_desc",
            effects: [
                RelicEffect(trigger: .onCardAdded, effect: .heal(5))
            ],
            rarity: .common,
            tags: [.common, .defensive]
        ),
        RelicTemplate(
            id: "happy_flower",
            nameKey: "relic_happy_flower",
            descriptionKey: "relic_happy_flower_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .common,
            tags: [.common, .utility]
        ),
        RelicTemplate(
            id: "lantern",
            nameKey: "relic_lantern",
            descriptionKey: "relic_lantern_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .gainEnergy(1))
            ],
            rarity: .common,
            tags: [.common, .utility]
        ),
        RelicTemplate(
            id: "vajra",
            nameKey: "relic_vajra",
            descriptionKey: "relic_vajra_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyBuff(.strength, stacks: 1))
            ],
            rarity: .common,
            tags: [.common, .offensive]
        ),
        RelicTemplate(
            id: "sundial",
            nameKey: "relic_sundial",
            descriptionKey: "relic_sundial_desc",
            effects: [
                RelicEffect(trigger: .onShuffle, effect: .gainBlock(2))
            ],
            rarity: .common,
            tags: [.common, .defensive]
        ),
        RelicTemplate(
            id: "red_skull",
            nameKey: "relic_red_skull",
            descriptionKey: "relic_red_skull_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .common,
            tags: [.common, .offensive]
        ),

        // MARK: - Uncommon relics
        RelicTemplate(
            id: "orichalcum",
            nameKey: "relic_orichalcum",
            descriptionKey: "relic_orichalcum_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .defensive]
        ),
        RelicTemplate(
            id: "shuriken",
            nameKey: "relic_shuriken",
            descriptionKey: "relic_shuriken_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive]
        ),
        RelicTemplate(
            id: "pen_nib",
            nameKey: "relic_pen_nib",
            descriptionKey: "relic_pen_nib_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive]
        ),
        RelicTemplate(
            id: "meat_on_the_bone",
            nameKey: "relic_meat_on_the_bone",
            descriptionKey: "relic_meat_on_the_bone_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .defensive]
        ),
        RelicTemplate(
            id: "kunai",
            nameKey: "relic_kunai",
            descriptionKey: "relic_kunai_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive, .assassin]
        ),
        RelicTemplate(
            id: "wrist_blade",
            nameKey: "relic_wrist_blade",
            descriptionKey: "relic_wrist_blade_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive, .assassin]
        ),
        RelicTemplate(
            id: "pantograph",
            nameKey: "relic_pantograph",
            descriptionKey: "relic_pantograph_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .defensive]
        ),
        RelicTemplate(
            id: "peace_pipe",
            nameKey: "relic_peace_pipe",
            descriptionKey: "relic_peace_pipe_desc",
            effects: [
                RelicEffect(trigger: .onCardAdded, effect: .heal(3))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .utility]
        ),
        RelicTemplate(
            id: "paper_crane",
            nameKey: "relic_paper_crane",
            descriptionKey: "relic_paper_crane_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .defensive]
        ),

        // MARK: - Rare relics
        RelicTemplate(
            id: "dead_branch",
            nameKey: "relic_dead_branch",
            descriptionKey: "relic_dead_branch_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        ),
        RelicTemplate(
            id: "calipers",
            nameKey: "relic_calipers",
            descriptionKey: "relic_calipers_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .defensive]
        ),
        RelicTemplate(
            id: "torsion",
            nameKey: "relic_torsion",
            descriptionKey: "relic_torsion_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .offensive]
        ),
        RelicTemplate(
            id: "fossilized_helix",
            nameKey: "relic_fossilized_helix",
            descriptionKey: "relic_fossilized_helix_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        ),
        RelicTemplate(
            id: "chemical_x",
            nameKey: "relic_chemical_x",
            descriptionKey: "relic_chemical_x_desc",
            effects: [
                RelicEffect(trigger: .onPotionUsed, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        ),
        RelicTemplate(
            id: "strange_spoon",
            nameKey: "relic_strange_spoon",
            descriptionKey: "relic_strange_spoon_desc",
            effects: [
                RelicEffect(trigger: .onExhaust, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        ),
        RelicTemplate(
            id: "du_vu_doll",
            nameKey: "relic_du_vu_doll",
            descriptionKey: "relic_du_vu_doll_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .offensive]
        ),
        RelicTemplate(
            id: "mummified_hand",
            nameKey: "relic_mummified_hand",
            descriptionKey: "relic_mummified_hand_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.power), effect: .gainEnergy(1))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        ),
        RelicTemplate(
            id: "gambling_chip",
            nameKey: "relic_gambling_chip",
            descriptionKey: "relic_gambling_chip_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .drawCards(1))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        )
    ]

    // MARK: - Lookup

    static func relic(byID id: String) -> RelicTemplate? {
        allRelics.first { $0.id == id }
    }

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
