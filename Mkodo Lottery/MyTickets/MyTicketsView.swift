import SwiftUI

struct MyTicketsView: View {
    @ObservedObject var viewModel: MyTicketsViewModel
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Ticket")
                .font(.headline)
            
            TicketNumbersGridView(ticketNumbers: viewModel.ticketNumbers,
                                  isNumberMatching: viewModel.isNumberMatching(_:),
                                  columns: columns)
            WinningBannerView(isWinningTicket: viewModel.isWinningTicket)
        }
        .padding()
        .background(viewModel.isWinningTicket ? Color.green.opacity(0.2) : Color.gray.opacity(0.1))
        .cornerRadius(20)
    }
}

// MARK: - WinningBannerView

struct WinningBannerView: View {
    let isWinningTicket: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text(isWinningTicket ? "🎉 Congratulations! You won!" : "😢 Sorry, better luck next time!")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(isWinningTicket ? Color.green : Color.red)
                    .cornerRadius(10)
                
                Spacer()
            }
            .padding()
        }
    }
}

// MARK: - TicketNumbersGridView

struct TicketNumbersGridView: View {
    let ticketNumbers: [String]
    let isNumberMatching: (String) -> Bool
    let columns: [GridItem]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(ticketNumbers, id: \.self) { ball in
                TicketNumberView(ball: ball, isMatching: isNumberMatching(ball))
            }
        }
    }
}

// MARK: - TicketNumberView

struct TicketNumberView: View {
    let ball: String
    let isMatching: Bool
    
    var body: some View {
        Text(ball)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(minWidth: 60, minHeight: 60)
            .background(isMatching ? Color.green : Color.purple.opacity(0.1))
            .foregroundColor(isMatching ? Color.white : Color.purple)
            .clipShape(Circle())
    }
}
