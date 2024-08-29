import XCTest
@testable import Mkodo_Lottery

class DrawDetailViewModelTests: XCTestCase {

    func testSortedLotteryBalls() {
        // Given
        let draw = Draw(
            gameId: 1,
            gameName: "Lotto",
            id: "1",
            drawDate: "2023-05-15",
            number1: "52",
            number2: "16",
            number3: "23",
            number4: "2",
            number5: "47",
            number6: "44",
            bonusBalls: ["14"],
            topPrize: 4000000000
        )
        let viewModel = DrawDetailViewModel(draw: draw)

        // When
        let sortedBalls = viewModel.sortedLotteryBalls()

        // Then
        XCTAssertEqual(sortedBalls, ["2", "16", "23", "44", "47", "52"], "The lottery balls should be sorted in ascending order.")
    }
    
    func testBonusBalls() {
        // Given
        let draw = Draw(
            gameId: 1,
            gameName: "Lotto",
            id: "1",
            drawDate: "2023-05-15",
            number1: "52",
            number2: "16",
            number3: "23",
            number4: "2",
            number5: "47",
            number6: "44",
            bonusBalls: ["14", "28"],
            topPrize: 4000000000
        )
        let viewModel = DrawDetailViewModel(draw: draw)

        // When
        let bonusBalls = viewModel.bonusBalls()

        // Then
        XCTAssertEqual(bonusBalls, ["14", "28"], "The bonus balls should be returned correctly.")
    }
    
    func testNoBonusBalls() {
        // Given
        let draw = Draw(
            gameId: 1,
            gameName: "Lotto",
            id: "1",
            drawDate: "2023-05-15",
            number1: "52",
            number2: "16",
            number3: "23",
            number4: "2",
            number5: "47",
            number6: "44",
            bonusBalls: nil,
            topPrize: 4000000000
        )
        let viewModel = DrawDetailViewModel(draw: draw)

        // When
        let bonusBalls = viewModel.bonusBalls()

        // Then
        XCTAssertTrue(bonusBalls.isEmpty, "The bonus balls should be empty if none are provided.")
    }
}
