import SwiftUI

struct FrequentPlaceButton: View {
    let placeName: String
    let duration: String
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
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
    }
} 