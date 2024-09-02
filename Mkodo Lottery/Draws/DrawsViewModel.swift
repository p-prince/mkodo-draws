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
        if let cachedDraws = try? dataManager.loadCachedDraws(forKey: cacheKey) {
            await updateUI(with: cachedDraws)
            return
        }

        await fetchDrawsFromNetwork()
    }

    private func fetchDrawsFromNetwork() async {
        do {
            let draws = try await drawsService.fetchDraws()
            let groupedDraws = groupAndSortDraws(draws)
            
            try? dataManager.saveDraws(groupedDraws, forKey: cacheKey)
            await updateUI(with: groupedDraws)
        } catch {
            await handleFetchError(DrawServiceError.networkError(error))
        }
    }

    @MainActor
    private func updateUI(with groupedDraws: [String: [Draw]]) {
        self.groupedDraws = groupedDraws
    }

    @MainActor
    private func handleFetchError(_ error: DrawServiceError) {
        self.errorMessage = error.errorDescription
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
