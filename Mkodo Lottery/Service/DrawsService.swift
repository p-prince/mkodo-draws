import Foundation
import Combine

protocol DrawsService {
    func fetchDraws() async throws -> [Draw]
}

