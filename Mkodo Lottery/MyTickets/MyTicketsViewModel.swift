import SwiftUI
import Combine

protocol MyTicketsViewModelType: ObservableObject {
    var ticketNumbers: [String] { get }
    var isWinningTicket: Bool { get }
    
    func isNumberMatching(_ number: String) -> Bool
}

class MyTicketsViewModel: MyTicketsViewModelType {
    @Published var ticketNumbers: [String] = []
    @Published var isWinningTicket: Bool = false
    
    private var draw: Draw
    
    init(draw: Draw) {
        self.draw = draw
        generateTicket()
        checkIfWinningTicket()
    }
    
    private var mainDrawNumbers: [String] {
        let drawNumbers = [draw.number1, draw.number2, draw.number3, draw.number4, draw.number5, draw.number6]
            .compactMap { $0 }
        return drawNumbers
    }
    
    private var bonusDrawNumbers: [String] {
        return draw.bonusBalls ?? []
    }
    
    private func generateTicket() {
        var numbers = Set<Int>()
        while numbers.count < 6 {
            numbers.insert(Int.random(in: 1...59))
        }

        ticketNumbers = numbers.sorted().map { String($0) }
    }
    
    private func checkIfWinningTicket() {
        let tickets = ticketNumbers.compactMap { $0 }
        let mainDraws = mainDrawNumbers.compactMap { $0 }

        isWinningTicket = mainDraws == tickets
    }
    
    func isNumberMatching(_ number: String) -> Bool {
        return mainDrawNumbers.contains(number) || bonusDrawNumbers.contains(number)
    }
}
