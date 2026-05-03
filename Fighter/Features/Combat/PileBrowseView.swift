//
//  PileBrowseView.swift
//  Fighter
//

import SwiftUI

enum PileType: String, Identifiable {
    case draw, discard, exhaust
    var id: String { rawValue }
}

struct PileBrowseView: View {
    let pileType: PileType
    let cards: [Card]
    @Environment(\.dismiss) private var dismiss
    @State private var detailCard: Card? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                if cards.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "rectangle.stack")
                            .font(.system(size: 36))
                            .foregroundStyle(Theme.textSecondary.opacity(0.3))
                        Text(String(localized: "label_pile_empty"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                            .foregroundStyle(Theme.textSecondary)
                    }
                    .padding(.top, 80)
                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(cards) { card in
                            Button {
                                detailCard = card
                            } label: {
                                pileCardView(card)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                }
            }
            .background(Theme.background)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(String(localized: "btn_done")) { dismiss() }
                        .foregroundStyle(Theme.energyColor)
                }
            }
        }
        .overlay {
            if let card = detailCard {
                CardDetailView(card: card) {
                    detailCard = nil
                }
            }
        }
    }

    private var title: String {
        switch pileType {
        case .draw:    return String(localized: "label_draw_pile")
        case .discard: return String(localized: "label_discard_pile")
        case .exhaust: return String(localized: "label_exhaust_pile")
        }
    }

    private func pileCardView(_ card: Card) -> some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Theme.cardColor(for: card.type).opacity(0.2))
                    .frame(height: 40)

                Image(systemName: typeIcon(for: card.type))
                    .font(.system(size: 16))
                    .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.5))

                VStack {
                    HStack {
                        Text(card.cost >= 0 ? "\(card.cost)" : "X")
                            .font(.system(size: 9, weight: .heavy, design: .rounded))
                            .foregroundStyle(Color(red: 0.15, green: 0.10, blue: 0.0))
                            .frame(width: 16, height: 16)
                            .background(Circle().fill(Theme.energyColor))
                        Spacer()
                    }
                    Spacer()
                }
                .padding(4)
            }

            Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)
                .lineLimit(1)

            if card.isUpgraded {
                Text("+")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(Theme.energyColor)
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.cardColor(for: card.type).opacity(0.2), lineWidth: 0.5)
                )
        )
    }

    private func typeIcon(for type: CardType) -> String {
        switch type {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }
}
