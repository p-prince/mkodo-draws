import SwiftUI

struct MyTicketsView: View {
    @ObservedObject var viewModel: MyTicketsViewModel
    
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("My Ticket")
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(viewModel.ticketNumbers, id: \.self) { ball in
                    Text(ball)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .frame(minWidth: 60, minHeight: 60)
                        .background(viewModel.isNumberMatching(ball) ? .green : .purple.opacity(0.1))
                        .foregroundColor(viewModel.isNumberMatching(ball) ? .white : .purple)
                        .clipShape(Circle())
                }
            }

            if viewModel.isWinningTicket {
                Text("Congratulations! This is a winning ticket!")
                    .font(.title3)
                    .foregroundColor(.green)
                    .bold()
            } else {
                Text("Sorry, this ticket did not win.")
                    .font(.title3)
                    .foregroundColor(.red)
                    .bold()
            }
        }
        .padding()
    }
}

struct MyTicketsView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleDraw = Draw(
            gameId: 1,
            gameName: "Lotto",
            id: "1",
            drawDate: "2023-05-15",
            number1: "2",
            number2: "16",
            number3: "23",
            number4: "44",
            number5: "47",
            number6: "52",
            bonusBalls: ["14"],
            topPrize: 4000000000
        )
        let viewModel = MyTicketsViewModel(draw: sampleDraw)
        MyTicketsView(viewModel: viewModel)
    }
}
