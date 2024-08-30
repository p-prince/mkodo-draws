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
            "Lotto": [DrawTestHelper.draw(id: "1", gameName: "Lotto", drawDate: "2023-08-29T12:00:00Z")],
            "Lotto Plus": [DrawTestHelper.draw(id: "2", gameName: "Lotto Plus", drawDate: "2023-08-25T12:00:00Z")]
        ]
        
        // When
        do {
            try DataManager.shared.saveDraws(draws, forKey: testCacheKey)
            // Then
            let loadedDraws = try DataManager.shared.loadCachedDraws(forKey: testCacheKey)
            
            XCTAssertNotNil(loadedDraws?["Lotto"])
            XCTAssertEqual(loadedDraws?["Lotto"]?.first?.id, "1")
            XCTAssertEqual(loadedDraws?["Lotto Plus"]?.first?.id, "2")
        } catch {
            XCTFail("Saving or loading draws failed with error: \(error)")
        }
    }
    
    func testLoadCachedDrawsReturnsNilWhenNoData() {
        // When
        do {
            let loadedDraws = try DataManager.shared.loadCachedDraws(forKey: testCacheKey)
            // Then
            XCTAssertNil(loadedDraws)
        } catch {
            XCTFail("Loading draws failed with error: \(error)")
        }
    }
    
    func testRemoveCachedDraws() {
        // Given
        let viewModel = DataManager.shared
        let draws = [
            "Lotto": [DrawTestHelper.draw(id: "1", gameName: "Lotto", drawDate: "2023-08-29T12:00:00Z")]
        ]
        
        do {
            try viewModel.saveDraws(draws, forKey: testCacheKey)
            // When
            viewModel.removeCachedDraws(forKey: testCacheKey)
            // Then
            let loadedDraws = try viewModel.loadCachedDraws(forKey: testCacheKey)
            XCTAssertNil(loadedDraws)
        } catch {
            XCTFail("Error occurred during saving or loading: \(error)")
        }
    }
}
