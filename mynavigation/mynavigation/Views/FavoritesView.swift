import SwiftUI

struct FavoritesView: View {
    let favoriteLocations = [
        "Covent Garden",
        "Oxford",
        "White City"
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Add Places Button
                Button(action: {
                    // Add places action
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add Places")
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                
                // Favorite locations list
                List(favoriteLocations, id: \.self) { location in
                    NavigationLink(destination: Text(location)) {
                        Text(location)
                    }
                }
            }
            .navigationTitle("Favourites")
        }
    }
} 