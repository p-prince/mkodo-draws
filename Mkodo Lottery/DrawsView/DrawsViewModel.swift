import SwiftUI
import Combine

class DrawsViewModel: ObservableObject {
    @Published var groupedDraws: [String: [Draw]] = [:]
    
    private var drawsService: DrawsService
    private var cancellables = Set<AnyCancellable>()
    
    init(drawsService: DrawsService) {
        self.drawsService = drawsService
    }
    
    func fetchDraws() {
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
            })
            .store(in: &cancellables)
    }
    
    func groupAndSortDraws(_ draws: [Draw]) -> [String: [Draw]] {
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
