import Foundation

struct ContentPayload: Codable {
    let states: [MoodState]
    let cards: [Card]
}
