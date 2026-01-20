import SwiftUI
import UIKit

struct ShareCardView: View {
    let card: Card
    let state: State
    let isDark: Bool
    let qrImage: UIImage?

    var body: some View {
        let style = ShareCardStyle(isDark: isDark)
        ZStack(alignment: .topLeading) {
            style.background

            VStack(alignment: .leading, spacing: style.blockSpacing) {
                HStack(alignment: .center, spacing: style.inlineSpacing) {
                    Text("home_title")
                        .font(style.brandFont)
                        .foregroundColor(style.textColor)

                    Text(state.name)
                        .font(style.stateFont)
                        .foregroundColor(style.secondaryTextColor)
                }

                Text(card.title)
                    .font(style.titleFont)
                    .foregroundColor(style.textColor)

                Text(card.body)
                    .font(style.bodyFont)
                    .foregroundColor(style.textColor)
                    .lineSpacing(style.bodyLineSpacing)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer(minLength: style.footerSpacing)

                Text(card.footer)
                    .font(style.footerFont)
                    .foregroundColor(style.secondaryTextColor)

                HStack(alignment: .center, spacing: style.inlineSpacing) {
                    qrBlock(style: style)

                    VStack(alignment: .leading, spacing: style.qrTextSpacing) {
                        Text("share_qr_title")
                            .font(style.qrTitleFont)
                            .foregroundColor(style.textColor)

                        Text("share_qr_subtitle")
                            .font(style.qrSubtitleFont)
                            .foregroundColor(style.secondaryTextColor)
                    }
                }
            }
            .padding(style.padding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: ShareCardStyle.canvasSize.width, height: ShareCardStyle.canvasSize.height)
    }

    @ViewBuilder
    private func qrBlock(style: ShareCardStyle) -> some View {
        if let qrImage {
            Image(uiImage: qrImage)
                .resizable()
                .interpolation(.none)
                .frame(width: ShareCardStyle.qrSide, height: ShareCardStyle.qrSide)
                .padding(style.qrPadding)
                .background(style.qrBackground)
                .clipShape(RoundedRectangle(cornerRadius: style.qrCornerRadius))
        } else {
            RoundedRectangle(cornerRadius: style.qrCornerRadius)
                .fill(style.qrBackground)
                .frame(width: ShareCardStyle.qrSide, height: ShareCardStyle.qrSide)
                .overlay(
                    Text("share_qr_placeholder")
                        .font(style.qrSubtitleFont)
                        .foregroundColor(style.secondaryTextColor)
                )
        }
    }
}

struct ShareCardStyle {
    static let canvasSize = CGSize(width: 1080, height: 1080)
    static let qrSide: CGFloat = 180

    let isDark: Bool

    let padding: CGFloat = 96
    let blockSpacing: CGFloat = 36
    let inlineSpacing: CGFloat = 20
    let bodyLineSpacing: CGFloat = 14
    let footerSpacing: CGFloat = 24
    let qrPadding: CGFloat = 12
    let qrCornerRadius: CGFloat = 16
    let qrTextSpacing: CGFloat = 8

    var background: LinearGradient {
        let start = isDark ? Color(hex: 0x1A1A1A) : Color(hex: 0xF7F2EC)
        let end = isDark ? Color(hex: 0x0F0F0F) : Color(hex: 0xFFFFFF)
        return LinearGradient(colors: [start, end], startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    var textColor: Color {
        Theme.textColor(isDark: isDark)
    }

    var secondaryTextColor: Color {
        Theme.secondaryTextColor(isDark: isDark)
    }

    var qrBackground: Color {
        Color.white
    }

    var brandFont: Font {
        Font.custom("Songti SC", size: 34)
    }

    var stateFont: Font {
        Font.custom("Songti SC", size: 30)
    }

    var titleFont: Font {
        Font.custom("Songti SC", size: 64)
    }

    var bodyFont: Font {
        Font.custom("Songti SC", size: 40)
    }

    var footerFont: Font {
        Font.custom("Songti SC", size: 32)
    }

    var qrTitleFont: Font {
        Font.custom("-apple-system", size: 28)
    }

    var qrSubtitleFont: Font {
        Font.custom("-apple-system", size: 26)
    }
}
