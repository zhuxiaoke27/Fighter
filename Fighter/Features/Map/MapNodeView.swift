//
//  MapNodeView.swift
//  Fighter
//

import SwiftUI

struct MapNodeView: View {
    let node: MapNode
    let isCurrentFloor: Bool
    let onTap: () -> Void

    @State private var pulse = false

    init(node: MapNode, isCurrentFloor: Bool = false, onTap: @escaping () -> Void) {
        self.node = node
        self.isCurrentFloor = isCurrentFloor
        self.onTap = onTap
    }

    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Current floor pulsing ring
                if isCurrentFloor && node.isAccessible && !node.isVisited {
                    Circle()
                        .stroke(typeColor.opacity(0.3), lineWidth: 3)
                        .frame(width: 52, height: 52)
                        .scaleEffect(pulse ? 1.15 : 1.0)
                        .opacity(pulse ? 0.6 : 0.2)
                }

                Circle()
                    .fill(backgroundColor)
                    .frame(width: 44, height: 44)
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: borderWidth)
                    )
                    .shadow(color: shadowColor, radius: shadowRadius)

                if node.isVisited {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Theme.textSecondary)
                } else {
                    Image(systemName: node.type.iconName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(iconColor)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(!node.isAccessible || node.isVisited)
        .onAppear {
            if isCurrentFloor && node.isAccessible && !node.isVisited {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }

    private var backgroundColor: Color {
        if node.isVisited {
            return Color(red: 0.12, green: 0.11, blue: 0.18)
        } else if node.isAccessible {
            return typeColor.opacity(0.25)
        } else {
            return Color(red: 0.10, green: 0.09, blue: 0.15)
        }
    }

    private var borderColor: Color {
        if node.isVisited {
            return Color.white.opacity(0.06)
        } else if node.isAccessible {
            return typeColor.opacity(0.7)
        } else {
            return Color.white.opacity(0.04)
        }
    }

    private var borderWidth: CGFloat {
        node.isAccessible && !node.isVisited ? 2 : 1
    }

    private var shadowColor: Color {
        node.isAccessible && !node.isVisited ? typeColor.opacity(0.4) : .clear
    }

    private var shadowRadius: CGFloat {
        node.isAccessible && !node.isVisited ? 8 : 0
    }

    private var iconColor: Color {
        node.isAccessible ? typeColor : Theme.textSecondary.opacity(0.3)
    }

    private var typeColor: Color {
        switch node.type {
        case .battle:     return Color(red: 0.90, green: 0.30, blue: 0.25)
        case .hardBattle: return Color(red: 0.95, green: 0.50, blue: 0.15)
        case .elite:      return Theme.energyColor
        case .boss:       return Color(red: 0.70, green: 0.35, blue: 0.90)
        case .restSite:   return Color(red: 0.30, green: 0.72, blue: 0.42)
        case .shop:       return Color(red: 0.25, green: 0.70, blue: 0.50)
        case .event:      return Color(red: 0.45, green: 0.55, blue: 0.90)
        case .mystery:    return Theme.textSecondary
        }
    }
}
