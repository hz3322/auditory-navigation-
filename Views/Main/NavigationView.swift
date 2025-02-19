import SwiftUI

struct NavigationView: View {
    let destination: String
    @State private var currentStep: NavigationStep
    @State private var advisoryMessages: [AdvisoryMessage] = []
    
    init(destination: String) {
        self.destination = destination
        self._currentStep = State(initialValue: NavigationStep(
            location: "Platform 1",
            timeToNext: 3,
            nextLocation: "Gloucester Road",
            totalRemainingTime: 11
        ))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Status Bar
            statusBar
            
            // Main Navigation Content
            ScrollView {
                VStack(spacing: 16) {
                    // Current Step Information
                    stepInformation
                    
                    // Advisory Messages
                    advisorySection
                    
                    // Route Timeline
                    routeTimeline
                }
                .padding()
            }
        }
        .navigationTitle(destination)
    }
    
    private var statusBar: some View {
        HStack(spacing: 12) {
            // Walking time to next point
            TimeBox(minutes: currentStep.timeToNext, label: "Walk")
            
            // Inner walking time
            TimeBox(minutes: currentStep.timeToNext, label: "Inner Walking")
            
            Spacer()
            
            // Total time display
            Text("\(currentStep.totalRemainingTime):20")
                .font(.title2)
                .bold()
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(radius: 2)
    }
    
    private var stepInformation: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(currentStep.location)
                .font(.title2)
                .bold()
            
            HStack {
                Image(systemName: "arrow.down")
                Text("\(currentStep.timeToNext) min")
                    .foregroundColor(.green)
            }
            
            Text(currentStep.nextLocation)
                .font(.title3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var advisorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Auditory Advisory")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 12) {
                AdvisoryItem(type: .trainDelay, message: "10 min delay on Central line")
                AdvisoryItem(type: .arrival, message: "Next train arrives in 3 minutes")
                AdvisoryItem(type: .safety, message: "Mind the gap between train and platform")
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var routeTimeline: some View {
        VStack(alignment: .leading, spacing: 16) {
            TimelineItem(
                station: "Notting Hill Gate",
                time: "11:20",
                duration: "6 min",
                isLast: false
            )
            
            TimelineItem(
                station: "Holland Park",
                time: "11:26",
                duration: "Arrival",
                isLast: true
            )
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct TimeBox: View {
    let minutes: Int
    let label: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(minutes) min")
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

struct AdvisoryItem: View {
    let type: AdvisoryType
    let message: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: type.iconName)
                .foregroundColor(type.color)
            Text(message)
        }
    }
}

struct TimelineItem: View {
    let station: String
    let time: String
    let duration: String
    let isLast: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(station)
                    .font(.headline)
                Text(time)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text(duration)
                .foregroundColor(.green)
        }
    }
}

// Models
struct NavigationStep {
    let location: String
    let timeToNext: Int
    let nextLocation: String
    let totalRemainingTime: Int
}

enum AdvisoryType {
    case trainDelay
    case arrival
    case safety
    
    var iconName: String {
        switch self {
        case .trainDelay: return "exclamationmark.triangle.fill"
        case .arrival: return "train.side.front.car"
        case .safety: return "exclamationmark.circle.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .trainDelay: return .red
        case .arrival: return .blue
        case .safety: return .yellow
        }
    }
}

struct AdvisoryMessage {
    let type: AdvisoryType
    let message: String
}

#Preview {
    NavigationView(destination: "Gloucester Road")
} 