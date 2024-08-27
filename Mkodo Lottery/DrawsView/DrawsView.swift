import SwiftUI

struct DrawsView: View {
    @StateObject private var viewModel: DrawsViewModel
    
    init(drawsService: DrawsService) {
        _viewModel = StateObject(wrappedValue: DrawsViewModel(drawsService: drawsService))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.groupedDraws.keys.sorted(), id: \.self) { gameName in
                    Section(header: Text(gameName)) {
                        if let draws = viewModel.groupedDraws[gameName] {
                            ForEach(draws, id: \.id) { draw in
                                NavigationLink(destination: DrawDetailView(draw: draw)) {
                                    VStack(alignment: .leading) {
                                        Text(draw.drawDate)
                                            .font(.subheadline)
                                        Text(draw.gameName)
                                            .font(.headline)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Lottery Draws")
        }
        .onAppear {
            viewModel.fetchDraws()
        }
    }
}

#Preview {
    DrawsView(drawsService: MockDrawsService())
}
