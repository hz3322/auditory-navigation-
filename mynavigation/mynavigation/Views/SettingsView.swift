import SwiftUI
import Foundation

struct SettingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var notificationSetting = "Standard"
    @State private var walkingSpeed = "Auto"
    @State private var showLanguageSelector = false
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Notifications".localized)) {
                    Picker("Notification Style".localized, selection: $notificationSetting) {
                        Text("Standard".localized).tag("Standard")
                        Text("Silent".localized).tag("Silent")
                    }
                }
                
                Section(header: Text("Walking Speed".localized)) {
                    Picker("Speed".localized, selection: $walkingSpeed) {
                        Text("Slow".localized).tag("Slow")
                        Text("Quick".localized).tag("Quick")
                        Text("Auto".localized).tag("Auto")
                    }
                }
                
                Section {
                    // Language selector
                    HStack {
                        Text("Language".localized)
                        Spacer()
                        Button(action: {
                            showLanguageSelector = true
                        }) {
                            HStack {
                                Text(localizationManager.currentLanguage.flag)
                                Text(localizationManager.currentLanguage.name)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    
                    NavigationLink("Sound Settings".localized) {
                        Text("Sound Settings".localized)
                    }
                    
                    NavigationLink("Help & FAQ".localized) {
                        Text("Help & FAQ".localized)
                    }
                }
                
                Section {
                    NavigationLink("Premium Features".localized) {
                        Text("Premium Features".localized)
                    }
                }
            }
            .navigationTitle("Settings".localized)
            .sheet(isPresented: $showLanguageSelector) {
                LanguageSelectorView(localizationManager: localizationManager)
            }
        }
    }
}

struct LanguageSelectorView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var localizationManager: LocalizationManager
    
    var body: some View {
        NavigationView {
            List(Language.supportedLanguages) { language in
                Button(action: {
                    localizationManager.currentLanguage = language
                    dismiss()
                }) {
                    HStack {
                        Text(language.flag)
                            .font(.title2)
                        Text(language.name)
                            .foregroundColor(.primary)
                        Spacer()
                        if language.code == localizationManager.currentLanguage.code {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Select Language".localized)
            .navigationBarItems(trailing: Button("Done".localized) {
                dismiss()
            })
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(LocalizationManager())
} 