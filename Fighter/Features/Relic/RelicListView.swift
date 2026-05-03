//
//  RelicListView.swift
//  Fighter
//

import SwiftUI

struct RelicListView: View {
    let relics: [RelicTemplate]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color(red: 0.10, green: 0.08, blue: 0.18)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding(.top, 16)

                if relics.isEmpty {
                    Spacer()
                    Text(String(localized: "label_no_relics"))
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack(spacing: 8) {
                            ForEach(relics, id: \.id) { relic in
                                relicRow(relic)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                }
            }
        }
    }

    private var header: some View {
        HStack {
            Image(systemName: "gem")
                .font(.system(size: 14))
                .foregroundStyle(Color(red: 0.70, green: 0.50, blue: 0.90))
            Text(String(localized: "label_relics_count \(relics.count)"))
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundStyle(Theme.textPrimary)

            Spacer()

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Theme.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 8)
    }

    private func relicRow(_ relic: RelicTemplate) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "gem")
                .font(.system(size: 18))
                .foregroundStyle(Color(red: 0.70, green: 0.50, blue: 0.90))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(Color(red: 0.70, green: 0.50, blue: 0.90).opacity(0.12))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(String(localized: LocalizedStringResource(stringLiteral: relic.nameKey)))
                    .font(.system(size: 14, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)

                Text(String(localized: LocalizedStringResource(stringLiteral: relic.descriptionKey)))
                    .font(.system(size: 12, weight: .regular, design: .rounded))
                    .foregroundStyle(Theme.textSecondary)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.14, green: 0.13, blue: 0.22))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.70, green: 0.50, blue: 0.90).opacity(0.15), lineWidth: 1)
        )
    }
}
