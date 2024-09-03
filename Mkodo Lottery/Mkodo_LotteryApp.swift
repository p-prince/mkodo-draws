import SwiftUI

class AppConfig: ObservableObject {
    @Published var serviceType: ServiceType = .local
    
    var drawService: DrawsService {
        ServiceFactory.createDrawsService(type: serviceType)
    }
}

@main
struct Mkodo_LotteryApp: App {
    @StateObject private var appConfig = AppConfig()

    var body: some Scene {
        WindowGroup {
            DrawsView(viewModel: DrawsViewModel(drawsService: appConfig.drawService , cacheKey: CacheKeys.lotteryDraws))
                .environmentObject(appConfig)
        }
    }
}
