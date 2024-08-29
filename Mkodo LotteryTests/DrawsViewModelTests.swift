import XCTest
import Combine
@testable import Mkodo_Lottery

class DrawsViewModelTests: XCTestCase {
    
    var cancellables: Set<AnyCancellable>!
    var mockDrawsService: MockDrawsService!
    var viewModel: DrawsViewModel!
    private let testCacheKey = "testCachedDraws"
    
    override func setUp() {
        super.setUp()
        mockDrawsService = MockDrawsService()
        viewModel = DrawsViewModel(drawsService: mockDrawsService, cacheKey: testCacheKey)
        DataManager.shared.removeCachedDraws(forKey: testCacheKey)
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        mockDrawsService = nil
        cancellables = nil
        super.tearDown()
    }
    
    // Test: Group and sort draws
    func testGroupAndSortDraws() {
        let expectation = XCTestExpectation(description: "Fetch draws and group/sort them")
        
        let viewModel = DrawsViewModel(drawsService: MockDrawsService(), cacheKey: testCacheKey)
        
        viewModel.$groupedDraws
            .dropFirst()
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

    func testFetchDrawsUsesCacheWhenAvailable() {
        // Given
        let cachedDraws = [
            "GameA": [draw(id: "1", gameName: "GameA", drawDate: "2023-08-29T12:00:00Z")],
            "GameB": [draw(id: "2", gameName: "GameB", drawDate: "2023-08-28T12:00:00Z")]
        ]

        let viewModel = DrawsViewModel(drawsService: MockDrawsService(), cacheKey: testCacheKey)

        DataManager.shared.saveDraws(cachedDraws, forKey: testCacheKey)
        
        // When
        viewModel.fetchDraws()
        
        // Then
        XCTAssertEqual(viewModel.groupedDraws.count, 2)
        XCTAssertEqual(viewModel.groupedDraws["GameA"]?.first?.id, "1")
        XCTAssertEqual(viewModel.groupedDraws["GameB"]?.first?.id, "2")
    }

}

extension DrawsViewModelTests {
    func draw(id: String, gameName: String, drawDate: String) -> Draw {
        return Draw(
            gameId: 1,
            gameName: gameName,
            id: id,
            drawDate: drawDate,
            number1: "52",
            number2: "16",
            number3: "23",
            number4: "2",
            number5: "47",
            number6: "44",
            bonusBalls: ["14", "28"],
            topPrize: 4000000000
        )
    }
}

