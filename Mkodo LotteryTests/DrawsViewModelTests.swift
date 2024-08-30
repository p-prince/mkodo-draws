import XCTest
@testable import Mkodo_Lottery

class DrawsViewModelTests: XCTestCase {
    
    var mockDrawsService: MockDrawsService!
    var viewModel: DrawsViewModel!
    private let testCacheKey = "testCachedDraws"
    
    override func setUp() {
        super.setUp()
        mockDrawsService = MockDrawsService()
        viewModel = DrawsViewModel(drawsService: mockDrawsService, cacheKey: testCacheKey)
        DataManager.shared.removeCachedDraws(forKey: testCacheKey)
    }
    
    override func tearDown() {
        viewModel = nil
        mockDrawsService = nil
        super.tearDown()
    }
    
    // Test: Group and sort draws
    func testGroupAndSortDraws() async {
        let viewModel = DrawsViewModel(drawsService: MockDrawsService(), cacheKey: testCacheKey)
        
        await viewModel.fetchDraws()

        XCTAssertEqual(viewModel.groupedDraws["Lotto"]?.count, 2)
        XCTAssertEqual(viewModel.groupedDraws["Lotto Plus"]?.count, 1)
        
        // Assert that the draws within each group are sorted by draw date (most recent first)
        XCTAssertEqual(viewModel.groupedDraws["Lotto"]?.first?.id, "1")
        XCTAssertEqual(viewModel.groupedDraws["Lotto"]?.last?.id, "2")
    }

    func testFetchDrawsUsesCacheWhenAvailable() async {
        let cachedDraws = [
            "GameA": [draw(id: "1", gameName: "GameA", drawDate: "2023-08-29T12:00:00Z")],
            "GameB": [draw(id: "2", gameName: "GameB", drawDate: "2023-08-28T12:00:00Z")]
        ]

        let viewModel = DrawsViewModel(drawsService: MockDrawsService(), cacheKey: testCacheKey)

        try? DataManager.shared.saveDraws(cachedDraws, forKey: testCacheKey)
        await viewModel.fetchDraws()
        
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

