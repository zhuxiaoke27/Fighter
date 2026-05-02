//
//  DeckView.swift
//  Fighter
//

import SwiftUI

struct DeckView: View {
    let deck: [Card]
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTag: CardTag? = nil

    private var filteredDeck: [Card] {
        var cards = deck
        if let selectedTag {
            cards = cards.filter { $0.tags.contains(selectedTag) }
        }
        return cards.sorted { lhs, rhs in
            if lhs.type.rawValue != rhs.type.rawValue {
                return lhs.type.rawValue < rhs.type.rawValue
            }
            if lhs.cost != rhs.cost { return lhs.cost < rhs.cost }
            return lhs.nameKey < rhs.nameKey
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.10, green: 0.08, blue: 0.18),
                    Color(red: 0.06, green: 0.05, blue: 0.10)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                deckHeader
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                tagFilterBar
                    .padding(.bottom, 8)

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 8),
                        GridItem(.flexible(), spacing: 8)
                    ], spacing: 8) {
                        ForEach(filteredDeck) { card in
                            DeckCardRow(card: card)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
    }

    private var deckHeader: some View {
        HStack {
            Text(String(localized: "label_deck"))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)

            Text("\(filteredDeck.count)/\(deck.count)")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, Theme.padding)
    }

    private var tagFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                tagChip(label: "All", isSelected: selectedTag == nil) {
                    selectedTag = nil
                }
                ForEach(Array(CardTag.allCases.enumerated()), id: \.offset) { _, tag in
                    tagChip(label: tagLabel(tag), isSelected: selectedTag == tag) {
                        selectedTag = selectedTag == tag ? nil : tag
                    }
                }
            }
            .padding(.horizontal, Theme.padding)
        }
    }

    private func tagChip(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundStyle(isSelected ? Theme.textPrimary : Theme.textSecondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(isSelected ? Theme.energyColor.opacity(0.25) : Color.white.opacity(0.05))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Theme.energyColor.opacity(0.5) : Color.white.opacity(0.08), lineWidth: 0.5)
                )
        }
        .buttonStyle(.plain)
    }

    private func tagLabel(_ tag: CardTag) -> String {
        switch tag {
        case .exhaust: return "Exhaust"
        case .strength: return "STR"
        case .poison: return "Poison"
        case .energy: return "Energy"
        case .block: return "Block"
        case .draw: return "Draw"
        case .multiHit: return "Multi"
        case .selfDamage: return "Self"
        case .cardGen: return "Generate"
        case .starter: return "Starter"
        case .offensive: return "ATK"
        case .defensive: return "DEF"
        case .utility: return "Util"
        }
    }
}

struct DeckCardRow: View {
    let card: Card

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: cardTypeIcon)
                .font(.system(size: 12))
                .frame(width: 24, height: 24)
                .background(cardTypeColor.opacity(0.15))
                .foregroundStyle(cardTypeColor)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                    .lineLimit(1)

                HStack(spacing: 4) {
                    Image(systemName: "bolt.fill")
                        .font(.system(size: 8))
                        .foregroundStyle(Theme.energyColor)
                    Text("\(card.cost)")
                        .font(.system(size: 10, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }
            }

            Spacer()

            if card.isUpgraded {
                Text("+")
                    .font(.system(size: 10, weight: .bold, design: .rounded))
                    .foregroundStyle(.green)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.04))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(cardTypeColor.opacity(0.2), lineWidth: 0.5)
                )
        )
    }

    private var cardTypeColor: Color {
        switch card.type {
        case .attack: return Color(red: 0.90, green: 0.35, blue: 0.30)
        case .skill: return Color(red: 0.30, green: 0.58, blue: 0.88)
        case .power: return Color(red: 0.65, green: 0.40, blue: 0.90)
        case .status: return Color.gray
        case .curse: return Color(red: 0.60, green: 0.20, blue: 0.20)
        }
    }

    private var cardTypeIcon: String {
        switch card.type {
        case .attack: return "sword.fill"
        case .skill: return "shield.fill"
        case .power: return "sparkles"
        case .status: return "circle.fill"
        case .curse: return "xmark"
        }
    }
}
