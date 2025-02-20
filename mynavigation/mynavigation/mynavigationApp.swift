import SwiftUI

@main
struct mynavigationApp: App {
    @StateObject private var localizationManager = LocalizationManager()
    @StateObject private var navigationViewStore = NavigationViewStore()
    
    init() {
        // Set initial language
        if let languageCode = UserDefaults.standard.string(forKey: "AppLanguage") {
            UserDefaults.standard.set([languageCode], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localizationManager)
                .environmentObject(navigationViewStore)
        }
    }
}
