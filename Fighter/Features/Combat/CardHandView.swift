//
//  CardHandView.swift
//  Fighter
//

import SwiftUI

struct CardHandView: View {
    let hand: [Card]
    let selectedCardID: String?
    let currentEnergy: Int
    let onCardTap: (Card) -> Void
    var onCardLongPress: ((Card) -> Void)? = nil

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: -12) {
                ForEach(hand) { card in
                    CardView(
                        card: card,
                        isSelected: card.id == selectedCardID,
                        isPlayable: card.cost <= currentEnergy,
                        onTap: { onCardTap(card) },
                        onLongPress: { onCardLongPress?(card) }
                    )
                    .zIndex(card.id == selectedCardID ? 10 : 0)
                }
            }
            .padding(.horizontal, Theme.padding)
        }
        .frame(height: Theme.cardHeight + 16)
    }
}
