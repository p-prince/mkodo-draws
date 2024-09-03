import Foundation

class RemoteDrawService: DrawsService {
    private let apiURL = URL(string: "https://example.com/api/lotterydraw")!

    func fetchDraws() async throws -> [Draw] {
        let (data, _) = try await URLSession.shared.data(from: apiURL)
        let response = try JSONDecoder().decode(DrawsResponse.self, from: data)
        return response.draws
    }
}
