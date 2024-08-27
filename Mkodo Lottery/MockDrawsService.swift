import Combine
import Foundation

struct MockDrawsService: DrawsService {
    func fetchDraws() -> AnyPublisher<[Draw], Error> {
        let mockDraws = [
            Draw(
                gameId: 1,
                gameName: "Lotto",
                id: "1",
                drawDate: "2023-05-15",
                number1: "1",
                number2: "2",
                number3: "3",
                number4: "4",
                number5: "5",
                number6: "6",
                bonusBalls: ["7"],
                topPrize: 1000),
            Draw(
                gameId: 1,
                gameName: "Lotto",
                id: "2",
                drawDate: "2023-05-16",
                number1: "1",
                number2: "2",
                number3: "3",
                number4: "4",
                number5: "5",
                number6: "6",
                bonusBalls: ["7"],
                topPrize: 1000),
            Draw(
                gameId: 2,
                gameName: "Lotto Plus",
                id: "3",
                drawDate: "2023-05-14",
                number1: "1",
                number2: "2",
                number3: "3",
                number4: "4",
                number5: "5",
                number6: "6",
                bonusBalls: ["7"],
                topPrize: 1000)
        ]
        
        return Just(mockDraws)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
