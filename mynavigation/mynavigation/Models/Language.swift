import Foundation

struct Language: Identifiable, Hashable, Equatable {
    let id = UUID()
    let name: String
    let code: String
    let flag: String // Emoji flag
    
    // Implementing Equatable
    static func == (lhs: Language, rhs: Language) -> Bool {
        return lhs.code == rhs.code && lhs.name == rhs.name && lhs.flag == rhs.flag
    }
    
    // Implementing Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(code)
        hasher.combine(name)
        hasher.combine(flag)
    }
    
    static let supportedLanguages = [
        Language(name: "English", code: "en", flag: "🇬🇧"),
        Language(name: "简体中文", code: "zh-Hans", flag: "🇨🇳"),
        Language(name: "繁體中文", code: "zh-Hant", flag: "🇭🇰"),
        Language(name: "日本語", code: "ja", flag: "🇯🇵"),
        Language(name: "한국어", code: "ko", flag: "🇰🇷"),
        Language(name: "Español", code: "es", flag: "🇪🇸"),
        Language(name: "Français", code: "fr", flag: "🇫🇷"),
        Language(name: "Deutsch", code: "de", flag: "🇩🇪"),
        Language(name: "Italiano", code: "it", flag: "🇮🇹"),
        Language(name: "Русский", code: "ru", flag: "🇷🇺"),
        Language(name: "العربية", code: "ar", flag: "🇸🇦"),
        Language(name: "हिन्दी", code: "hi", flag: "🇮🇳")
    ]
} 