import SwiftUI
import UIKit
import CoreTransferable
import UniformTypeIdentifiers

struct MainCardView: View {
    @Environment(ContentStore.self) private var content
    @Environment(FavoritesStore.self) private var favorites
    @Environment(AppearanceModel.self) private var appearance
    @Environment(\.colorScheme) private var scheme
    @Environment(\.nightDim) private var nightDim

    @State private var dragOffset: CGFloat = 0
    @State private var swipeDirection: SwipeDirection = .forward
    @State private var isRepairPresented = false
    @State private var isFavoritesPresented = false
    @State private var isAboutPresented = false

    @State private var isPreparingShare = false
    @State private var isSavingShare = false
    @State private var sharePreviewImage: UIImage?
    @State private var isSharePresented = false
    @State private var alertMessage: String?
    @State private var isAlertPresented = false

    private enum SwipeDirection {
        case forward
        case backward
    }

    var body: some View {
        VStack(spacing: 0) {
            topBar
                .padding(.horizontal, Theme.spacingLarge)
                .padding(.top, Theme.spacingSmall)

            Spacer()

            cardArea
                .padding(.horizontal, Theme.spacingMedium)

            if SwipeHint.shouldShow {
                Text("card_swipe_hint")
                    .font(Theme.fontCaption)
                    .foregroundColor(Theme.secondaryTextColor(scheme).opacity(0.8))
                    .padding(.top, Theme.spacingMedium)
            }

            Spacer()

            actionArea
                .padding(.bottom, Theme.spacingLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor(scheme))
        .animation(.easeInOut(duration: Theme.transitionDuration), value: scheme)
        .onAppear {
            SwipeHint.registerLaunch()
        }
        .fullScreenCover(isPresented: $isRepairPresented) {
            RepairView()
                .nightDimOverlay()
        }
        .sheet(isPresented: $isFavoritesPresented) {
            FavoritesView()
                .nightDimOverlay()
        }
        .sheet(isPresented: $isAboutPresented) {
            AboutView()
                .nightDimOverlay()
        }
        .sheet(isPresented: $isSharePresented) {
            SharePreviewSheet(
                image: sharePreviewImage,
                isSaving: isSavingShare,
                onCancel: {
                    sharePreviewImage = nil
                    isSharePresented = false
                },
                onSave: {
                    confirmShareSave()
                }
            )
            .nightDimOverlay()
        }
        .alert(alertMessage ?? "", isPresented: $isAlertPresented) {
            Button(String(localized: "common_ok"), role: .cancel) {}
        }
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack(spacing: Theme.spacingMedium) {
            HStack(spacing: Theme.spacingMedium) {
                ForEach(content.states) { state in
                    stateChip(for: state)
                }
            }

            Spacer()

            if nightDim {
                Image(systemName: "moon.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Theme.secondaryTextColor(scheme).opacity(0.7))
                    .accessibilityLabel(String(localized: "menu_night_dim"))
            }

            if isPreparingShare || isSavingShare {
                ProgressView()
                    .tint(Theme.textColor(scheme))
                    .accessibilityIdentifier("share_saving")
            } else {
                Button {
                    prepareSharePreview()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Theme.secondaryTextColor(scheme))
                }
                .accessibilityIdentifier("card_share")
                .accessibilityLabel(String(localized: "card_share_accessibility"))
            }

            menuButton
        }
    }

    private func stateChip(for state: MoodState) -> some View {
        let isSelected = content.currentState?.id == state.id
        return Button {
            guard !isSelected else { return }
            Haptics.selection()
            swipeDirection = .forward
            withAnimation(.easeInOut(duration: 0.35)) {
                content.select(state)
            }
        } label: {
            VStack(spacing: 5) {
                Text(state.name)
                    .font(Theme.fontBody)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: false)
                    .foregroundColor(isSelected ? Theme.textColor(scheme) : Theme.secondaryTextColor(scheme).opacity(0.7))

                Circle()
                    .fill(Theme.textColor(scheme))
                    .frame(width: 4, height: 4)
                    .opacity(isSelected ? 1 : 0)
            }
        }
        .accessibilityIdentifier("state_chip_\(state.key.rawValue)")
        .accessibilityLabel(String(format: String(localized: "picker_state_accessibility"), state.name))
    }

