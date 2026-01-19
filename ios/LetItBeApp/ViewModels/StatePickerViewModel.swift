import Foundation

final class StatePickerViewModel: ObservableObject {
    @Published private(set) var states: [State] = []
    @Published private(set) var errorMessage: String?

    private let repository: ContentRepository

    init(repository: ContentRepository = ContentRepository()) {
        self.repository = repository
    }

    func loadStates() {
        do {
            states = try repository.states()
            errorMessage = nil
        } catch {
            states = []
            errorMessage = String(localized: "error_no_states")
        }
    }

    func randomCard(for state: State) -> Card? {
        do {
            return try repository.randomCard(for: state)
        } catch {
            return nil
        }
    }
}
