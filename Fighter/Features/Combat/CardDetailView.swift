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

                Image(systemName: typeIcon)
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
                    Spacer()
                    Text(rarityLabel)
                        .font(.system(size: 11, weight: .bold, design: .rounded))
                        .foregroundStyle(rarityColor)
                }

                HStack(spacing: 4) {
                    Image(systemName: typeIcon)
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
                        if card.isExhaust { tagView("Exhaust", color: .orange) }
                        if card.isEthereal { tagView("Ethereal", color: .purple) }
                        if card.isInnate { tagView("Innate", color: Theme.energyColor) }
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

    private var typeIcon: String {
        switch card.type {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }

    private var typeLabel: String {
        switch card.type {
        case .attack: return "Attack"
        case .skill:  return "Skill"
        case .power:  return "Power"
        case .status: return "Status"
        case .curse:  return "Curse"
        }
    }

    private var targetLabel: String {
        switch card.target {
        case .enemy:       return "Single Enemy"
        case .allEnemies:  return "All Enemies"
        case .selfTarget:  return "Self"
        case .none:        return "None"
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
        case .starter:  return "Starter"
        case .common:   return "Common"
        case .uncommon: return "Uncommon"
        case .rare:     return "Rare"
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
        case .dealDamage(let n):              return "Deal \(n) damage"
        case .dealDamageMulti(let n, let h):  return "Deal \(n) damage \(h)x"
        case .dealDamageToAll(let n):         return "Deal \(n) damage to all"
        case .gainBlock(let n):               return "Gain \(n) block"
        case .applyBuff(let t, let s):        return "Gain \(s) \(buffName(t))"
        case .applyBuffToAll(let t, let s):   return "All gain \(s) \(buffName(t))"
        case .applyDebuff(let t, let s):      return "Apply \(s) \(buffName(t))"
        case .applyDebuffToAll(let t, let s): return "Apply \(s) \(buffName(t)) to all"
        case .drawCards(let n):               return "Draw \(n) cards"
        case .discardCards(let n):            return "Discard \(n) cards"
        case .exhaustFromHand:                return "Exhaust"
        case .exhaustRandomFromHand(let n):   return "Exhaust \(n) random card(s)"
        case .returnFromDiscard(let n):       return "Return \(n) from discard"
        case .gainEnergy(let n):              return "Gain \(n) energy"
        case .gainEnergyNextTurn(let n):      return "Gain \(n) energy next turn"
        case .heal(let n):                    return "Heal \(n) HP"
        case .addCardToHand(let k):           return "Add \(k) to hand"
        case .addCardToDiscard(let k):        return "Add \(k) to discard"
        case .addCardToDrawPile(let k):       return "Add \(k) to draw pile"
        case .removeFromCombat:               return "Remove from combat"
        case .ifHasDebuff(_, let e):          return e.map { effectDescription($0) }.joined(separator: " + ") + " (if debuffed)"
        case .ifHPBelow(_, let e):            return e.map { effectDescription($0) }.joined(separator: " + ") + " (if low HP)"
        case .ifCardInHand(_, let e):         return e.map { effectDescription($0) }.joined(separator: " + ") + " (if card in hand)"
        case .doubleStrength:                   return "Double strength"
        case .doublePoison:                     return "Double poison on target"
        case .duplicateNextSkill:               return "Next skill plays twice"
        case .damageEqualToBlock:               return "Deal damage equal to block"
        case .healOnKill(let n):                return "Heal \(n) on kill"
        case .applyFrost(let n):                return "Gain \(n) Frost"
        case .applyDark(let n):                 return "Gain \(n) Dark"
        case .applyFocus(let n):                return "Gain \(n) Focus"
        case .preventNextDamage:                return "Block next attack"
        case .doubleNextCard:                   return "Next card plays twice"
        case .randomEnemyDamage(let n):         return "Deal \(n) to random enemy"
        case .composite(let effects):         return effects.map { effectDescription($0) }.joined(separator: " + ")
        }
    }

    private func buffName(_ type: BuffType) -> String {
        switch type {
        case .strength:     return "Strength"
        case .dexterity:    return "Dexterity"
        case .vulnerable:   return "Vulnerable"
        case .weak:         return "Weak"
        case .frail:        return "Frail"
        case .poison:       return "Poison"
        case .metallicize:  return "Metallicize"
        case .barricade:    return "Barricade"
        case .artifact:     return "Artifact"
        case .regenerate:   return "Regenerate"
        case .platedArmor:  return "Plated Armor"
        case .thorns:       return "Thorns"
        case .drawModifier: return "Draw+"
        case .burn:         return "Burn"
        case .frost:    return "Frost"
        case .dark:     return "Dark"
        case .focus:    return "Focus"
        case .negate:   return "Negate"
        }
    }
}
