import SwiftUI

struct ContentView: View {
    @StateObject private var navigationViewStore = NavigationViewStore()
    @EnvironmentObject private var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Home".localized)
                    }
                    .environmentObject(navigationViewStore)
                
                LanguageAwareView()
                    .tabItem {
                        Image(systemName: "gearshape.fill")
                        Text("Settings".localized)
                    }
            }
        }
        .environmentObject(localizationManager)
    }
}

class NavigationViewStore: ObservableObject {
    @Published var selection: String?
}

#Preview {
    ContentView()
        .environmentObject(LocalizationManager())
}
