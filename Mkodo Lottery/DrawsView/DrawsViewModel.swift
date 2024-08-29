import SwiftUI
import Combine

protocol DrawsViewModelType: ObservableObject {
    var groupedDraws: [String: [Draw]] { get }

    func fetchDraws()
}

class DrawsViewModel: DrawsViewModelType {
    @Published var groupedDraws: [String: [Draw]] = [:]
    
    private var drawsService: DrawsService
    private var cancellables = Set<AnyCancellable>()
    private var cacheKey: String
    
    init(drawsService: DrawsService, cacheKey: String) {
        self.drawsService = drawsService
        self.cacheKey = cacheKey
    }
    
    func fetchDraws() {
        if let cachedDraws = DataManager.shared.loadCachedDraws(forKey: cacheKey) {
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
                    print("Error fetching draws: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { groupedDraws in
                self.groupedDraws = groupedDraws
                DataManager.shared.saveDraws(groupedDraws, forKey: self.cacheKey)
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
