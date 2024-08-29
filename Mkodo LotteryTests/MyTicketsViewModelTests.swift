import XCTest
@testable import Mkodo_Lottery

class MyTicketsViewModelTests: XCTestCase {
    
    // Helper method to create a Draw object
    private func createDraw(
        number1: String, number2: String, number3: String,
        number4: String, number5: String, number6: String,
        bonusBalls: [String]? = nil
    ) -> Draw {
        return Draw(
            gameId: 1,
            gameName: "Lotto",
            id: "1",
            drawDate: "2023-05-15",
            number1: number1,
            number2: number2,
            number3: number3,
            number4: number4,
            number5: number5,
            number6: number6,
            bonusBalls: bonusBalls,
            topPrize: 1000000
        )
    }
    
    func testGenerateTicket() {
        let draw = createDraw(number1: "1", number2: "2", number3: "3", number4: "4", number5: "5", number6: "6")
        let viewModel = MyTicketsViewModel(draw: draw)
        
        XCTAssertEqual(viewModel.ticketNumbers.count, 6, "Ticket should contain exactly 6 numbers")
        
        for number in viewModel.ticketNumbers {
            guard let intNumber = Int(number) else {
                XCTFail("All ticket numbers should be valid integers")
                return
            }
            XCTAssertTrue(intNumber >= 1 && intNumber <= 59, "Ticket numbers should be within the range 1-59")
        }
    }
    
    func testCheckIfWinningTicket() {
        // Winning ticket
        let draw = createDraw(number1: "1", number2: "2", number3: "3", number4: "4", number5: "5", number6: "6")
        let viewModel = MyTicketsViewModel(draw: draw)
        viewModel.ticketNumbers = ["1", "2", "3", "4", "5", "6"]
        viewModel.checkIfWinningTicket()
        
        XCTAssertTrue(viewModel.isWinningTicket, "Ticket should be marked as winning if it matches all main numbers")
        
        // Non-winning ticket
        viewModel.ticketNumbers = ["7", "8", "9", "10", "11", "12"]
        viewModel.checkIfWinningTicket()
        
        XCTAssertFalse(viewModel.isWinningTicket, "Ticket should not be marked as winning if it does not match all main numbers")
    }
    
    // Test matching numbers logic
    func testIsNumberMatching() {
        let draw = createDraw(number1: "1", number2: "2", number3: "3", number4: "4", number5: "5", number6: "6", bonusBalls: ["7", "8"])
        let viewModel = MyTicketsViewModel(draw: draw)
        
        XCTAssertTrue(viewModel.isNumberMatching("1"), "Number 1 should be recognized as a matching number")
        XCTAssertTrue(viewModel.isNumberMatching("7"), "Bonus ball 7 should be recognized as a matching number")
        XCTAssertFalse(viewModel.isNumberMatching("9"), "Number 9 should not be recognized as a matching number")
    }
    
    // Test that the ViewModel correctly handles the case where bonus balls are present
    func testCheckIfWinningTicketWithBonusBalls() {
        let draw = createDraw(number1: "1", number2: "2", number3: "3", number4: "4", number5: "5", number6: "6", bonusBalls: ["7", "8"])
        let viewModel = MyTicketsViewModel(draw: draw)
        
        viewModel.ticketNumbers = ["1", "2", "3", "4", "5", "6"]
        viewModel.checkIfWinningTicket()
        XCTAssertTrue(viewModel.isWinningTicket, "Ticket should win if all main numbers match, regardless of bonus balls")
        
        viewModel.ticketNumbers = ["1", "2", "3", "4", "5", "7"]
        viewModel.checkIfWinningTicket()
        XCTAssertFalse(viewModel.isWinningTicket, "Ticket should not win if it doesn't match all main numbers")
    }
    
    // Test edge cases like a ticket with no numbers matching
    func testNoMatchingNumbers() {
        let draw = createDraw(number1: "1", number2: "2", number3: "3", number4: "4", number5: "5", number6: "6")
        let viewModel = MyTicketsViewModel(draw: draw)
        
        viewModel.ticketNumbers = ["10", "11", "12", "13", "14", "15"]
        viewModel.checkIfWinningTicket()
        
        XCTAssertFalse(viewModel.isWinningTicket, "Ticket should not be marked as winning if no numbers match")
    }
}

