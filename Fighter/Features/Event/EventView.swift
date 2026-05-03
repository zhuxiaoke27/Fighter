//
//  EventView.swift
//  Fighter
//

import SwiftUI

struct EventView: View {
    @Environment(GameStore.self) private var store
    @State private var resultMessage: String? = nil
    @State private var resultColor: Color = .white

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.08, blue: 0.18),
                    Color(red: 0.08, green: 0.05, blue: 0.12)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if let event = store.currentEvent {
                VStack(spacing: 0) {
                    Spacer()

                    // Event icon
                    Image(systemName: event.icon)
                        .font(.system(size: 48, weight: .medium))
                        .foregroundStyle(eventIconColor(for: event.id))
                        .shadow(color: eventIconColor(for: event.id).opacity(0.4), radius: 12)
                        .padding(.bottom, 16)

                    Text(String(localized: LocalizedStringResource(stringLiteral: event.titleKey)))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)

                    Text(String(localized: LocalizedStringResource(stringLiteral: event.descriptionKey)))
                        .font(.system(size: 14, weight: .regular, design: .rounded))
                        .foregroundStyle(Theme.textAccent)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 8)

                    Spacer()

                    if let msg = resultMessage {
                        Text(msg)
                            .font(.system(size: 16, weight: .bold, design: .rounded))
                            .foregroundStyle(resultColor)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black.opacity(0.4))
                                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(resultColor.opacity(0.3), lineWidth: 1))
                            )
                            .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    if resultMessage != nil {
                        Button {
                            store.completeEvent()
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "arrow.right")
                                Text(String(localized: "btn_continue"))
                                    .font(Theme.buttonFont)
                            }
                            .foregroundStyle(.white)
                            .padding(.horizontal, 36)
                            .padding(.vertical, 14)
                            .background(Theme.buttonPrimaryGradient)
                            .clipShape(Capsule())
                            .shadow(color: Color(red: 0.30, green: 0.58, blue: 0.88).opacity(0.35), radius: 8, y: 3)
                        }
                        .buttonStyle(.plain)
                        .padding(.top, 16)
                    } else {
                        VStack(spacing: 12) {
                            ForEach(event.choices) { choice in
                                Button {
                                    resolveChoice(choice)
                                } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "arrow.right.circle")
                                        .font(.system(size: 14))
                                    Text(String(localized: LocalizedStringResource(stringLiteral: choice.textKey)))
                                        .font(.system(size: 14, weight: .medium, design: .rounded))
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                    effectPreviewTags(for: choice.effects)
                                }
                                .foregroundStyle(Theme.textPrimary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                                        .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color(red: 0.45, green: 0.55, blue: 0.90).opacity(0.2), lineWidth: 1)
                                )
                            }
                            .buttonStyle(.plain)
                            .disabled(!canAfford(choice))
                            .opacity(canAfford(choice) ? 1.0 : 0.4)
                        }
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 16)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
    }

    // MARK: - Effect Preview

    @ViewBuilder
    private func effectPreviewTags(for effects: [EventEffect]) -> some View {
        HStack(spacing: 4) {
            ForEach(previewTags(for: effects), id: \.0) { tag in
                Text(tag.0)
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(tag.1)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(tag.1.opacity(0.15)))
            }
        }
    }

    private func previewTags(for effects: [EventEffect]) -> [(String, Color)] {
        var tags: [(String, Color)] = []
        for effect in effects {
            switch effect {
            case .loseHP(let v):    tags.append((String(localized: "tag_lose_hp \(v)"), Color(red: 0.95, green: 0.30, blue: 0.20)))
            case .gainHP(let v):    tags.append((String(localized: "tag_gain_hp \(v)"), Color(red: 0.30, green: 0.85, blue: 0.40)))
            case .gainGold(let v):  tags.append((String(localized: "tag_gain_gold \(v)"), Color(red: 1.0, green: 0.85, blue: 0.30)))
            case .loseGold(let v):  tags.append((String(localized: "tag_lose_gold \(v)"), Color(red: 0.85, green: 0.65, blue: 0.20)))
            case .gainMaxHP(let v): tags.append((String(localized: "tag_gain_maxhp \(v)"), Color(red: 0.30, green: 0.85, blue: 0.40)))
            case .loseMaxHP(let v): tags.append((String(localized: "tag_lose_maxhp \(v)"), Color(red: 0.95, green: 0.30, blue: 0.20)))
            case .gainStrength(let v): tags.append((String(localized: "tag_gain_str \(v)"), Color(red: 0.90, green: 0.45, blue: 0.30)))
            case .gainDexterity(let v): tags.append((String(localized: "tag_gain_dex \(v)"), Color(red: 0.30, green: 0.75, blue: 0.90)))
            case .gainRandomRelic:  tags.append((String(localized: "tag_relic"), Color(red: 0.70, green: 0.50, blue: 0.90)))
            case .gainRandomPotion: tags.append((String(localized: "tag_potion"), Color(red: 0.40, green: 0.80, blue: 0.50)))
            case .gainRelic:        tags.append((String(localized: "tag_relic"), Color(red: 0.70, green: 0.50, blue: 0.90)))
            case .gainPotion:       tags.append((String(localized: "tag_potion"), Color(red: 0.40, green: 0.80, blue: 0.50)))
            case .upgradeRandomCard: tags.append((String(localized: "tag_upgrade"), Theme.energyColor))
            case .upgradeRandomCards(let v): tags.append((String(localized: "tag_upgrade_n \(v)"), Theme.energyColor))
            case .removeRandomCard: tags.append((String(localized: "tag_remove"), Color(red: 0.90, green: 0.30, blue: 0.25)))
            case .addCardToDeck:    tags.append((String(localized: "tag_add_card"), Theme.energyColor))
            case .healPercent(let v): tags.append((String(localized: "tag_heal_pct \(Int(v * 100))"), v >= 0 ? Color(red: 0.30, green: 0.85, blue: 0.40) : Color(red: 0.95, green: 0.30, blue: 0.20)))
            case .randomDebuff:     tags.append((String(localized: "tag_debuff"), Color(red: 0.90, green: 0.30, blue: 0.25)))
            case .transformRandomStrike: tags.append((String(localized: "tag_transform"), Theme.energyColor))
            case .duplicateRandomCard: tags.append((String(localized: "tag_copy"), Theme.energyColor))
            case .removeAllStrikes: tags.append((String(localized: "tag_no_strikes"), Color(red: 0.90, green: 0.30, blue: 0.25)))
            case .gainEnergyNextCombat(let v): tags.append((String(localized: "tag_gain_energy \(v)"), Theme.energyColor))
            case .gainBlockPermanent(let v): tags.append((String(localized: "tag_gain_armor \(v)"), Color(red: 0.30, green: 0.70, blue: 0.90)))
            case .gainGoldPerCard(let v): tags.append((String(localized: "tag_gold_per_card \(v)"), Color(red: 1.0, green: 0.85, blue: 0.30)))
            case .nothing: break
            case .removeSpecificCard: tags.append((String(localized: "tag_remove"), Color(red: 0.90, green: 0.30, blue: 0.25)))
            }
        }
        return tags
    }

    private func eventIconColor(for id: String) -> Color {
        if id.contains("dark") || id.contains("shadow") || id.contains("abyss") || id.contains("soul") || id.contains("curse") || id.contains("doom") || id.contains("fallen") || id.contains("cursed") || id.contains("snake") {
            return Color(red: 0.70, green: 0.30, blue: 0.85)
        }
        if id.contains("shrine") || id.contains("altar") || id.contains("forge") || id.contains("rune") || id.contains("throne") || id.contains("guardian") {
            return Color(red: 0.90, green: 0.70, blue: 0.30)
        }
        if id.contains("merchant") || id.contains("trader") || id.contains("shop") || id.contains("gambl") || id.contains("gold") || id.contains("trade") || id.contains("flower") || id.contains("smith") || id.contains("wheel") || id.contains("exchange") {
            return Color(red: 1.0, green: 0.85, blue: 0.30)
        }
        if id.contains("ghost") || id.contains("spirit") || id.contains("music") || id.contains("ferry") || id.contains("ship") {
            return Color(red: 0.50, green: 0.70, blue: 0.90)
        }
        return Color(red: 0.45, green: 0.55, blue: 0.90)
    }

    // MARK: - Resolve Choice

    private func canAfford(_ choice: EventChoice) -> Bool {
        for effect in choice.effects {
            if case .loseGold(let amount) = effect {
                if store.player.gold < amount { return false }
            }
        }
        return true
    }

    private func resolveChoice(_ choice: EventChoice) {
        // Pre-validate gold costs
        guard canAfford(choice) else {
            resultMessage = String(localized: "event_result_not_enough_gold")
            resultColor = Color(red: 0.95, green: 0.30, blue: 0.20)
            return
        }

        var results: [String] = []
        let player = store.player

        for effect in choice.effects {
            switch effect {
            case .loseHP(let amount):
                player.currentHP = max(0, player.currentHP - amount)
                results.append(String(localized: "event_result_lose_hp \(amount)"))
                if player.currentHP <= 0 {
                    store.endRun(victory: false)
                    return
                }
            case .gainHP(let amount):
                let healed = min(amount, player.maxHP - player.currentHP)
                player.currentHP += healed
                results.append(String(localized: "event_result_gain_hp \(healed)"))
            case .gainGold(let amount):
                player.gold += amount
                results.append(String(localized: "event_result_gain_gold \(amount)"))
            case .loseGold(let amount):
                player.gold -= amount
                results.append(String(localized: "event_result_lose_gold \(amount)"))
            case .gainMaxHP(let amount):
                player.maxHP += amount
                player.currentHP += amount
                results.append(String(localized: "event_result_gain_maxhp \(amount)"))
            case .loseMaxHP(let amount):
                player.maxHP = max(1, player.maxHP - amount)
                player.currentHP = min(player.currentHP, player.maxHP)
                results.append(String(localized: "event_result_lose_maxhp \(amount)"))
            case .addCardToDeck(let templateKey):
                if let card = CardDatabase.card(byKey: templateKey) {
                    player.deck.append(card.copy())
                    CombatEngine.triggerOnCardAdded(store: store)
                    results.append(String(localized: "event_result_card_added"))
                }
            case .removeRandomCard:
                if !player.deck.isEmpty {
                    player.deck.remove(at: Int.random(in: 0..<player.deck.count))
                    results.append(String(localized: "event_result_card_removed"))
                }
            case .removeSpecificCard(let templateKey):
                if let idx = player.deck.firstIndex(where: { $0.templateKey == templateKey }) {
                    player.deck.remove(at: idx)
                    results.append(String(localized: "event_result_card_removed"))
                }
            case .upgradeRandomCard:
                let upgradable = player.deck.indices.filter { !player.deck[$0].isUpgraded }
                if let idx = upgradable.randomElement() {
                    player.deck[idx] = player.deck[idx].withUpgrade()
                    results.append(String(localized: "event_result_card_upgraded"))
                }
            case .upgradeRandomCards(let count):
                var upgraded = 0
                for _ in 0..<count {
                    let upgradable = player.deck.indices.filter { !player.deck[$0].isUpgraded }
                    if let idx = upgradable.randomElement() {
                        player.deck[idx] = player.deck[idx].withUpgrade()
                        upgraded += 1
                    }
                }
                if upgraded > 0 { results.append(String(localized: "event_result_cards_upgraded \(upgraded)")) }
            case .gainStrength(let amount):
                player.permanentStrengthBonus += amount
                results.append(String(localized: "event_result_gain_strength \(amount)"))
            case .gainDexterity(let amount):
                player.permanentDexterityBonus += amount
                results.append(String(localized: "event_result_gain_dexterity \(amount)"))
            case .gainBlockPermanent(let amount):
                player.permanentBlockBonus += amount
                results.append(String(localized: "event_result_gain_block \(amount)"))
            case .healPercent(let percent):
                if percent >= 0 {
                    let amount = Int(Double(player.maxHP) * percent)
                    let healed = min(amount, player.maxHP - player.currentHP)
                    player.currentHP += healed
                    results.append(String(localized: "event_result_gain_hp \(healed)"))
                } else {
                    let targetHP = Int(Double(player.maxHP) * -percent)
                    let damage = player.currentHP - max(1, player.currentHP - targetHP)
                    player.currentHP = max(1, player.currentHP - targetHP)
                    results.append(String(localized: "event_result_hp_reduced \(Int((1.0 + percent) * 100))"))
                }
            case .gainRelic(let relicID):
                if let relic = RelicDatabase.allRelics.first(where: { $0.id == relicID }) {
                    player.relics.append(relic)
                    results.append(String(localized: "event_result_relic_acquired"))
                }
            case .gainRandomRelic:
                let relic = RelicDatabase.randomRelic(excluding: player.relics)
                player.relics.append(relic)
                results.append(String(localized: "event_result_random_relic"))
            case .gainPotion(let potionID):
                if let potion = PotionDatabase.allPotions.first(where: { $0.id == potionID }) {
                    store.receivePotion(potion)
                    results.append(String(localized: "event_result_potion_acquired"))
                }
            case .gainRandomPotion:
                let potion = PotionDatabase.randomPotion()
                store.receivePotion(potion)
                results.append(String(localized: "event_result_random_potion"))
            case .randomDebuff:
                let debuffs: [BuffType] = [.vulnerable, .weak, .frail]
                if let debuff = debuffs.randomElement() {
                    player.addBuff(BuffInstance(type: debuff, stacks: 2, isDurationBased: true))
                    results.append(String(localized: "event_result_debuffed"))
                }
            case .transformRandomStrike:
                if let idx = player.deck.firstIndex(where: { $0.templateKey.contains("strike") }) {
                    let attackCards = CardDatabase.allCards.filter { $0.type == .attack && $0.rarity != .starter && ($0.characterClass == player.characterClass || $0.characterClass == nil) }
                    if let newCard = attackCards.randomElement() {
                        player.deck[idx] = newCard.copy()
                        results.append(String(localized: "event_result_strike_transformed"))
                    }
                }
            case .duplicateRandomCard:
                if !player.deck.isEmpty {
                    let idx = Int.random(in: 0..<player.deck.count)
                    player.deck.append(player.deck[idx].copy())
                    CombatEngine.triggerOnCardAdded(store: store)
                    results.append(String(localized: "event_result_card_duplicated"))
                }
            case .removeAllStrikes:
                let before = player.deck.count
                player.deck.removeAll { $0.templateKey.contains("strike") }
                let removed = before - player.deck.count
                if removed > 0 { results.append(String(localized: "event_result_strikes_removed \(removed)")) }
            case .gainEnergyNextCombat(let amount):
                player.energyNextTurnBonus += amount
                results.append(String(localized: "event_result_energy_next \(amount)"))
            case .gainGoldPerCard(let amount):
                let gold = player.deck.count * amount
                player.gold += gold
                results.append(String(localized: "event_result_gain_gold \(gold)"))
            case .nothing:
                break
            }
        }

        // Accumulated death check after all effects
        if store.player.currentHP <= 0 {
            store.endRun(victory: false)
            return
        }

        if results.isEmpty {
            store.completeEvent()
        } else {
            let msg = results.joined(separator: ", ")
            resultColor = results.contains(where: { $0.hasPrefix("-") }) ? Color(red: 0.95, green: 0.60, blue: 0.40) : Color(red: 0.30, green: 0.85, blue: 0.50)
            withAnimation(.spring(response: 0.3)) {
                resultMessage = msg
            }
        }
    }
}
