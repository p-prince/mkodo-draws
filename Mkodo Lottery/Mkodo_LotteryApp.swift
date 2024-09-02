import SwiftUI

class AppConfig: ObservableObject {
    @Published var serviceType: ServiceType = .local
    
    var userService: DrawsService {
        ServiceFactory.createUserService(type: serviceType)
    }
}

@main
struct Mkodo_LotteryApp: App {
    @StateObject private var appConfig = AppConfig()
    private let cacheKey = "cacheKey"

    var body: some Scene {
        WindowGroup {
            DrawsView(viewModel: DrawsViewModel(drawsService: appConfig.userService , cacheKey: cacheKey))
                .environmentObject(appConfig)
        }
    }
}
