import SwiftUI

protocol DrawsViewModelType: ObservableObject {
    var groupedDraws: [String: [Draw]] { get }
    var errorMessage: String? { get }

    func fetchDraws() async
}

class DrawsViewModel: DrawsViewModelType {
    @Published var groupedDraws: [String: [Draw]] = [:]
    @Published var errorMessage: String?

    private var drawsService: DrawsService
    private var dataManager: DataManagerType
    private var cacheKey: String
    
    init(drawsService: DrawsService, dataManager: DataManagerType = DataManager.shared, cacheKey: String) {
        self.drawsService = drawsService
        self.dataManager = dataManager
        self.cacheKey = cacheKey
    }
    
    func fetchDraws() async {
        do {
            if let cachedDraws = try dataManager.loadCachedDraws(forKey: cacheKey) {
                await MainActor.run {
                    self.groupedDraws = cachedDraws
                }
            } else {
                await fetchDrawsFromNetwork()
            }
        } catch {
            await MainActor.run {
                self.errorMessage = DrawServiceError.dataLoadingFailed(error).errorDescription
            }
        }
    }
    
    private func fetchDrawsFromNetwork() async {
        do {
            let draws = try await drawsService.fetchDraws()
            let groupedDraws = self.groupAndSortDraws(draws)
            try self.dataManager.saveDraws(groupedDraws, forKey: self.cacheKey)
            
            await MainActor.run {
                self.groupedDraws = groupedDraws
            }
            
        } catch {
            await MainActor.run {
                self.errorMessage = DrawServiceError.networkError(error).errorDescription
            }
        }
    }

    private func groupAndSortDraws(_ draws: [Draw]) -> [String: [Draw]] {
        // Group by game name
        var groupedDraws = Dictionary(grouping: draws, by: { $0.gameName })
        
        // Sort by draw date (most recent first) within each group
        for (gameName, draws) in groupedDraws {
            groupedDraws[gameName] = draws.sorted {
                $0.parsedDrawDate > $1.parsedDrawDate
            }
        }
        
        return groupedDraws
    }
}

extension Draw {
    // Helper to parse the draw date
    var parsedDrawDate: Date {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: drawDate) ?? Date.distantPast
    }
}
