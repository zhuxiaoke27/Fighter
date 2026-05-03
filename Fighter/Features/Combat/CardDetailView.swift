//
//  CardDetailView.swift
//  Fighter
//

import SwiftUI

struct CardDetailView: View {
    let card: Card
    let onClose: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture { onClose() }

            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Button { onClose() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Theme.textSecondary)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 60)

                enlargedCard

                Spacer()
            }
        }
    }

    private var enlargedCard: some View {
        VStack(spacing: 0) {
            // Art area
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.cardColor(for: card.type).opacity(0.35),
                                Theme.cardColor(for: card.type).opacity(0.10),
                                Color(red: 0.10, green: 0.09, blue: 0.16)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 80)

                Image(systemName: card.type.icon)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.6))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                HStack(spacing: 0) {
                    ZStack {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [Theme.energyColor, Theme.energyColor.opacity(0.7)],
                                    center: .center,
                                    startRadius: 2,
                                    endRadius: 16
                                )
                            )
                            .frame(width: 32, height: 32)
                            .shadow(color: Theme.energyGlow, radius: 4)
                        Text(card.cost >= 0 ? "\(card.cost)" : "—")
                            .font(Theme.cardCostFont)
                            .foregroundStyle(Color(red: 0.15, green: 0.10, blue: 0.0))
                    }
                    Spacer()
                }
                .padding(8)
            }

            // Info section
            VStack(spacing: 8) {
                HStack {
                    Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    if card.isUpgraded {
                        Text(String(localized: "label_upgraded"))
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundStyle(Theme.energyColor)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Theme.energyColor.opacity(0.15)))
                    }
                    Spacer()
                    Text(rarityLabel)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(rarityColor)
                }

                HStack(spacing: 4) {
                    Image(systemName: card.type.icon)
                        .font(.system(size: 10))
                    Text(typeLabel)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                }
                .foregroundStyle(Theme.cardColor(for: card.type))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Capsule().fill(Theme.cardColor(for: card.type).opacity(0.15)))

                HStack(spacing: 4) {
                    Image(systemName: targetIcon)
                        .font(.system(size: 10))
                    Text(targetLabel)
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                }
                .foregroundStyle(Theme.textSecondary)

                Text(String(localized: LocalizedStringResource(stringLiteral: card.descriptionKey)))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Theme.textAccent)
                    .multilineTextAlignment(.center)

                if !card.resolvedEffects.isEmpty {
                    Divider().background(Color.white.opacity(0.08))
                    VStack(spacing: 4) {
                        ForEach(Array(card.resolvedEffects.enumerated()), id: \.offset) { _, effect in
                            Text(effectDescription(effect))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }

                if card.isExhaust || card.isEthereal || card.isInnate {
                    HStack(spacing: 6) {
                        if card.isExhaust { tagView(String(localized: "tag_exhaust"), color: .orange) }
                        if card.isEthereal { tagView(String(localized: "tag_ethereal"), color: .purple) }
                        if card.isInnate { tagView(String(localized: "tag_innate"), color: Theme.energyColor) }
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Rectangle().fill(Color(red: 0.10, green: 0.09, blue: 0.16)))
        }
        .frame(width: 220)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Theme.cardColor(for: card.type).opacity(0.5), lineWidth: 1.5)
        )
        .shadow(color: Theme.cardColor(for: card.type).opacity(0.3), radius: 16)
        .shadow(color: .black.opacity(0.5), radius: 12, y: 6)
    }

    // MARK: - Helpers


    private var typeLabel: String {
        switch card.type {
        case .attack: return String(localized: "card_type_attack")
        case .skill:  return String(localized: "card_type_skill")
        case .power:  return String(localized: "card_type_power")
        case .status: return String(localized: "card_type_status")
        case .curse:  return String(localized: "card_type_curse")
        }
    }

    private var targetLabel: String {
        switch card.target {
        case .enemy:       return String(localized: "target_single_enemy")
        case .allEnemies:  return String(localized: "target_all_enemies")
        case .selfTarget:  return String(localized: "target_self")
        case .none:        return String(localized: "target_none")
        }
    }

    private var targetIcon: String {
        switch card.target {
        case .enemy:       return "person.crop.circle"
        case .allEnemies:  return "person.3.fill"
        case .selfTarget:  return "person.fill"
        case .none:        return "circle"
        }
    }

    private var rarityLabel: String {
        switch card.rarity {
        case .starter:  return String(localized: "rarity_starter")
        case .common:   return String(localized: "rarity_common")
        case .uncommon: return String(localized: "rarity_uncommon")
        case .rare:     return String(localized: "rarity_rare")
        }
    }

    private var rarityColor: Color {
        switch card.rarity {
        case .starter:  return Theme.textSecondary
        case .common:   return .white.opacity(0.6)
        case .uncommon: return Color(red: 0.30, green: 0.72, blue: 0.42)
        case .rare:     return Theme.energyColor
        }
    }

    private func tagView(_ text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 9, weight: .bold, design: .rounded))
            .foregroundStyle(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Capsule().fill(color.opacity(0.15)))
    }

    private func effectDescription(_ effect: Effect) -> String {
        switch effect {
        case .dealDamage(let n):              return String(localized: "effect_deal_damage \(n)")
        case .dealDamageMulti(let n, let h):  return String(localized: "effect_deal_damage_multi \(n) \(h)")
        case .dealDamageToAll(let n):         return String(localized: "effect_deal_damage_all \(n)")
        case .gainBlock(let n):               return String(localized: "effect_gain_block \(n)")
        case .applyBuff(let t, let s):        return String(localized: "effect_gain_buff \(s) \(buffName(t))")
        case .applyBuffToAll(let t, let s):   return String(localized: "effect_all_gain_buff \(s) \(buffName(t))")
        case .applyDebuff(let t, let s):      return String(localized: "effect_apply_debuff \(s) \(buffName(t))")
        case .applyDebuffToAll(let t, let s): return String(localized: "effect_apply_debuff_all \(s) \(buffName(t))")
        case .drawCards(let n):               return String(localized: "effect_draw_cards \(n)")
        case .discardCards(let n):            return String(localized: "effect_discard_cards \(n)")
        case .exhaustFromHand:                return String(localized: "effect_exhaust")
        case .exhaustRandomFromHand(let n):   return String(localized: "effect_exhaust_random \(n)")
        case .returnFromDiscard(let n):       return String(localized: "effect_return_discard \(n)")
        case .gainEnergy(let n):              return String(localized: "effect_gain_energy \(n)")
        case .gainEnergyNextTurn(let n):      return String(localized: "effect_gain_energy_next \(n)")
        case .heal(let n):                    return String(localized: "effect_heal \(n)")
        case .addCardToHand(let k):           return String(localized: "effect_add_to_hand \(k)")
        case .addCardToDiscard(let k):        return String(localized: "effect_add_to_discard \(k)")
        case .addCardToDrawPile(let k):       return String(localized: "effect_add_to_draw \(k)")
        case .removeFromCombat:               return String(localized: "effect_remove_combat")
        case .ifHasDebuff(_, let e):          return e.map { effectDescription($0) }.joined(separator: " + ") + " (\(String(localized: "effect_cond_debuffed")))"
        case .ifHPBelow(_, let e):            return e.map { effectDescription($0) }.joined(separator: " + ") + " (\(String(localized: "effect_cond_low_hp")))"
        case .ifCardInHand(_, let e):         return e.map { effectDescription($0) }.joined(separator: " + ") + " (\(String(localized: "effect_cond_card_in_hand")))"
        case .doubleStrength:                   return String(localized: "effect_double_strength")
        case .doublePoison:                     return String(localized: "effect_double_poison")
        case .selfDamage(let n):                return String(localized: "effect_self_damage \(n)")
        case .gainMaxHPOnKill(let n):           return String(localized: "effect_gain_maxhp_on_kill \(n)")
        case .damageEqualToBlock:               return String(localized: "effect_damage_equal_block")
        case .healOnKill(let n):                return String(localized: "effect_heal_on_kill \(n)")
        case .applyFrost(let n):                return String(localized: "effect_gain_frost \(n)")
        case .applyDark(let n):                 return String(localized: "effect_gain_dark \(n)")
        case .applyFocus(let n):                return String(localized: "effect_gain_focus \(n)")
        case .preventNextDamage:                return String(localized: "effect_block_next")
        case .doubleNextCard:                   return String(localized: "effect_double_next")
        case .randomEnemyDamage(let n):         return String(localized: "effect_random_damage \(n)")
        case .composite(let effects):         return effects.map { effectDescription($0) }.joined(separator: " + ")
        }
    }

    private func buffName(_ type: BuffType) -> String {
        String(localized: LocalizedStringResource(stringLiteral: type.localizationKey))
    }
}
