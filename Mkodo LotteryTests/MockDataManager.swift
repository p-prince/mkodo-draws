import XCTest
@testable import Mkodo_Lottery

class MockDataManager: DataManagerType {
    var storedDraws: [String: [Draw]]?

    func saveDraws(_ groupedDraws: [String: [Draw]], forKey key: String) throws {
        storedDraws = groupedDraws
    }
    
    func loadCachedDraws(forKey key: String) throws -> [String: [Draw]]? {
        return storedDraws
    }
    
    func removeCachedDraws(forKey key: String) {
        storedDraws = nil
    }
}
