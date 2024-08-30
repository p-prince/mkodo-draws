import XCTest
@testable import Mkodo_Lottery

class DrawTestHelper {
    static func draw(id: String = "1",
                     gameName: String = "Lotto",
                     drawDate: String = "2023-05-15",
                     number1: String = "1",
                     number2: String = "2",
                     number3: String = "3",
                     number4: String = "4",
                     number5: String = "5",
                     number6: String = "6",
                     bonusBalls: [String] =  ["14", "28"],
                     topPrize: Int = 4000000000) -> Draw {
        return Draw(
            gameId: 1,
            gameName: gameName,
            id: id,
            drawDate: drawDate,
            number1: number1,
            number2: number2,
            number3: number3,
            number4: number4,
            number5: number5,
            number6: number6,
            bonusBalls: bonusBalls,
            topPrize: topPrize
        )
    }
}
