import Foundation

protocol DataManagerType {
    func saveDraws(_ groupedDraws: [String: [Draw]], forKey key: String) throws
    func loadCachedDraws(forKey key: String) throws -> [String: [Draw]]?
    func removeCachedDraws(forKey key: String)
}

enum DataManagerError: Error {
    case encodingFailed(Error)
    case decodingFailed(Error)
}

class DataManager: DataManagerType {
    
    static let shared = DataManager()
    
    private init() {}
    
    func saveDraws(_ groupedDraws: [String: [Draw]], forKey key: String) throws {
        do {
            let data = try JSONEncoder().encode(groupedDraws)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            throw DataManagerError.encodingFailed(error)
        }
    }
    
    func loadCachedDraws(forKey key: String) throws -> [String: [Draw]]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        
        do {
            let groupedDraws = try JSONDecoder().decode([String: [Draw]].self, from: data)
            return groupedDraws
        } catch {
            throw DataManagerError.encodingFailed(error)
        }
    }
    
    func removeCachedDraws(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