    private var menuButton: some View {
        @Bindable var appearance = appearance
        return Menu {
            Button {
                isFavoritesPresented = true
            } label: {
                Label(String(localized: "menu_favorites"), systemImage: "bookmark")
            }
            .accessibilityIdentifier("menu_item_favorites")

            Picker(String(localized: "menu_appearance"), selection: $appearance.mode) {
                ForEach(AppearanceMode.allCases) { mode in
                    Text(mode.labelKey).tag(mode)
                }
            }
            .pickerStyle(.menu)

            Toggle(isOn: $appearance.nightDimEnabled) {
                Label(String(localized: "menu_night_dim"), systemImage: "moon")
            }
            .accessibilityIdentifier("menu_night_dim")

            Button {
                isAboutPresented = true
            } label: {
                Label(String(localized: "menu_about"), systemImage: "info.circle")
            }
            .accessibilityIdentifier("menu_item_about")
        } label: {
            Image(systemName: "ellipsis")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .frame(width: 24, height: 24)
        }
        .accessibilityIdentifier("main_menu")
    }

    // MARK: - Card

    private var cardArea: some View {
        Group {
            if let card = content.currentCard {
                CardFaceView(
                    card: card,
                    isFavorite: favorites.isFavorite(card.id),
                    onToggleFavorite: { toggleFavorite(card) }
                )
                .id(card.id)
                .transition(cardTransition)
                .offset(x: dragOffset)
                .rotationEffect(.degrees(Double(dragOffset) / 40), anchor: .bottom)
                .gesture(cardDrag)
                .onTapGesture(count: 2) {
                    toggleFavorite(card)
                }
            } else {
                Text(content.errorMessage ?? String(localized: "card_empty"))
                    .font(Theme.fontBody)
                    .foregroundColor(Theme.secondaryTextColor(scheme))
            }
        }
    }

    private var cardTransition: AnyTransition {
        switch swipeDirection {
        case .forward:
            return .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            )
        case .backward:
            return .asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .trailing).combined(with: .opacity)
            )
        }
    }

    private var cardDrag: some Gesture {
        DragGesture(minimumDistance: 12)
            .onChanged { value in
                dragOffset = value.translation.width
            }
            .onEnded { value in
                let translation = value.translation.width
                if translation < -80 {
                    showNextCard()
                } else if translation > 80, content.canGoBack {
                    showPreviousCard()
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        dragOffset = 0
                    }
                }
            }
    }

    private func showNextCard() {
        swipeDirection = .forward
        Haptics.soft()
        dragOffset = 0
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            content.nextCard()
        }
    }

    private func showPreviousCard() {
        swipeDirection = .backward
        Haptics.soft()
        dragOffset = 0
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85)) {
            content.previousCard()
        }
    }

    private func toggleFavorite(_ card: Card) {
        Haptics.light()
        favorites.toggle(card.id)
    }

    // MARK: - Actions

    private var actionArea: some View {
        HStack(spacing: Theme.spacingSmall) {
            Button("card_fix") {
                isRepairPresented = true
            }
            .buttonStyle(PrimaryOutlineButtonStyle())
            .accessibilityIdentifier("stop_loss_entry")
            .accessibilityLabel(String(localized: "card_fix_accessibility"))

            Button("card_swap") {
                showNextCard()
            }
            .buttonStyle(PrimaryOutlineButtonStyle())
            .accessibilityIdentifier("card_swap")
            .accessibilityLabel(String(localized: "card_swap_accessibility"))
        }
        .frame(maxWidth: 360)
        .padding(.horizontal, Theme.spacingLarge)
    }

    // MARK: - Share

    private func prepareSharePreview() {
        guard !isPreparingShare, !isSavingShare else { return }
        guard let card = content.currentCard, let state = content.currentState else { return }
        isPreparingShare = true
        let isDark = scheme == .dark
        Task {
            let result = await ShareImageService.makeShareImage(card: card, state: state, isDark: isDark)
            await MainActor.run {
                isPreparingShare = false
                switch result {
                case .success(let image):
                    sharePreviewImage = image
                    isSharePresented = true
                case .failure(let error):
                    alertMessage = error.localizedDescription
                    isAlertPresented = true
                }
            }
        }
    }

    private func confirmShareSave() {
        guard !isSavingShare, let sharePreviewImage else { return }
        isSavingShare = true
        Task {
            let result = await ShareImageService.saveShareImage(sharePreviewImage)
            await MainActor.run {
                isSavingShare = false
                switch result {
                case .success:
                    alertMessage = String(localized: "share_saved")
                    self.sharePreviewImage = nil
                    isSharePresented = false
                case .failure(let error):
                    alertMessage = error.localizedDescription
                }
                isAlertPresented = true
            }
        }
    }
}

