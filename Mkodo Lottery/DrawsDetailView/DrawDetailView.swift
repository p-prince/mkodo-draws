import SwiftUI

struct DrawDetailView: View {
    @ObservedObject var viewModel: DrawDetailViewModel
    let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(viewModel.draw.gameName)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 8)
                
                Text("Draw Date: \(viewModel.draw.drawDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Lottery Balls:")
                        .font(.headline)
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.sortedLotteryBalls(), id: \.self) { ball in
                            Text(ball)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(minWidth: 60, minHeight: 60)
                                .background(Color.blue.opacity(0.2))
                                .foregroundColor(.blue)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Bonus Balls:")
                        .font(.headline)
                    
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(viewModel.bonusBalls(), id: \.self) { ball in
                            Text(ball)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .frame(minWidth: 60, minHeight: 60)
                                .background(Color.orange.opacity(0.2))
                                .foregroundColor(.orange)
                                .clipShape(Circle())
                        }
                    }
                }
                .padding()
                
                MyTicketsView(viewModel: MyTicketsViewModel(draw: viewModel.draw))
                
                Spacer(minLength: 40)
            }
            .padding()
            .navigationTitle("Draw Details")
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct DrawDetailView_Previews: PreviewProvider {
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
        let viewModel = DrawDetailViewModel(draw: sampleDraw)
        DrawDetailView(viewModel: viewModel)
    }
}
