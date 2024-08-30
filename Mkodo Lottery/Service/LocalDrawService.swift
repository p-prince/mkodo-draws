import Foundation

class LocalDrawService: DrawsService {
    func fetchDraws() async throws -> [Draw] {
        guard let url = Bundle.main.url(forResource: "draws", withExtension: "json") else {
            throw DrawServiceError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let response = try JSONDecoder().decode(DrawsResponse.self, from: data)
            return response.draws
        } catch {
            throw DrawServiceError.dataLoadingFailed(error)
        }
    }
}