// MARK: - Card face

struct CardFaceView: View {
    @Environment(\.colorScheme) private var scheme

    let card: Card
    let isFavorite: Bool
    let onToggleFavorite: () -> Void

    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            Text(card.title)
                .font(Theme.fontCardTitle)
                .tracking(2)
                .accessibilityIdentifier("card_title")

            Text(card.body)
                .font(Theme.fontBody)
                .lineSpacing(7)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityIdentifier("card_body")

            Text(card.footer)
                .font(Theme.fontCaption)
                .foregroundColor(Theme.secondaryTextColor(scheme))
                .accessibilityIdentifier("card_footer")
        }
        .foregroundColor(Theme.textColor(scheme))
        .padding(.vertical, Theme.spacingLarge)
        .padding(.horizontal, Theme.spacingMedium)
        .frame(maxWidth: 360)
        .background(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .fill(Theme.cardBackground(scheme))
                .shadow(color: Theme.cardShadow(scheme), radius: 18, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(Theme.highlightColor(scheme), lineWidth: Theme.borderWidth)
        )
        .overlay(alignment: .topTrailing) {
            Button(action: onToggleFavorite) {
                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                    .font(.system(size: 14))
                    .foregroundColor(isFavorite ? Theme.textColor(scheme) : Theme.secondaryTextColor(scheme).opacity(0.6))
                    .padding(Theme.spacingSmall)
            }
            .accessibilityIdentifier("card_favorite")
            .accessibilityLabel(String(localized: "card_favorite_accessibility"))
        }
    }
}

// MARK: - Share preview sheet

struct SharePreviewSheet: View {
    @Environment(\.colorScheme) private var scheme

    let image: UIImage?
    let isSaving: Bool
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: Theme.spacingMedium) {
            Text("share_preview_title")
                .font(Theme.fontBody)
                .foregroundColor(Theme.textColor(scheme))

            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .stroke(Theme.highlightColor(scheme), lineWidth: Theme.borderWidth)
                    )
            } else {
                ProgressView()
                    .tint(Theme.textColor(scheme))
            }

            HStack(spacing: Theme.spacingSmall) {
                if let image {
                    ShareLink(
                        item: ShareableCardImage(image: image),
                        preview: SharePreview(
                            Text("share_preview_title"),
                            image: Image(uiImage: image)
                        )
                    ) {
                        Text("share_system")
                    }
                    .buttonStyle(PrimaryOutlineButtonStyle())
                    .disabled(isSaving)
                    .accessibilityIdentifier("share_system")
                }

                Button {
                    onSave()
                } label: {
                    if isSaving {
                        ProgressView()
                            .tint(Theme.textColor(scheme))
                    } else {
                        Text("share_preview_save")
                    }
                }
                .buttonStyle(PrimaryOutlineButtonStyle())
                .disabled(isSaving || image == nil)
            }

            Button("share_preview_cancel") {
                onCancel()
            }
            .buttonStyle(LinkButtonStyle())
            .disabled(isSaving)
        }
        .padding(Theme.spacingLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor(scheme))
    }
}

/// 系统分享用的图片封装（导出为 PNG）。
struct ShareableCardImage: Transferable {
    let image: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .png) { item in
            item.image.pngData() ?? Data()
        }
    }
}

// MARK: - Swipe hint

enum SwipeHint {
    private static let countKey = "swipe_hint_count"
    private static let maxLaunches = 3

    static var shouldShow: Bool {
        UserDefaults.standard.integer(forKey: countKey) <= maxLaunches
    }

    static func registerLaunch() {
        let count = UserDefaults.standard.integer(forKey: countKey)
        guard count <= maxLaunches else { return }
        UserDefaults.standard.set(count + 1, forKey: countKey)
    }
}
