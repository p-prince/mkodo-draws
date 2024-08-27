import SwiftUI

struct DrawDetailView: View {
    let draw: Draw
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(draw.gameName)
                .font(.title)
                .bold()
            
            Text("Draw Date: \(draw.drawDate)")
                .font(.subheadline)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Lottery Balls:")
                    .font(.headline)
                
                HStack {
                    ForEach(sortedLotteryBalls(), id: \.self) { ball in
                        Text(ball)
                            .font(.title2)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Bonus Balls:")
                    .font(.headline)
                
                HStack {
                    ForEach(draw.bonusBalls ?? [], id: \.self) { bonusBall in
                        Text(bonusBall)
                            .font(.title2)
                            .padding()
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Draw Details")
    }
    
    // Helper method to sort the lottery balls
    private func sortedLotteryBalls() -> [String] {
        let balls = [draw.number1, draw.number2, draw.number3, draw.number4, draw.number5, draw.number6].compactMap { $0 }
        return balls.sorted()
    }
}
