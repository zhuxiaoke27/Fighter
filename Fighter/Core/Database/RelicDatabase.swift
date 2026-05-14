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
                RelicEffect(trigger: .passive, effect: .heal(6))
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
                RelicEffect(trigger: .onCombatStart, effect: .applyBuff(.strength, stacks: 1))
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

        // MARK: - Uncommon relics (new)
        RelicTemplate(
            id: "juzu_bracelet",
            nameKey: "relic_juzu_bracelet",
            descriptionKey: "relic_juzu_bracelet_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .common,
            tags: [.common, .utility]
        ),
        RelicTemplate(
            id: "orichalcum_heavy",
            nameKey: "relic_orichalcum_heavy",
            descriptionKey: "relic_orichalcum_heavy_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .composite([]))
            ],
            rarity: .common,
            tags: [.common, .defensive]
        ),
        RelicTemplate(
            id: "champion_belt",
            nameKey: "relic_champion_belt",
            descriptionKey: "relic_champion_belt_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive]
        ),
        RelicTemplate(
            id: "fire_breathing",
            nameKey: "relic_fire_breathing",
            descriptionKey: "relic_fire_breathing_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.curse), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive]
        ),
        RelicTemplate(
            id: "paper_krane",
            nameKey: "relic_paper_krane",
            descriptionKey: "relic_paper_krane_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .defensive]
        ),
        RelicTemplate(
            id: "thread_and_needle",
            nameKey: "relic_thread_and_needle",
            descriptionKey: "relic_thread_and_needle_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .composite([]))
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
                RelicEffect(trigger: .onExhaust, effect: .composite([]))
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
        ),
        RelicTemplate(
            id: "snecko_eye",
            nameKey: "relic_snecko_eye",
            descriptionKey: "relic_snecko_eye_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .boss, .utility]
        ),
        RelicTemplate(
            id: "runic_pyramid",
            nameKey: "relic_runic_pyramid",
            descriptionKey: "relic_runic_pyramid_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .boss, .utility]
        ),

        // MARK: - Boss relics
        RelicTemplate(
            id: "philosophers_stone",
            nameKey: "relic_philosophers_stone",
            descriptionKey: "relic_philosophers_stone_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .utility]
        ),
        RelicTemplate(
            id: "cursed_key",
            nameKey: "relic_cursed_key",
            descriptionKey: "relic_cursed_key_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .utility]
        ),
        RelicTemplate(
            id: "ring_of_the_serpent",
            nameKey: "relic_ring_of_the_serpent",
            descriptionKey: "relic_ring_of_the_serpent_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .drawCards(1))
            ],
            rarity: .rare,
            tags: [.boss, .utility]
        ),
        RelicTemplate(
            id: "inserter",
            nameKey: "relic_inserter",
            descriptionKey: "relic_inserter_desc",
            effects: [
                RelicEffect(trigger: .onEnemyKilled, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .defensive]
        ),
        RelicTemplate(
            id: "sling_of_courage",
            nameKey: "relic_sling_of_courage",
            descriptionKey: "relic_sling_of_courage_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyBuff(.strength, stacks: 2))
            ],
            rarity: .rare,
            tags: [.boss, .offensive]
        ),
        RelicTemplate(
            id: "empty_cage",
            nameKey: "relic_empty_cage",
            descriptionKey: "relic_empty_cage_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .rare]
        ),
        RelicTemplate(
            id: "busted_crown",
            nameKey: "relic_busted_crown",
            descriptionKey: "relic_busted_crown_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .rare]
        ),
        RelicTemplate(
            id: "astrolabe",
            nameKey: "relic_astrolabe",
            descriptionKey: "relic_astrolabe_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .rare]
        ),
        RelicTemplate(
            id: "fusion_hammer_rework",
            nameKey: "relic_fusion_hammer_rework",
            descriptionKey: "relic_fusion_hammer_rework_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.boss, .rare]
        ),

        // MARK: - New Common Relics (Phase 5)
        RelicTemplate(
            id: "red_guard_ring",
            nameKey: "relic_red_guard_ring",
            descriptionKey: "relic_red_guard_ring_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .gainBlock(5))
            ],
            rarity: .common,
            tags: [.common, .defensive]
        ),
        RelicTemplate(
            id: "bird_faced_urn",
            nameKey: "relic_bird_faced_urn",
            descriptionKey: "relic_bird_faced_urn_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .heal(2))
            ],
            rarity: .common,
            tags: [.common, .defensive]
        ),
        RelicTemplate(
            id: "potion_belt",
            nameKey: "relic_potion_belt",
            descriptionKey: "relic_potion_belt_desc",
            effects: [
                RelicEffect(trigger: .passive, effect: .composite([]))
            ],
            rarity: .common,
            tags: [.common, .utility]
        ),
        RelicTemplate(
            id: "war_paint",
            nameKey: "relic_war_paint",
            descriptionKey: "relic_war_paint_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .applyBuff(.strength, stacks: 1))
            ],
            rarity: .common,
            tags: [.common, .offensive]
        ),
        RelicTemplate(
            id: "lantern_turn",
            nameKey: "relic_lantern_turn",
            descriptionKey: "relic_lantern_turn_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .gainEnergy(1))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .utility]
        ),
        RelicTemplate(
            id: "bag_of_gems",
            nameKey: "relic_bag_of_gems",
            descriptionKey: "relic_bag_of_gems_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .gainBlock(3))
            ],
            rarity: .common,
            tags: [.common, .economic]
        ),

        // MARK: - New Uncommon Relics (Phase 5)
        RelicTemplate(
            id: "ink_bottle",
            nameKey: "relic_ink_bottle",
            descriptionKey: "relic_ink_bottle_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.attack), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .utility]
        ),
        RelicTemplate(
            id: "sundial_energy",
            nameKey: "relic_sundial_energy",
            descriptionKey: "relic_sundial_energy_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .utility]
        ),
        RelicTemplate(
            id: "kunai_dex",
            nameKey: "relic_kunai_dex",
            descriptionKey: "relic_kunai_dex_desc",
            effects: [
                RelicEffect(trigger: .onCardPlayed(.skill), effect: .composite([]))
            ],
            rarity: .uncommon,
            tags: [.uncommon, .offensive, .assassin]
        ),

        // MARK: - New Rare Relics (Phase 5)
        RelicTemplate(
            id: "runic_cube",
            nameKey: "relic_runic_cube",
            descriptionKey: "relic_runic_cube_desc",
            effects: [
                RelicEffect(trigger: .onTurnStart, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .utility]
        ),
        RelicTemplate(
            id: "tungsten_helm",
            nameKey: "relic_tungsten_helm",
            descriptionKey: "relic_tungsten_helm_desc",
            effects: [
                RelicEffect(trigger: .onBlockGained, effect: .composite([]))
            ],
            rarity: .rare,
            tags: [.rare, .defensive]
        ),

        // MARK: - New Boss Relics (Phase 5)
        RelicTemplate(
            id: "ring_of_the_snake_plus",
            nameKey: "relic_ring_of_the_snake_plus",
            descriptionKey: "relic_ring_of_the_snake_plus_desc",
            effects: [
                RelicEffect(trigger: .onCombatStart, effect: .drawCards(2))
            ],
            rarity: .rare,
            tags: [.boss, .utility]
        ),
        RelicTemplate(
            id: "frozen_core",
            nameKey: "relic_frozen_core",
            descriptionKey: "relic_frozen_core_desc",
            effects: [
                RelicEffect(trigger: .onTurnEnd, effect: .gainBlock(4))
            ],
            rarity: .rare,
            tags: [.boss, .defensive]
        )
    ]

    // MARK: - Lookup

    static func relic(byID id: String) -> RelicTemplate? {
        allRelics.first { $0.id == id }
    }

    static func startingRelic(for characterClass: CharacterClass) -> RelicTemplate {
        switch characterClass {
        case .warrior:  return allRelics.first { $0.id == "burning_blood" } ?? allRelics[0]
        case .assassin: return allRelics.first { $0.id == "ring_of_snakes" } ?? allRelics[1]
        case .mage:     return allRelics.first { $0.id == "cracked_core" } ?? allRelics[2]
        }
    }

    static func randomRelic(rarity: CardRarity? = nil, excluding owned: [RelicTemplate] = []) -> RelicTemplate {
        let ownedIDs = Set(owned.map(\.id))
        var pool = allRelics.filter { !ownedIDs.contains($0.id) && $0.rarity != .starter }
        if let rarity {
            pool = pool.filter { $0.rarity == rarity }
        }
        return pool.randomElement() ?? allRelics.first { $0.rarity == .common && !ownedIDs.contains($0.id) } ?? allRelics[3]
    }

    static func randomBossRelics(count: Int = 3, excluding owned: [RelicTemplate] = []) -> [RelicTemplate] {
        let ownedIDs = Set(owned.map(\.id))
        let pool = allRelics.filter { $0.tags.contains(.boss) && !ownedIDs.contains($0.id) }
        return Array(pool.shuffled().prefix(count))
    }
}
