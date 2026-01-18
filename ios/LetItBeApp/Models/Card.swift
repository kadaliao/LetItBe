import Foundation

struct Card: Codable, Identifiable, Equatable {
    let id: String
    let stateId: String
    let title: String
    let body: String
    let footer: String
    let tags: [String]?
    let actionType: CardActionType
    let isFavorited: Bool?

    enum CodingKeys: String, CodingKey {
        case id
        case stateId = "state_id"
        case title
        case body
        case footer
        case tags
        case actionType = "action_type"
        case isFavorited = "is_favorited"
    }
}

enum CardActionType: String, Codable {
    case stopLoss = "stop_loss"
    case none
}
