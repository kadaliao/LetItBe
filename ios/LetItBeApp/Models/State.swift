import Foundation

struct MoodState: Codable, Identifiable, Equatable {
    let id: String
    let key: StateKey
    let name: String
    let description: String?
}

enum StateKey: String, Codable, CaseIterable {
    case tired
    case numb
    case hide
    case annoyed
}
