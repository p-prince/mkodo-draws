import Foundation
import Combine

class RemoteUserService: DrawsService {
    private let apiURL = URL(string: "https://example.com/api/lotterydraw")!

    func fetchDraws() -> AnyPublisher<[Draw], Error> {
        return URLSession.shared.dataTaskPublisher(for: apiURL)
            .map(\.data)
            .decode(type: DrawsResponse.self, decoder: JSONDecoder())
            .map(\.draws)
            .eraseToAnyPublisher()
    }
}
