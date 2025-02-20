import Foundation
import SwiftUI

class LocalizationManager: ObservableObject {
    @Published var currentLanguage: Language {
        didSet {
            UserDefaults.standard.set(currentLanguage.code, forKey: "AppLanguage")
            UserDefaults.standard.set([currentLanguage.code], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // Post notification to restart app
            NotificationCenter.default.post(name: Notification.Name("LanguageChanged"), object: nil)
            
            // Force update the UI
            Bundle.main.loadAndSetLocalizationBundle(for: currentLanguage.code)
        }
    }
    
    init() {
        let savedLanguageCode = UserDefaults.standard.string(forKey: "AppLanguage") ?? "en"
        self.currentLanguage = Language.supportedLanguages.first { $0.code == savedLanguageCode } ?? Language.supportedLanguages[0]
        
        // Initialize with saved language
        Bundle.main.loadAndSetLocalizationBundle(for: currentLanguage.code)
    }
}

// Extension to handle bundle switching
extension Bundle {
    private static var bundle: Bundle?
    
    func loadAndSetLocalizationBundle(for languageCode: String) {
        if let languageBundlePath = self.path(forResource: languageCode, ofType: "lproj"),
           let languageBundle = Bundle(path: languageBundlePath) {
            Bundle.bundle = languageBundle
        } else {
            Bundle.bundle = self
        }
    }
    
    static func localizedBundle() -> Bundle {
        return Bundle.bundle ?? Bundle.main
    }
}

// Extension to handle string localization
extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
    }
    
    func localized(with arguments: CVarArg...) -> String {
        let format = NSLocalizedString(self, tableName: nil, bundle: Bundle.localizedBundle(), value: "", comment: "")
        return String(format: format, arguments: arguments)
    }
} 