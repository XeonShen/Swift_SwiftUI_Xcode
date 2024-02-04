import Foundation
import MapKit

struct Location: Codable, Equatable, Identifiable {
    var id: UUID
    var name: String
    var description: String
    var latitude: Double
    var longitude: Double
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
//MARK: - Debug Symbol - these code won't be compiled into release version, for testing perpose only
    
    #if DEBUG
    static let exampleLocation = Location(id: UUID(), name: "Buckingham Palace", description: "Lit by over 40,000 lightbulbs", latitude: 51.501, longitude: -0.141)
    #endif
    
//MARK: - Operation Overload - default Equatable compares every property between 2 structs, this overload save time by compare only the ID
    
    static func ==(lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
}
