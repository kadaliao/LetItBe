import Foundation

final class AppState: ObservableObject {
    enum Route {
        case home
        case picker
        case card
        case stopLoss
    }

    @Published var route: Route = .home
    @Published var selectedState: State?
    @Published var currentCard: Card?

    func goHome() {
        route = .home
        selectedState = nil
        currentCard = nil
    }

    func goToPicker() {
        route = .picker
        selectedState = nil
        currentCard = nil
    }

    func goToCard(_ card: Card, state: State) {
        selectedState = state
        currentCard = card
        route = .card
    }

    func goToStopLoss() {
        route = .stopLoss
    }

    func goToStopLoss(card: Card, state: State) {
        selectedState = state
        currentCard = card
        route = .stopLoss
    }
}
