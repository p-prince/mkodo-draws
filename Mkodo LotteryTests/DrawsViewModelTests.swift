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
        let mockDataManager = MockDataManager()
        let cachedDraws = [
            "GameA": [DrawTestHelper.draw(id: "1", gameName: "GameA", drawDate: "2023-08-29T12:00:00Z")],
            "GameB": [DrawTestHelper.draw(id: "2", gameName: "GameB", drawDate: "2023-08-28T12:00:00Z")]
        ]

        mockDataManager.storedDraws = cachedDraws

        let viewModel = DrawsViewModel(drawsService: MockDrawsService(), dataManager: mockDataManager, cacheKey: testCacheKey)

        
        await viewModel.fetchDraws()
        
        XCTAssertEqual(viewModel.groupedDraws.count, 2)
        XCTAssertEqual(viewModel.groupedDraws["GameA"]?.first?.id, "1")
        XCTAssertEqual(viewModel.groupedDraws["GameB"]?.first?.id, "2")
    }

}

