import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private init() {}
    
    func saveDraws(_ groupedDraws: [String: [Draw]], forKey key: String) {
        do {
            let data = try JSONEncoder().encode(groupedDraws)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("Failed to encode draws for caching: \(error)")
        }
    }
    
    func loadCachedDraws(forKey key: String) -> [String: [Draw]]? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        
        do {
            let groupedDraws = try JSONDecoder().decode([String: [Draw]].self, from: data)
            return groupedDraws
        } catch {
            print("Failed to decode cached draws: \(error)")
            return nil
        }
    }
    
    func removeCachedDraws(forKey key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
