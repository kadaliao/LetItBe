import Foundation

enum ContentRepositoryError: Error {
    case missingResource
    case invalidData
    case emptyResult
}

final class ContentRepository {
    private let bundle: Bundle
    private let resourceName: String
    private var cachedPayload: ContentPayload?
    private var cachedLocalization: String?

    init(bundle: Bundle = .main, resourceName: String = "content") {
        self.bundle = bundle
        self.resourceName = resourceName
    }

    func load() throws -> ContentPayload {
        let availableLocalizations = bundle.localizations.filter { $0 != "Base" }
        let preferredLocalizations = Bundle.preferredLocalizations(
            from: availableLocalizations,
            forPreferences: Locale.preferredLanguages
        )
        let localization = preferredLocalizations.first ?? bundle.developmentLocalization
        if let cachedPayload, cachedLocalization == localization {
            return cachedPayload
        }
        var localizedUrl: URL?
        if let localization {
            localizedUrl = bundle.url(
                forResource: resourceName,
                withExtension: "json",
                subdirectory: "\(localization).lproj"
            )
            if localizedUrl == nil {
                localizedUrl = bundle.url(
                    forResource: resourceName,
                    withExtension: "json",
                    subdirectory: nil,
                    localization: localization
                )
            }
        }
        guard let url = localizedUrl ?? bundle.url(forResource: resourceName, withExtension: "json") else {
            throw ContentRepositoryError.missingResource
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let payload = try decoder.decode(ContentPayload.self, from: data)
        cachedPayload = payload
        cachedLocalization = localization
        return payload
    }

    func states() throws -> [State] {
        return try load().states
    }

    func cards(for state: State) throws -> [Card] {
        let payload = try load()
        let cards = payload.cards.filter { $0.stateId == state.id }
        if cards.isEmpty {
            throw ContentRepositoryError.emptyResult
        }
        return cards
    }

    func randomCard(for state: State) throws -> Card {
        let cards = try cards(for: state)
        guard let card = cards.randomElement() else {
            throw ContentRepositoryError.emptyResult
        }
        return card
    }
}
