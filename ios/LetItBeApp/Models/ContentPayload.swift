import Foundation

struct ContentPayload: Codable {
    let states: [State]
    let cards: [Card]
}
