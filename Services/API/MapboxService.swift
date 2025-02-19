import Foundation
import CoreLocation

class MapboxService {
    private let accessToken = "pk.eyJ1IjoiaHozMzIyIiwiYSI6ImNtN2NqYXp1YzBtNzQycXNlc2F4dGw4a2UifQ.rnTTN16UNXPvUgNipV36Kw"
    private let baseURL = "https://api.mapbox.com"
    
    // Rate limit tracking
    private var remainingRequests: Int = 300 // Default Directions API limit
    private var resetTime: Date?
    
    func getTravelTime(from origin: CLLocation, to destination: String) async throws -> String {
        // Check rate limits before making request
        if remainingRequests <= 0 {
            if let resetTime = resetTime, Date() < resetTime {
                throw NSError(domain: "", code: 429, userInfo: [
                    NSLocalizedDescriptionKey: "Rate limit exceeded. Try again after \(resetTime)"
                ])
            }
        }
        
        // First get coordinates for destination using Geocoding API
        // Note: Geocoding API has 600 requests/minute limit
        let geocodingUrl = "\(baseURL)/geocoding/v5/mapbox.places/\(destination).json"
        
        var urlComponents = URLComponents(string: geocodingUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "limit", value: "1") // Only need first result
        ]
        
        guard let url = urlComponents?.url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (geocodeData, response) = try await URLSession.shared.data(from: url)
        
        // Handle rate limit headers
        if let httpResponse = response as? HTTPURLResponse {
            updateRateLimits(from: httpResponse)
        }
        
        let geocodeResponse = try JSONDecoder().decode(GeocodeResponse.self, from: geocodeData)
        
        guard let coordinates = geocodeResponse.features.first?.center else {
            throw NSError(domain: "", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "Location not found"
            ])
        }
        
        // Then get directions using Directions API
        // Format: longitude,latitude for coordinates
        let originCoord = "\(origin.coordinate.longitude),\(origin.coordinate.latitude)"
        let destCoord = "\(coordinates[0]),\(coordinates[1])"
        
        let directionsUrl = "\(baseURL)/directions/v5/mapbox/walking/\(originCoord);\(destCoord)"
        
        urlComponents = URLComponents(string: directionsUrl)
        urlComponents?.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken),
            URLQueryItem(name: "overview", value: "false"), // Don't need route geometry
            URLQueryItem(name: "annotations", value: "duration") // Only need duration
        ]
        
        guard let directionUrl = urlComponents?.url else {
            throw URLError(.badURL)
        }
        
        request = URLRequest(url: directionUrl)
        request.httpMethod = "GET"
        
        let (directionData, directionResponse) = try await URLSession.shared.data(from: directionUrl)
        
        // Handle rate limit headers
        if let httpResponse = directionResponse as? HTTPURLResponse {
            updateRateLimits(from: httpResponse)
        }
        
        let directionResult = try JSONDecoder().decode(DirectionsResponse.self, from: directionData)
        
        guard let duration = directionResult.routes.first?.duration else {
            throw NSError(domain: "", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "No route found"
            ])
        }
        
        // Convert duration from seconds to minutes
        let minutes = Int(ceil(duration / 60))
        return "\(minutes) min"
    }
    
    private func updateRateLimits(from response: HTTPURLResponse) {
        if let limitInterval = response.value(forHTTPHeaderField: "X-Rate-Limit-Interval"),
           let limitValue = response.value(forHTTPHeaderField: "X-Rate-Limit-Limit"),
           let resetValue = response.value(forHTTPHeaderField: "X-Rate-Limit-Reset"),
           let interval = Int(limitInterval),
           let limit = Int(limitValue),
           let resetTimestamp = Double(resetValue) {
            
            remainingRequests = limit
            resetTime = Date(timeIntervalSince1970: resetTimestamp)
        }
    }
}

// Response models for Geocoding
struct GeocodeResponse: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let center: [Double]
}

// Response models for Directions
struct DirectionsResponse: Codable {
    let routes: [Route]
}

struct Route: Codable {
    let duration: Double
} 