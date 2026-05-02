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
