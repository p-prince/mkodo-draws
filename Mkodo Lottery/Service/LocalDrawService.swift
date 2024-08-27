import Foundation
import Combine

class LocalDrawService: DrawsService {
    func fetchDraws() -> AnyPublisher<[Draw], Error> {
        guard let url = Bundle.main.url(forResource: "draws", withExtension: "json") else {
            return Fail(error: NSError(domain: "FileNotFound", code: -1, userInfo: nil))
                .eraseToAnyPublisher()
        }
        
        return Future<[Draw], Error> { promise in
            do {
                let data = try Data(contentsOf: url)
                let response = try JSONDecoder().decode(DrawsResponse.self, from: data)
                promise(.success(response.draws))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
