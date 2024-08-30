import Foundation

enum DrawServiceError: Error {
    case fileNotFound
    case dataLoadingFailed(Error)
    case decodingFailed(Error)
    case networkError(Error)
    case unknownError
}

extension DrawServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileNotFound:
            return NSLocalizedString("The file could not be found.", comment: "")
        case .dataLoadingFailed(let error):
            return NSLocalizedString("Failed to load data: \(error.localizedDescription)", comment: "")
        case .decodingFailed(let error):
            return NSLocalizedString("Failed to decode data: \(error.localizedDescription)", comment: "")
        case .networkError(let error):
            return NSLocalizedString("Network error occurred: \(error.localizedDescription)", comment: "")
        case .unknownError:
            return NSLocalizedString("An unknown error occurred.", comment: "")
        }
    }
}
