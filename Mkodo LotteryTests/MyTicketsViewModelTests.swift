import XCTest
@testable import Mkodo_Lottery

class MyTicketsViewModelTests: XCTestCase {

    func testGenerateTicket() {
        let draw = DrawTestHelper.draw()
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
        let draw = DrawTestHelper.draw()
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
        let draw = DrawTestHelper.draw(bonusBalls: ["7" ,"8"])
        let viewModel = MyTicketsViewModel(draw: draw)
        
        XCTAssertTrue(viewModel.isNumberMatching("1"), "Number 1 should be recognized as a matching number")
        XCTAssertTrue(viewModel.isNumberMatching("7"), "Bonus ball 7 should be recognized as a matching number")
        XCTAssertFalse(viewModel.isNumberMatching("9"), "Number 9 should not be recognized as a matching number")
    }
    
    // Test that the ViewModel correctly handles the case where bonus balls are present
    func testCheckIfWinningTicketWithBonusBalls() {
        let draw = DrawTestHelper.draw(bonusBalls: ["7" ,"8"])
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
        let draw = DrawTestHelper.draw()
        let viewModel = MyTicketsViewModel(draw: draw)
        
        viewModel.ticketNumbers = ["10", "11", "12", "13", "14", "15"]
        viewModel.checkIfWinningTicket()
        
        XCTAssertFalse(viewModel.isWinningTicket, "Ticket should not be marked as winning if no numbers match")
    }
}

