//
//  PotionDatabase.swift
//  Fighter
//

import Foundation

struct PotionDatabase {

    static let allPotions: [PotionTemplate] = [
        PotionTemplate(
            id: "fire_potion",
            nameKey: "potion_fire_potion",
            descriptionKey: "potion_fire_potion_desc",
            effects: [.dealDamage(20)],
            target: .enemy,
            rarity: .common
        ),
        PotionTemplate(
            id: "block_potion",
            nameKey: "potion_block_potion",
            descriptionKey: "potion_block_potion_desc",
            effects: [.gainBlock(12)],
            target: .selfTarget,
            rarity: .common
        ),
        PotionTemplate(
            id: "strength_potion",
            nameKey: "potion_strength_potion",
            descriptionKey: "potion_strength_potion_desc",
            effects: [.applyBuff(.strength, stacks: 2)],
            target: .selfTarget,
            rarity: .uncommon
        ),
        PotionTemplate(
            id: "weakness_potion",
            nameKey: "potion_weakness_potion",
            descriptionKey: "potion_weakness_potion_desc",
            effects: [.applyDebuff(.weak, stacks: 3)],
            target: .enemy,
            rarity: .common
        ),
        PotionTemplate(
            id: "energy_potion",
            nameKey: "potion_energy_potion",
            descriptionKey: "potion_energy_potion_desc",
            effects: [.gainEnergy(2)],
            target: .selfTarget,
            rarity: .uncommon
        ),

        // MARK: - Rare Potions

        PotionTemplate(
            id: "elixir_potion",
            nameKey: "potion_elixir_potion",
            descriptionKey: "potion_elixir_potion_desc",
            effects: [.heal(20)],
            target: .selfTarget,
            rarity: .rare
        ),
        PotionTemplate(
            id: "liquid_memories",
            nameKey: "potion_liquid_memories",
            descriptionKey: "potion_liquid_memories_desc",
            effects: [.gainEnergy(3), .drawCards(2)],
            target: .selfTarget,
            rarity: .rare
        ),
        PotionTemplate(
            id: "bottled_void",
            nameKey: "potion_bottled_void",
            descriptionKey: "potion_bottled_void_desc",
            effects: [.applyDebuff(.vulnerable, stacks: 3), .applyDebuff(.weak, stacks: 3)],
            target: .enemy,
            rarity: .rare
        ),

        // MARK: - New Common Potions

        PotionTemplate(
            id: "fear_potion",
            nameKey: "potion_fear_potion",
            descriptionKey: "potion_fear_potion_desc",
            effects: [.applyDebuff(.vulnerable, stacks: 3)],
            target: .enemy,
            rarity: .common
        ),
        PotionTemplate(
            id: "swift_potion",
            nameKey: "potion_swift_potion",
            descriptionKey: "potion_swift_potion_desc",
            effects: [.drawCards(3)],
            target: .none,
            rarity: .common
        ),

        // MARK: - New Uncommon Potions

        PotionTemplate(
            id: "regen_potion",
            nameKey: "potion_regen_potion",
            descriptionKey: "potion_regen_potion_desc",
            effects: [.applyBuff(.regenerate, stacks: 5)],
            target: .selfTarget,
            rarity: .uncommon
        ),
        PotionTemplate(
            id: "dual_energy",
            nameKey: "potion_dual_energy",
            descriptionKey: "potion_dual_energy_desc",
            effects: [.gainEnergy(3)],
            target: .none,
            rarity: .uncommon
        ),
        PotionTemplate(
            id: "gamblers_brew",
            nameKey: "potion_gamblers_brew",
            descriptionKey: "potion_gamblers_brew_desc",
            effects: [.drawCards(4)],
            target: .none,
            rarity: .uncommon
        ),

        // MARK: - New Rare Potions

        PotionTemplate(
            id: "fire_potion_large",
            nameKey: "potion_fire_potion_large",
            descriptionKey: "potion_fire_potion_large_desc",
            effects: [.dealDamageToAll(20)],
            target: .allEnemies,
            rarity: .rare
        ),
        PotionTemplate(
            id: "ghost_in_a_jar",
            nameKey: "potion_ghost_in_a_jar",
            descriptionKey: "potion_ghost_in_a_jar_desc",
            effects: [.preventNextDamage],
            target: .selfTarget,
            rarity: .rare
        ),

        // MARK: - Phase 5 — New Common Potions
        PotionTemplate(
            id: "dexterity_potion",
            nameKey: "potion_dexterity_potion",
            descriptionKey: "potion_dexterity_potion_desc",
            effects: [.applyBuff(.dexterity, stacks: 2)],
            target: .selfTarget,
            rarity: .common
        ),

        // MARK: - Phase 5 — New Uncommon Potions
        PotionTemplate(
            id: "power_potion",
            nameKey: "potion_power_potion",
            descriptionKey: "potion_power_potion_desc",
            effects: [.applyFocus(2)],
            target: .selfTarget,
            rarity: .uncommon
        ),
        PotionTemplate(
            id: "poison_potion",
            nameKey: "potion_poison_potion",
            descriptionKey: "potion_poison_potion_desc",
            effects: [.applyDebuff(.poison, stacks: 12)],
            target: .enemy,
            rarity: .uncommon
        ),
        PotionTemplate(
            id: "buffer_potion",
            nameKey: "potion_buffer_potion",
            descriptionKey: "potion_buffer_potion_desc",
            effects: [.preventNextDamage, .gainBlock(3)],
            target: .selfTarget,
            rarity: .uncommon
        ),

        // MARK: - Phase 5 — New Rare Potions
        PotionTemplate(
            id: "genocide_potion",
            nameKey: "potion_genocide_potion",
            descriptionKey: "potion_genocide_potion_desc",
            effects: [.dealDamageToAll(40)],
            target: .allEnemies,
            rarity: .rare
        ),
        PotionTemplate(
            id: "ambrosia_potion",
            nameKey: "potion_ambrosia_potion",
            descriptionKey: "potion_ambrosia_potion_desc",
            effects: [.gainBlock(999)],
            target: .selfTarget,
            rarity: .rare
        )
    ]

    static func randomPotion(rarity: CardRarity? = nil) -> PotionTemplate {
        var pool = allPotions
        if let rarity {
            pool = pool.filter { $0.rarity == rarity }
        }
        return pool.randomElement() ?? allPotions[0]
    }
}
