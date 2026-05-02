//
//  EnergyView.swift
//  Fighter
//

import SwiftUI

struct EnergyView: View {
    let current: Int

    var body: some View {
        ZStack {
            // Outer glow ring
            Circle()
                .stroke(Theme.energyColor.opacity(0.25), lineWidth: 2)
                .frame(width: 44, height: 44)

            // Main orb
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Theme.energyColor.opacity(0.95),
                            Theme.energyColor.opacity(0.6),
                            Theme.energyColor.opacity(0.3)
                        ],
                        center: .center,
                        startRadius: 2,
                        endRadius: 20
                    )
                )
                .frame(width: 40, height: 40)
                .shadow(color: Theme.energyGlow, radius: 8)
                .shadow(color: Theme.energyGlow.opacity(0.3), radius: 16)

            // Highlight
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.3), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 14
                    )
                )
                .frame(width: 36, height: 36)
                .offset(y: -2)

            Text("\(current)")
                .font(Theme.energyFont)
                .foregroundStyle(Color(red: 0.12, green: 0.08, blue: 0.0))
                .shadow(color: .white.opacity(0.3), radius: 1)
        }
    }
}
