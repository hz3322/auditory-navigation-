import SwiftUI
import CoreLocation
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var mapBoxService = MapBoxService()
    @EnvironmentObject private var localizationManager: LocalizationManager
    @EnvironmentObject private var navigationViewStore: NavigationViewStore
    @State private var searchText = ""
    @State private var errorMessage: String?
    
    let frequentLocations = [
        "Victoria Station",
        "Liverpool Street",
        "Paddington"
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
                
                VStack(spacing: 24) {
                    // Search bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                        TextField("Enter destination".localized, text: $searchText)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                    )
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    // Frequently used section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Frequently used".localized)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ForEach(frequentLocations, id: \.self) { location in
                            NavigationLink(
                                destination: NavigationDetailView(destination: location),
                                tag: location,
                                selection: $navigationViewStore.selection
                            ) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(location)
                                            .font(.headline)
                                        if let duration = mapBoxService.estimatedTimes[location] {
                                            Text(formatDuration(duration))
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        } else {
                                            Text("Calculating...")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray.opacity(0.3))
                                )
                            }
                            .foregroundColor(.primary)
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .navigationTitle("Start your trip!".localized)
            .navigationBarItems(trailing: Button(action: {
                // Profile image action
            }) {
                Image(systemName: "person.circle")
                    .font(.title2)
            })
        }
        .onChange(of: locationManager.location) { newLocation in
            guard let location = newLocation else { return }
            updateEstimatedTimes(from: location)
        }
    }
    
    private func updateEstimatedTimes(from location: CLLocation) {
        Task {
            for destination in frequentLocations {
                do {
                    let time = try await mapBoxService.getEstimatedTime(from: location, to: destination)
                    await MainActor.run {
                        mapBoxService.estimatedTimes[destination] = time
                        errorMessage = nil
                    }
                } catch {
                    print("Error getting time estimate for \(destination): \(error)")
                    await MainActor.run {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let minutes = Int(duration / 60)
        return "\(minutes) min"
    }
}

#Preview {
    NavigationView {
        HomeView()
            .environmentObject(LocalizationManager())
            .environmentObject(NavigationViewStore())
    }
} 
