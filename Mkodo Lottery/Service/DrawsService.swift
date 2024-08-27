import Foundation
import Combine

protocol DrawsService {
    func fetchDraws() -> AnyPublisher<[Draw], Error>
}

