import SwiftUI
import CoreLocation

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var searchHistoryManager = SearchHistoryManager()
    @State private var searchText = ""
    @State private var durations: [String: String] = [:]
    @State private var showingSearchHistory = false
    private let mapboxService = MapboxService()
    
    var body: some View {
        NavigationView {
            VStack {
                // Search bar with history
                SearchBar(text: $searchText, onSubmit: {
                    if !searchText.isEmpty {
                        searchHistoryManager.addSearch(searchText)
                        searchText = ""
                    }
                })
                .padding()
                .onTapGesture {
                    showingSearchHistory = true
                }
                
                // Frequently used section
                VStack(alignment: .leading) {
                    Text("Frequently Used")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    
                    ForEach(searchHistoryManager.frequentPlaces, id: \.place) { place in
                        FrequentPlaceButton(
                            placeName: place.place,
                            duration: durations[place.place] ?? "Calculating..."
                        )
                    }
                }
                
                Spacer()
                
                // Bottom navigation
                HStack {
                    Button(action: {}) {
                        VStack {
                            Image(systemName: "map")
                            Text("Explore")
                        }
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "person")
                    }
                }
                .padding()
            }
            .navigationTitle("Home")
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "gearshape")
            })
            .sheet(isPresented: $showingSearchHistory) {
                SearchHistoryView(
                    searchHistory: searchHistoryManager.recentSearches,
                    onSelect: { place in
                        searchHistoryManager.addSearch(place)
                        showingSearchHistory = false
                    }
                )
            }
            .onAppear {
                locationManager.startUpdating()
            }
            .onChange(of: locationManager.location) { newLocation in
                if let location = newLocation {
                    updateDurations(from: location)
                }
            }
        }
    }
    
    private func updateDurations(from location: CLLocation) {
        Task {
            for place in searchHistoryManager.frequentPlaces {
                do {
                    let duration = try await mapboxService.getTravelTime(
                        from: location,
                        to: place.place
                    )
                    await MainActor.run {
                        durations[place.place] = duration
                    }
                } catch {
                    print("Error getting duration for \(place): \(error)")
                }
            }
        }
    }
}

struct SearchHistoryView: View {
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

struct FrequentPlaceButton: View {
    let placeName: String
    let duration: String
    @State private var isNavigating = false
    
    var body: some View {
        Button(action: {
            isNavigating = true
        }) {
            HStack {
                VStack(alignment: .leading) {
                    Text(placeName)
                        .font(.headline)
                    Text(duration)
                        .font(.subheadline)
                        .foregroundColor(.green)
                }
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .navigationDestination(isPresented: $isNavigating) {
            NavigationView(destination: placeName)
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSubmit: () -> Void = {}
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            TextField("Enter destination", text: $text)
                .onSubmit(onSubmit)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    HomeView()
} 