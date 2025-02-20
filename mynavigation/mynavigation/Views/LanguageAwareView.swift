import SwiftUI

struct LanguageAwareView: View {
    @State private var needsRestart = false
    
    var body: some View {
        SettingsView()
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("LanguageChanged"))) { _ in
                needsRestart = true
            }
            .alert(isPresented: $needsRestart) {
                Alert(
                    title: Text("Language Changed".localized),
                    message: Text("Please restart the app to apply the new language settings.".localized),
                    dismissButton: .default(Text("OK".localized))
                )
            }
    }
}

#Preview {
    LanguageAwareView()
        .environmentObject(LocalizationManager())
} 