import Foundation

enum ServiceType {
    case local
    case remote
}

class ServiceFactory {
    static func createDrawsService(type: ServiceType) -> DrawsService {
        switch type {
        case .local:
            return LocalDrawService()
        case .remote:
            return RemoteDrawService()
        }
    }
}
