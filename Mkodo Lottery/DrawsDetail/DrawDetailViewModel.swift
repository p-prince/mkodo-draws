import SwiftUI
import Combine

protocol DrawDetailViewModelType: ObservableObject {
    var draw: Draw { get }
    
    func sortedLotteryBalls() -> [String]
    func bonusBalls() -> [String]
}

class DrawDetailViewModel: DrawDetailViewModelType {
    @Published var draw: Draw
    
    init(draw: Draw) {
        self.draw = draw
    }
    
    func sortedLotteryBalls() -> [String] {
        let balls = [draw.number1, draw.number2, draw.number3, draw.number4, draw.number5, draw.number6].compactMap { $0 }
        let sortedBalls = balls.compactMap { Int($0) }.sorted()
        
        return sortedBalls.map { String($0) }
    }
    
    func bonusBalls() -> [String] {
        return draw.bonusBalls ?? []
    }
}

