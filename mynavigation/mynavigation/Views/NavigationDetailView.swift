import SwiftUI
import MapKit

struct NavigationDetailView: View {
    @EnvironmentObject private var localizationManager: LocalizationManager
    let destination: String
    @State private var totalTimeToPlatform: Int = 6 // 3 min walk + 3 min inner walk
    @State private var platformNumber: String = "1"
    
    // Route information
    @State private var currentLocation: String = "Your location"
    @State private var firstWalkTime: Int = 3
    @State private var nearestStation: String = "Gloucester Road Station"
    @State private var nearestStationTime: String = "01:35"
    @State private var innerWalkTime: Int = 3 // Time to platform
    @State private var rideStops: Int = 6
    @State private var rideTime: Int = 4
    @State private var finalWalkTime: Int = 4
    
    // Advisory states
    @State private var hasTrainDelay: Bool = false
    @State private var hasArrivalAlert: Bool = false
    @State private var hasSafetySuggestion: Bool = false
    
    // New state for next train time
    @State private var timeToNextTrain: Int = 3 // This would come from your real-time data
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Status Bar with dynamic color
                HStack {
                    StatusBox(
                        time: "\(totalTimeToPlatform)",
                        label: "Time to platform",
                        showWalkingIcon: true,
                        backgroundColor: getStatusColor(timeToNextTrain: timeToNextTrain)
                    )
                }
                .padding(.horizontal)
                
                // Route Details
                ZStack(alignment: .leading) {
                    // Continuous vertical line
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 2)
                        .offset(x: 5) // Align with icons
                    
                    VStack(alignment: .leading, spacing: 12) {
                        // Your location
                        HStack(alignment: .center, spacing: 16) {
                            Circle()
                                .fill(.green)
                                .frame(width: 12, height: 12)
                            Text(currentLocation)
                                .font(.headline)
                            Spacer()
                            Text("01:33")
                                .foregroundColor(.gray)
                        }
                        
                        // Walk time
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 12) // Same width as icons for alignment
                            Image(systemName: "figure.walk")
                                .foregroundColor(.gray)
                            Text("Walk \(firstWalkTime) min")
                                .foregroundColor(.gray)
                        }
                        
                        // Gloucester Station
                        HStack(spacing: 16) {
                            Image(systemName: "tram.fill")
                                .foregroundColor(.blue)
                                .frame(width: 12, height: 12)
                            Text(nearestStation)
                                .font(.headline)
                            Spacer()
                            Text(nearestStationTime)
                                .foregroundColor(.gray)
                        }
                        
                        // Platform
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 12) // Same width as icons for alignment
                            Image(systemName: "signpost.right.fill")
                                .foregroundColor(.orange)
                            Text("Platform \(platformNumber)")
                                .foregroundColor(.gray)
                            Text("(\(innerWalkTime) min)")
                                .foregroundColor(.gray)
                        }
                        
                        // Knightsbridge Station
                        HStack(spacing: 16) {
                            Circle()
                                .fill(.red)
                                .frame(width: 12, height: 12)
                            Text("Knightsbridge Station")
                                .font(.headline)
                            Spacer()
                            Text("01:40")
                                .foregroundColor(.gray)
                        }
                        
                        // Final walk
                        HStack(spacing: 16) {
                            Rectangle()
                                .fill(.clear)
                                .frame(width: 12) // Same width as icons for alignment
                            Image(systemName: "figure.walk")
                                .foregroundColor(.gray)
                            Text("Walk \(finalWalkTime) min")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .shadow(radius: 2)
                .padding(.horizontal)
                
                // Advisory Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Auditory Advisory")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    AdvisoryCard(
                        title: "Train Delay",
                        isActive: hasTrainDelay,
                        systemImage: "exclamationmark.triangle.fill"
                    )
                    
                    AdvisoryCard(
                        title: "Arrival Alert",
                        isActive: hasArrivalAlert,
                        systemImage: "bell.fill"
                    )
                    
                    AdvisoryCard(
                        title: "Safety Suggestion",
                        isActive: hasSafetySuggestion,
                        systemImage: "shield.fill"
                    )
                }
                .padding(.top)
            }
        }
        .navigationTitle("Route Status".localized)
    }
}

struct RouteLineView: View {
    let isWalking: Bool
    let duration: Int
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 2)
                .padding(.leading, 5)
            
            if isWalking {
                HStack {
                    Image(systemName: "figure.walk")
                    Text("Walk \(duration) min")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 12)
            }
        }
        .frame(height: 40)
    }
}

// Helper Views
struct StatusBox: View {
    let time: String
    let label: String
    let showWalkingIcon: Bool
    let backgroundColor: Color
    
    var body: some View {
        VStack {
            HStack(spacing: 4) {
                if showWalkingIcon {
                    Image(systemName: "figure.walk")
                        .font(.title2)
                }
                Text("\(time) min")
                    .font(.title2)
                    .bold()
            }
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(backgroundColor.opacity(0.2))
        .cornerRadius(10)
    }
}

struct AdvisoryCard: View {
    let title: String
    let isActive: Bool
    let systemImage: String
    
    var body: some View {
        HStack {
            Image(systemName: systemImage)
                .foregroundColor(isActive ? .red : .gray)
            Text(title)
                .foregroundColor(isActive ? .primary : .gray)
            Spacer()
            if isActive {
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

// Updated status color function with more comprehensive logic
func getStatusColor(timeToNextTrain: Int) -> Color {
    if timeToNextTrain <= 2 {
        // Critical - You might miss the train
        return .red
    } else if timeToNextTrain <= 4 {
        // Warning - You need to hurry
        return .orange
    } else if timeToNextTrain <= 6 {
        // Caution - You have some time, but stay alert
        return .yellow
    } else {
        // Comfortable - Plenty of time
        return .green
    }
}

#Preview {
    NavigationView {
        NavigationDetailView(destination: "Gloucester Road")
            .environmentObject(LocalizationManager())
    }
} 