import Foundation

protocol DrawsService {
    func fetchDraws() async throws -> [Draw]
}

