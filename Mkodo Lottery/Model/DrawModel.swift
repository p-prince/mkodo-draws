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
}

// MARK: - DrawsResponse Model
struct DrawsResponse: Codable {
    let draws: [Draw]
}
