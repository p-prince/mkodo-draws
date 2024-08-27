import XCTest
import Combine
@testable import Mkodo_Lottery

class DrawsViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

    func testGroupAndSortDraws() {
            let expectation = XCTestExpectation(description: "Fetch draws and group/sort them")
            
            let viewModel = DrawsViewModel(drawsService: MockDrawsService())
            
            // Subscribe to changes in the `groupedDraws` property
            viewModel.$groupedDraws
                .dropFirst() // We want to wait for the first update
                .sink { groupedDraws in
                    // Assert that the draws are grouped by game name
                    XCTAssertEqual(groupedDraws["Lotto"]?.count, 2)
                    XCTAssertEqual(groupedDraws["Lotto Plus"]?.count, 1)
                    
                    // Assert that the draws within each group are sorted by draw date (most recent first)
                    XCTAssertEqual(groupedDraws["Lotto"]?.first?.id, "1")  // Most recent draw should come first
                    XCTAssertEqual(groupedDraws["Lotto"]?.last?.id, "2")
                    
                    expectation.fulfill()
                }
                .store(in: &cancellables)
            
            // Call the fetch method to trigger the fetch and sorting logic
            viewModel.fetchDraws()
            
            // Wait for expectations to be fulfilled, with a timeout in case something goes wrong
            wait(for: [expectation], timeout: 5.0)
        }
}
