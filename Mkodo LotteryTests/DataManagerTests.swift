import XCTest
@testable import Mkodo_Lottery

class DataManagerTests: XCTestCase {
    
    private let testCacheKey = "testCachedDraws"
    
    override func setUp() {
        super.setUp()
        DataManager.shared.removeCachedDraws(forKey: testCacheKey)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSaveDraws() {
        // Given
        let draws = [
            "Lotto": [draw(id: "1", gameName: "Lotto", drawDate: "2023-08-29T12:00:00Z")],
            "Lotto Plus": [draw(id: "2", gameName: "Lotto Plus", drawDate: "2023-08-25T12:00:00Z")]
        ]
        
        // When
        DataManager.shared.saveDraws(draws, forKey: testCacheKey)
        
        // Then
        let loadedDraws = DataManager.shared.loadCachedDraws(forKey: testCacheKey)

        XCTAssertNotNil(loadedDraws?["Lotto"])
        XCTAssertEqual(loadedDraws?["Lotto"]?.first?.id, "1")
        XCTAssertEqual(loadedDraws?["Lotto Plus"]?.first?.id, "2")
    }
    
    func testLoadCachedDrawsReturnsNilWhenNoData() {
        // When
        let loadedDraws = DataManager.shared.loadCachedDraws(forKey: testCacheKey)
        
        // Then
        XCTAssertNil(loadedDraws)
    }
    
    func testRemoveCachedDraws() {
        // Given
        let viewModel = DataManager.shared
        let draws = [
            "Lotto": [draw(id: "1", gameName: "Lotto", drawDate: "2023-08-29T12:00:00Z")]
        ]
        viewModel.saveDraws(draws, forKey: testCacheKey)
        
        // When
        viewModel.removeCachedDraws(forKey: testCacheKey)
        
        // Then
        let loadedDraws = viewModel.loadCachedDraws(forKey: testCacheKey)
        XCTAssertNil(loadedDraws)
    }
}

extension DataManagerTests {
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

