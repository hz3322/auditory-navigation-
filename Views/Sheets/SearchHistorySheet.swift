import SwiftUI

struct SearchHistorySheet: View {
    let searchHistory: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        NavigationView {
            List(searchHistory, id: \.self) { place in
                Button(action: { onSelect(place) }) {
                    HStack {
                        Image(systemName: "clock")
                        Text(place)
                    }
                }
            }
            .navigationTitle("Recent Searches")
        }
    }
} 