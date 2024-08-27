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

    var body: some Scene {
        WindowGroup {
            DrawsView(drawsService: LocalDrawService())
                .environmentObject(appConfig)
        }
    }
}
