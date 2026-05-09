//
//  CharacterSelectView.swift
//  Fighter
//

import SwiftUI

struct CharacterSelectView: View {
    @Environment(GameStore.self) private var store
    @State private var selectedClass: CharacterClass? = nil
    @State private var ascension: AscensionLevel = .none
    @State private var showUnlockBanner: UnlockableContent? = nil
    @State private var showStartConfirm = false

    private var unlockState: UnlockState { UnlockStore.shared.state }

    private func isClassLocked(_ charClass: CharacterClass) -> Bool {
        switch charClass {
        case .warrior: return false
        case .assassin: return !unlockState.isAssassinUnlocked
        case .mage: return !unlockState.isMageUnlocked
        }
    }

    private func lockRequirement(for charClass: CharacterClass) -> UnlockRequirement? {
        switch charClass {
        case .warrior: return nil
        case .assassin: return UnlockableContent.characterAssassin.requirement
        case .mage: return UnlockableContent.characterMage.requirement
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

            VStack(spacing: 20) {
                Text(String(localized: "label_select_character"))
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(Theme.textPrimary)
                    .padding(.top, 32)

                // Class cards — vertical stack for portrait layout
                VStack(spacing: 14) {
                    ForEach(CharacterClass.allCases, id: \.rawValue) { charClass in
                        classCard(for: charClass)
                    }
                }
                .padding(.horizontal, 20)

                Spacer()

                // Ascension selector — only when unlocked
                if unlockState.isAscensionUnlocked {
                    ascensionSelector
                }

                if let selected = selectedClass {
                    Button {
                        showStartConfirm = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "play.fill")
                                .font(.system(size: 14, weight: .semibold))
                            Text(String(localized: "btn_start_run"))
                                .font(Theme.buttonFont)
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [
                                    characterColor(for: selected),
                                    characterColor(for: selected).opacity(0.75)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                        .shadow(color: characterColor(for: selected).opacity(0.4), radius: 10, y: 4)
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 50)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                Button { store.gameState = .menu } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 11))
                        Text(String(localized: "btn_back"))
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(Theme.textSecondary)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 20)
            }
        }
        .alert(String(localized: "confirm_start_run"), isPresented: $showStartConfirm) {
            Button(String(localized: "btn_confirm")) {
                if let selected = selectedClass {
                    HapticManager.impact(.medium)
                    store.ascensionLevel = ascension
                    store.startNewRun(characterClass: selected)
                }
            }
            Button(String(localized: "btn_cancel"), role: .cancel) {}
        }
    }

    // MARK: - Class Card

    private func classCard(for charClass: CharacterClass) -> some View {
        let isSelected = selectedClass == charClass
        let locked = isClassLocked(charClass)

        return Button {
            guard !locked else { return }
            HapticManager.selection()
            withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                selectedClass = charClass
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    characterColor(for: charClass).opacity(isSelected ? 0.6 : 0.3),
                                    characterColor(for: charClass).opacity(0.08)
                                ],
                                center: .center,
                                startRadius: 5,
                                endRadius: 40
                            )
                        )
                        .frame(width: 80, height: 80)
                        .overlay(
                            Circle()
                                .stroke(characterColor(for: charClass).opacity(isSelected ? 0.7 : 0.2), lineWidth: isSelected ? 2.5 : 1)
                        )
                        .shadow(color: isSelected ? characterColor(for: charClass).opacity(0.3) : .clear, radius: isSelected ? 12 : 0)

                    StaticSpriteView(
                        imageName: SpriteAssets.staticFrame(for: charClass),
                        size: 52
                    )
                }
                .scaleEffect(isSelected ? 1.05 : 1.0)

                VStack(alignment: .leading, spacing: 4) {
                    Text(String(localized: LocalizedStringResource(stringLiteral: charClass.localizationKey)))
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)

                    HStack(spacing: 10) {
                        Label {
                            Text("\(charClass.baseHP)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                        } icon: {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(Color(red: 0.85, green: 0.22, blue: 0.18))
                        }
                        .foregroundStyle(Theme.textSecondary)

                        Label {
                            Text(String(localized: LocalizedStringResource(stringLiteral: "relic_\(starterRelicID(for: charClass))")))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                        } icon: {
                            Image(systemName: "gem.fill")
                                .font(.system(size: 10))
                                .foregroundStyle(Theme.energyColor)
                        }
                        .foregroundStyle(Theme.textSecondary)
                        .lineLimit(1)
                    }

                    Text(String(localized: LocalizedStringResource(stringLiteral: "character_\(charClass.rawValue)_desc")))
                        .font(.system(size: 11, weight: .regular, design: .rounded))
                        .foregroundStyle(Theme.textAccent)
                        .lineLimit(2)
                }

                Spacer()

                VStack(spacing: 2) {
                    Text("\(charClass.startingDeckTemplateKeys.count)")
                        .font(.system(size: 18, weight: .heavy, design: .rounded))
                        .foregroundStyle(Theme.textPrimary)
                    Text(String(localized: "label_cards"))
                        .font(.system(size: 9, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textSecondary)
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? characterColor(for: charClass).opacity(0.08) : Color(red: 0.14, green: 0.13, blue: 0.22))
                    .shadow(color: isSelected ? characterColor(for: charClass).opacity(0.2) : .black.opacity(0.3), radius: isSelected ? 10 : 4, y: 3)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(
                        isSelected ? characterColor(for: charClass).opacity(0.5) : characterColor(for: charClass).opacity(0.1),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .overlay {
                if locked {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color.black.opacity(0.55))
                    VStack(spacing: 4) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Theme.textSecondary)
                        if let req = lockRequirement(for: charClass) {
                            Text(String(localized: LocalizedStringResource(stringLiteral: req.descriptionKey)))
                                .font(.system(size: 10, weight: .medium, design: .rounded))
                                .foregroundStyle(Theme.textSecondary)
                        }
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(locked)
    }

    // MARK: - Helpers

    private func characterColor(for charClass: CharacterClass) -> Color {
        switch charClass {
        case .warrior: return Color(red: 0.90, green: 0.30, blue: 0.25)
        case .assassin: return Color(red: 0.60, green: 0.30, blue: 0.85)
        case .mage: return Color(red: 0.25, green: 0.58, blue: 0.90)
        }
    }

    private func starterRelicID(for charClass: CharacterClass) -> String {
        switch charClass {
        case .warrior: return "burning_blood"
        case .assassin: return "ring_of_snakes"
        case .mage: return "cracked_core"
        }
    }

    // MARK: - Ascension Selector

    private var ascensionSelector: some View {
        VStack(spacing: 8) {
            Text(String(localized: "label_ascension"))
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundStyle(Theme.textSecondary)

            HStack(spacing: 16) {
                Button {
                    HapticManager.selection()
                    if let lower = AscensionLevel(rawValue: ascension.rawValue - 1) {
                        ascension = lower
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(ascension == .none ? Theme.textSecondary.opacity(0.3) : Theme.energyColor)
                }
                .buttonStyle(.plain)
                .disabled(ascension == .none)

                Text(ascension == .none ? String(localized: "label_asc_none") : "Asc \(ascension.rawValue)")
                    .font(.system(size: 18, weight: .heavy, design: .rounded))
                    .foregroundStyle(ascension.isActive ? Theme.energyColor : Theme.textPrimary)
                    .frame(minWidth: 80)

                Button {
                    HapticManager.selection()
                    if let higher = AscensionLevel(rawValue: ascension.rawValue + 1) {
                        ascension = higher
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(ascension == .asc20 ? Theme.textSecondary.opacity(0.3) : Theme.energyColor)
                }
                .buttonStyle(.plain)
                .disabled(ascension == .asc20)
            }

            if ascension.isActive {
                activeModifiers
            }
        }
        .padding(.horizontal, 20)
    }

    private var activeModifiers: some View {
        VStack(spacing: 4) {
            ForEach(AscensionModifier.allCases.filter { $0.level <= ascension.rawValue }) { mod in
                HStack(spacing: 6) {
                    Circle()
                        .fill(Theme.energyColor.opacity(0.6))
                        .frame(width: 4, height: 4)
                    Text(String(localized: LocalizedStringResource(stringLiteral: mod.descriptionKey)))
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundStyle(Theme.textAccent)
                }
            }
        }
        .padding(.top, 2)
    }
}
