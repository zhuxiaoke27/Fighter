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
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.5).combined(with: .opacity),
                        removal: .scale(scale: 0.8).combined(with: .opacity)
                    ))
                }
            }
            .padding(.horizontal, Theme.padding)
            .animation(.spring(response: 0.35, dampingFraction: 0.75), value: hand.count)
        }
        .frame(height: Theme.cardHeight + 16)
    }
}
