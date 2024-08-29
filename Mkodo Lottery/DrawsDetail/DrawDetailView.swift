import SwiftUI

struct DrawDetailView: View {
    @ObservedObject var viewModel: DrawDetailViewModel
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                DrawInfoView(draw: viewModel.draw)
                
                BallsSectionView(
                    title: "Lottery Balls",
                    balls: viewModel.sortedLotteryBalls(),
                    ballColor: Color.blue,
                    backgroundColor: Color.blue.opacity(0.2),
                    columns: columns
                )
                
                BallsSectionView(
                    title: "Bonus Balls",
                    balls: viewModel.bonusBalls(),
                    ballColor: Color.orange,
                    backgroundColor: Color.orange.opacity(0.2),
                    columns: columns
                )
                
                MyTicketsView(viewModel: MyTicketsViewModel(draw: viewModel.draw))
                
                Spacer(minLength: 40)
            }
            .padding()
            .navigationTitle("Draw Details")
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - DrawInfoView

struct DrawInfoView: View {
    let draw: Draw
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(draw.gameName)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Draw Date: \(draw.drawDate)")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 20)
    }
}

// MARK: - BallsSectionView

struct BallsSectionView: View {
    let title: String
    let balls: [String]
    let ballColor: Color
    let backgroundColor: Color
    let columns: [GridItem]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(balls, id: \.self) { ball in
                    BallView(ball: ball, ballColor: ballColor, backgroundColor: backgroundColor)
                }
            }
        }
        .padding()
    }
}

// MARK: - BallView

struct BallView: View {
    let ball: String
    let ballColor: Color
    let backgroundColor: Color
    
    var body: some View {
        Text(ball)
            .font(.title2)
            .fontWeight(.semibold)
            .frame(minWidth: 60, minHeight: 60)
            .background(backgroundColor)
            .foregroundColor(ballColor)
            .clipShape(Circle())
    }
}

// MARK: - Preview

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
