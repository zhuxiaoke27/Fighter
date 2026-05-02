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
        .modifier(CardShadow(isSelected: isSelected))
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
            // Background gradient by type
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
                .frame(height: 48)

            // Type icon in center
            Image(systemName: typeIcon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Theme.cardColor(for: card.type).opacity(0.6))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.top, 2)

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

                    Text(card.cost >= 0 ? "\(card.cost)" : "X")
                        .font(Theme.cardCostFont)
                        .foregroundStyle(Color(red: 0.15, green: 0.10, blue: 0.0))
                }
                Spacer()
            }
            .padding(4)
        }
    }

    private var typeIcon: String {
        switch card.type {
        case .attack: return "sword"
        case .skill:  return "shield"
        case .power:  return "bolt.fill"
        case .status: return "exclamationmark.triangle"
        case .curse:  return "flame"
        }
    }

    @ViewBuilder
    private var borderOverlay: some View {
        if isSelected {
            RoundedRectangle(cornerRadius: Theme.cardCornerRadius)
                .stroke(Theme.energyColor, lineWidth: 2)
                .shadow(color: Theme.energyGlow, radius: 6)
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
