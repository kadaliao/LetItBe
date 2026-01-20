import SwiftUI
import UIKit
import Photos
import CoreImage
import CoreImage.CIFilterBuiltins

enum ShareImageService {
    static let qrLink = "http://github.com/kadaliao/letitbe"

    static func makeShareImage(card: Card, state: State, isDark: Bool) async -> Result<UIImage, ShareImageError> {
        let image = await MainActor.run(resultType: UIImage?.self) {
            renderShareImage(card: card, state: state, isDark: isDark)
        }
        guard let image else {
            return .failure(.renderFailed)
        }
        return .success(image)
    }

    static func saveShareImage(card: Card, state: State, isDark: Bool) async -> Result<Void, ShareImageError> {
        let renderResult = await makeShareImage(card: card, state: state, isDark: isDark)
        switch renderResult {
        case .success(let image):
            return await saveShareImage(image)
        case .failure(let error):
            return .failure(error)
        }
    }

    static func saveShareImage(_ image: UIImage) async -> Result<Void, ShareImageError> {
        let status = await requestAuthorization()
        guard status == .authorized || status == .limited else {
            return .failure(.unauthorized)
        }

        do {
            try await saveToLibrary(image)
            return .success(())
        } catch {
            return .failure(.saveFailed)
        }
    }

    @MainActor
    private static func renderShareImage(card: Card, state: State, isDark: Bool) -> UIImage? {
        let qrImage = QRCodeGenerator.makeImage(text: qrLink, size: ShareCardStyle.qrSide)
        let view = ShareCardView(card: card, state: state, isDark: isDark, qrImage: qrImage)
        return ShareImageRenderer.render(view: view, size: ShareCardStyle.canvasSize)
    }

    private static func requestAuthorization() async -> PHAuthorizationStatus {
        let current = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        if current == .notDetermined {
            return await withCheckedContinuation { continuation in
                PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                    continuation.resume(returning: status)
                }
            }
        }
        return current
    }

    private static func saveToLibrary(_ image: UIImage) async throws {
        try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { success, error in
                if success {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: error ?? ShareImageError.saveFailed)
                }
            }
        }
    }
}

enum ShareImageError: LocalizedError {
    case renderFailed
    case unauthorized
    case saveFailed

    var errorDescription: String? {
        switch self {
        case .renderFailed:
            return String(localized: "share_error_render")
        case .unauthorized:
            return String(localized: "share_error_permission")
        case .saveFailed:
            return String(localized: "share_error_save")
        }
    }
}

enum QRCodeGenerator {
    private static let context = CIContext()

    static func makeImage(text: String, size: CGFloat) -> UIImage? {
        guard let data = text.data(using: .utf8) else { return nil }
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("M", forKey: "inputCorrectionLevel")
        guard let outputImage = filter.outputImage else { return nil }
        let scaleX = size / outputImage.extent.width
        let scaleY = size / outputImage.extent.height
        let transformed = outputImage.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        guard let cgImage = context.createCGImage(transformed, from: transformed.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}

enum ShareImageRenderer {
    @MainActor
    static func render<V: View>(view: V, size: CGSize) -> UIImage? {
        if #available(iOS 16.0, *) {
            let renderer = ImageRenderer(content: view)
            renderer.proposedSize = ProposedViewSize(width: size.width, height: size.height)
            renderer.scale = 1
            return renderer.uiImage
        }

        let controller = UIHostingController(rootView: view)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.frame = CGRect(origin: .zero, size: size)
        controller.view.backgroundColor = .clear
        controller.view.layoutIfNeeded()

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        return renderer.image { _ in
            controller.view.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}
