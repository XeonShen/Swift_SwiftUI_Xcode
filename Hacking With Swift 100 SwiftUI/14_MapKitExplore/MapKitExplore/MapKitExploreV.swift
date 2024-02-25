import SwiftUI
import MapKit

struct MapKitExploreV: View {
    
//MARK: - Constants and Vars
    
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
                           span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)))
    
    @State private var locations = [Location]()
    @State private var selectedLocation: Location?
    
//MARK: - Body
    
    var body: some View {
        MapReader { proxy in
            Map(initialPosition: startPosition) {
                
//MARK: - Show all locations on map
                
                ForEach(locations) { location in
                    Annotation(location.name, coordinate: location.coordinate) {
                        Image(systemName: "star.circle")
                            .resizable()
                            .foregroundColor(.red)
                            .frame(width: 20, height: 20)
                            .background(.white)
                            .clipShape(.circle)
                            .onLongPressGesture { selectedLocation = location }
                    }
                }
            
                
//MARK: - Adjust map style
                
            }
            .mapStyle(.hybrid)
            
//MARK: - Add the tapped location
            
            .onTapGesture { position in
                if let coordinate = proxy.convert(position, from: .local) {
                    let tappedLocation = Location(id: UUID(), name: "New Location", description: "", latitude: coordinate.latitude, longitude: coordinate.longitude)
                    locations.append(tappedLocation)
                }
            }
            
//MARK: - Show a menu to edit location detail
            
            .sheet(item: $selectedLocation) { location in
                EditLocationV(location: location) { newLocation in
                    if let index = locations.firstIndex(of: location) {
                        locations[index] = newLocation
                    }
                }
            }
        }
    }
}

//MARK: - Preview

#Preview {
    MapKitExploreV()
}
