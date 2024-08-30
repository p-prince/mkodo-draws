import SwiftUI

// MARK: - DrawsView

struct DrawsView: View {
    @StateObject private var viewModel: DrawsViewModel
    
    init(viewModel: DrawsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                DrawListView(groupedDraws: viewModel.groupedDraws)
                    .navigationTitle("Lottery Draws")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchDraws()
            }
        }
    }
}

// MARK: - DrawListView

struct DrawListView: View {
    let groupedDraws: [String: [Draw]]

    var body: some View {
        List {
            ForEach(groupedDraws.keys.sorted(), id: \.self) { gameName in
                DrawSectionView(gameName: gameName, draws: groupedDraws[gameName] ?? [])
            }
        }
    }
}

// MARK: - DrawSectionView

struct DrawSectionView: View {
    let gameName: String
    let draws: [Draw]
    
    var body: some View {
        Section(header: Text(gameName)) {
            ForEach(draws, id: \.id) { draw in
                DrawRowView(draw: draw)
            }
        }
    }
}

// MARK: - DrawRowView

struct DrawRowView: View {
    let draw: Draw
    
    var body: some View {
        NavigationLink(destination: DrawDetailView(viewModel: DrawDetailViewModel(draw: draw))) {
            VStack(alignment: .leading) {
                Text(draw.drawDate)
                    .font(.subheadline)
                Text(draw.gameName)
                    .font(.headline)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DrawsView(viewModel: DrawsViewModel(drawsService: MockDrawsService(), cacheKey: "cacheKey"))
}
