import SwiftUI
import Combine

protocol DrawsViewModelType: ObservableObject {
    var groupedDraws: [String: [Draw]] { get }
    var errorMessage: String? { get }

    func fetchDraws()
}

class DrawsViewModel: DrawsViewModelType {
    @Published var groupedDraws: [String: [Draw]] = [:]
    @Published var errorMessage: String?

    private var drawsService: DrawsService
    private var dataManager: DataManagerType
    private var cancellables = Set<AnyCancellable>()
    private var cacheKey: String
    
    init(drawsService: DrawsService, dataManager: DataManagerType = DataManager.shared, cacheKey: String) {
        self.drawsService = drawsService
        self.dataManager = dataManager
        self.cacheKey = cacheKey
    }
    
    func fetchDraws() {
        if let cachedDraws = dataManager.loadCachedDraws(forKey: cacheKey) {
            self.groupedDraws = cachedDraws
        } else {
            fetchDrawsFromNetwork()
        }
    }
    
    private func fetchDrawsFromNetwork() {
        drawsService.fetchDraws()
            .map { draws in
                self.groupAndSortDraws(draws)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "Error fetching draws: \(error.localizedDescription)"
                case .finished:
                    break
                }
            }, receiveValue: { groupedDraws in
                self.groupedDraws = groupedDraws
                self.dataManager.saveDraws(groupedDraws, forKey: self.cacheKey)
            })
            .store(in: &cancellables)
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
