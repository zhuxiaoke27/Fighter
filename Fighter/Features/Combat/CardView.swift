//
//  CardView.swift
//  Fighter
//

import SwiftUI

struct CardView: View {
    let card: Card
    let isSelected: Bool
    let isPlayable: Bool
    let onTap: () -> Void
    var onLongPress: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            // Art area with type gradient
            artArea

            // Info area
            VStack(spacing: 3) {
                HStack(spacing: 2) {
                    Text(String(localized: LocalizedStringResource(stringLiteral: card.nameKey)))
                        .font(Theme.cardTitleFont)
                        .foregroundStyle(card.isUpgraded ? Theme.energyColor : Theme.textPrimary)
                        .lineLimit(1)
                    if card.isUpgraded {
                        Text("+")
                            .font(.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundStyle(.green)
                    }
                }
                .padding(.horizontal, 6)

                Text(String(localized: LocalizedStringResource(stringLiteral: card.descriptionKey)))
                    .font(Theme.cardDescFont)
                    .foregroundStyle(Theme.textAccent)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 5)
                    .lineLimit(3)
                    .minimumScaleFactor(0.7)
            }
            .padding(.vertical, 6)
            .frame(maxWidth: .infinity)
            .background(
                Rectangle()
                    .fill(Color(red: 0.10, green: 0.09, blue: 0.16))
            )
        }
        .frame(width: Theme.cardWidth, height: Theme.cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: Theme.cardCornerRadius))
        .overlay(borderOverlay)
        .modifier(ShimmerEffect(color: card.rarity == .rare ? Theme.rareGlow : .clear))
        .modifier(CardShadow(isSelected: isSelected, isUpgraded: card.isUpgraded))
        .contentShape(Rectangle())
        .onTapGesture { onTap() }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4)
                .onEnded { _ in onLongPress?() }
        )
        .offset(y: isSelected ? -24 : 0)
        .opacity(isPlayable ? 1.0 : 0.45)
        .scaleEffect(isSelected ? 1.08 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isSelected)
        .animation(.easeOut(duration: 0.15), value: isPlayable)
    }

    // MARK: - Art Area (top section with energy cost)

    private var artArea: some View {
        ZStack(alignment: .topLeading) {
            // Richer multi-stop gradient by type
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .fill(Theme.cardRichGradient(for: card.type))
                .frame(height: 56)

            // Glow overlay at top
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .fill(
                    RadialGradient(
                        colors: [Theme.cardColor(for: card.type).opacity(0.25), .clear],
                        center: .top,
                        startRadius: 0,
                        endRadius: 50
                    )
                )
                .frame(height: 56)

            // Type icon in center
            Image(systemName: card.type.icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.5))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 4)

            // Energy cost orb
            HStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [Theme.energyColor, Theme.energyColor.opacity(0.7)],
                                center: .center,
                                startRadius: 2,
                                endRadius: 12
                            )
                        )
                        .frame(width: 24, height: 24)
                        .shadow(color: Theme.energyGlow, radius: 4)

                    Text(card.cost >= 0 ? "\(card.cost)" : "—")
                        .font(Theme.cardCostFont)
                        .foregroundStyle(Color(red: 0.15, green: 0.10, blue: 0.0))
                }
                Spacer()
            }
            .padding(4)
        }
    }


    @ViewBuilder
    private var borderOverlay: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Theme.energyColor, lineWidth: 2)
                .shadow(color: Theme.energyGlow, radius: 6)
        } else if card.type == .status {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Color(red: 0.90, green: 0.30, blue: 0.25), lineWidth: 1.5)
        } else if card.type == .curse {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Color(red: 0.70, green: 0.35, blue: 0.90), lineWidth: 1.5)
                .shadow(color: Color(red: 0.70, green: 0.35, blue: 0.90).opacity(0.3), radius: 4)
        } else if card.rarity == .rare {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [Theme.rareGlow, Color(red: 0.85, green: 0.65, blue: 0.15), Theme.rareGlow],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
                .shadow(color: Theme.rareGlow.opacity(0.5), radius: 8)
        } else if card.rarity == .uncommon {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [Theme.uncommonGlow.opacity(0.7), Theme.uncommonGlow.opacity(0.3)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
                .shadow(color: Theme.uncommonGlow.opacity(0.15), radius: 4)
        } else if card.rarity == .starter {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        } else if isPlayable {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [Theme.cardColor(for: card.type).opacity(0.5), Theme.cardColor(for: card.type).opacity(0.15)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
        } else {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        }
    }
}
