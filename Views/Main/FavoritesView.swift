import SwiftUI

struct FavoritesView: View {
    @State private var favorites = ["Covent Garden", "Oxford", "White City"]
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(favorites, id: \.self) { favorite in
                        Text(favorite)
                    }
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Places")
                    }
                    .foregroundColor(.blue)
                    .padding()
                }
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
} 