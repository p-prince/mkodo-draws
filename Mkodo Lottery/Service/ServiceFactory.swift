import Foundation

enum ServiceType {
    case local
    case remote
}

class ServiceFactory {
    static func createUserService(type: ServiceType) -> DrawsService {
        switch type {
        case .local:
            return LocalDrawService()
        case .remote:
            return RemoteUserService()
        }
    }
}
