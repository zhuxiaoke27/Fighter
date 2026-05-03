//
//  TutorialOverlay.swift
//  Fighter
//

import SwiftUI

struct TutorialOverlay: View {
    let text: String
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .onTapGesture { onDismiss() }

            VStack(spacing: 20) {
                Image(systemName: "lightbulb.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Theme.energyColor)

                Text(text)
                    .font(.system(size: 16, weight: .medium, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)

                Text(String(localized: "label_tap_to_continue"))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
            }
        }
    }
}
