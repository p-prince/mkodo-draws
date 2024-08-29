import Foundation

// MARK: - Draw Model
struct Draw: Codable, Identifiable {
    let gameId: Int
    let gameName: String
    let id: String
    let drawDate: String
    let number1: String
    let number2: String
    let number3: String
    let number4: String
    let number5: String
    let number6: String?
    let bonusBalls: [String]?
    let topPrize: Int

    enum CodingKeys: String, CodingKey {
        case gameId = "gameId"
        case gameName = "gameName"
        case id = "id"
        case drawDate = "drawDate"
        case number1 = "number1"
        case number2 = "number2"
        case number3 = "number3"
        case number4 = "number4"
        case number5 = "number5"
        case number6 = "number6"
        case bonusBalls = "bonus-balls"
        case topPrize = "topPrize"
    }
}


// MARK: - DrawsResponse Model
struct DrawsResponse: Codable {
    let draws: [Draw]
}
