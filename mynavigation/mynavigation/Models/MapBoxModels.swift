import Foundation

struct GeocodingResponse: Codable {
    let features: [Feature]
}

struct Feature: Codable {
    let center: [Double]
    let place_name: String?
}

struct DirectionsResponse: Codable {
    let routes: [Route]
    
    enum CodingKeys: String, CodingKey {
        case routes
    }
}

struct Route: Codable {
    let duration: Double
    
    enum CodingKeys: String, CodingKey {
        case duration
    }
} 