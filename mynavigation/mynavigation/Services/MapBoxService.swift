import CoreLocation

class MapBoxService: ObservableObject {
    private let accessToken = "pk.eyJ1IjoiaHozMzIyIiwiYSI6ImNtN2NqYXp1YzBtNzQycXNlc2F4dGw4a2UifQ.rnTTN16UNXPvUgNipV36Kw"
    private let baseURL = "https://api.mapbox.com"
    
    @Published var estimatedTimes: [String: TimeInterval] = [:]
    
    func getEstimatedTime(from userLocation: CLLocation, to destination: String) async throws -> TimeInterval {
        // URL encode the destination
        guard let encodedDestination = destination.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw URLError(.badURL)
        }
        
        // Convert destination to coordinates using MapBox Geocoding API
        let geocodingURL = "\(baseURL)/geocoding/v5/mapbox.places/\(encodedDestination).json?access_token=\(accessToken)"
        
        print("Geocoding URL: \(geocodingURL)")
        
        guard let url = URL(string: geocodingURL) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            print("Geocoding Response: \(String(data: data, encoding: .utf8) ?? "")")
            
            let geocodingResponse = try JSONDecoder().decode(GeocodingResponse.self, from: data)
            
            guard let coordinates = geocodingResponse.features.first?.center else {
                throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Location not found"])
            }
            
            // Get directions and time estimate using MapBox Directions API
            let directionsURL = "\(baseURL)/directions/v5/mapbox/driving/\(userLocation.coordinate.longitude),\(userLocation.coordinate.latitude);\(coordinates[0]),\(coordinates[1])?access_token=\(accessToken)"
            
            print("Directions URL: \(directionsURL)")
            
            guard let directionsRequestURL = URL(string: directionsURL) else {
                throw URLError(.badURL)
            }
            
            let (directionsData, _) = try await URLSession.shared.data(from: directionsRequestURL)
            print("Directions Response: \(String(data: directionsData, encoding: .utf8) ?? "")")
            
            let directionsResult = try JSONDecoder().decode(DirectionsResponse.self, from: directionsData)
            return directionsResult.routes.first?.duration ?? 0
        } catch {
            print("Error in API call: \(error)")
            throw error
        }
    }
} 