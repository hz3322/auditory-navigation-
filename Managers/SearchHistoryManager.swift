import Foundation

class SearchHistoryManager: ObservableObject {
    private let maxHistoryItems = 50
    private let maxFrequentItems = 3
    private let userDefaultsKey = "searchHistory"
    private let frequencyKey = "searchFrequency"
    
    @Published private(set) var recentSearches: [String] = []
    @Published private(set) var frequentPlaces: [(place: String, count: Int)] = []
    
    init() {
        loadHistory()
        loadFrequency()
    }
    
    func addSearch(_ destination: String) {
        // Update frequency
        var frequency = UserDefaults.standard.dictionary(forKey: frequencyKey) as? [String: Int] ?? [:]
        frequency[destination] = (frequency[destination] ?? 0) + 1
        UserDefaults.standard.set(frequency, forKey: frequencyKey)
        
        // Update recent searches
        var searches = recentSearches
        if let index = searches.firstIndex(of: destination) {
            searches.remove(at: index)
        }
        searches.insert(destination, at: 0)
        
        // Keep only the most recent 50 searches
        if searches.count > maxHistoryItems {
            searches.removeLast()
        }
        
        // Save and update published properties
        UserDefaults.standard.set(searches, forKey: userDefaultsKey)
        recentSearches = searches
        updateFrequentPlaces(with: frequency)
    }
    
    private func loadHistory() {
        recentSearches = UserDefaults.standard.stringArray(forKey: userDefaultsKey) ?? []
    }
    
    private func loadFrequency() {
        let frequency = UserDefaults.standard.dictionary(forKey: frequencyKey) as? [String: Int] ?? [:]
        updateFrequentPlaces(with: frequency)
    }
    
    private func updateFrequentPlaces(with frequency: [String: Int]) {
        frequentPlaces = frequency
            .sorted { $0.value > $1.value }
            .prefix(maxFrequentItems)
            .map { (place: $0.key, count: $0.value) }
    }
    
    func clearHistory() {
        recentSearches.removeAll()
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
    }
} 