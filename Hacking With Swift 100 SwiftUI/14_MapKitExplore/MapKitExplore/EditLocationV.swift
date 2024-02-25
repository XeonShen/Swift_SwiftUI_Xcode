import SwiftUI

struct EditLocationV: View {
    
//MARK: - Constants and Vars
    
    @Environment(\.dismiss) var dismiss
    
    var location: Location
    var saveLocation: (Location) -> Void
    @State private var name: String
    @State private var description: String
    
    @State private var loadingState = LoadingState.loading
    @State private var pages = [Page]()
    
//MARK: - Initializer
    
    //by default, the passed in function will be executed inside the initializer, then never run again.
    //by adding an @escaping means, store the function to a var, then use it later
    init(location: Location, saveLocation: @escaping (Location) -> Void) {
        self.location = location
        self.saveLocation = saveLocation
        //use _ to create an instance from property wrapper directly, rather than data inside property wrapper
        _name = State(initialValue: location.name)
        _description = State(initialValue: location.description)
    }
    
//MARK: - Function - download data form wikipadia
    
    func fetchNearbyPlaces() async {
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "en.wikipedia.org"
        urlComponent.path = "/w/api.php"
        urlComponent.queryItems = [
            URLQueryItem(name: "ggscoord", value: "\(location.latitude)|\(location.longitude)"),
            URLQueryItem(name: "action", value: "query"),
            URLQueryItem(name: "prop", value: "coordinates|pageimages|pageterms"),
            URLQueryItem(name: "colimit", value: "50"),
            URLQueryItem(name: "piprop", value: "thumbnail"),
            URLQueryItem(name: "pithumbsize", value: "500"),
            URLQueryItem(name: "pilimit", value: "50"),
            URLQueryItem(name: "wbptterms", value: "description"),
            URLQueryItem(name: "generator", value: "geosearch"),
            URLQueryItem(name: "ggsradius", value: "10000"),
            URLQueryItem(name: "ggslimit", value: "50"),
            URLQueryItem(name: "format", value: "json")
        ]
        
        guard let wikiNearbyLocationURL = urlComponent.url else {
            print("URL is not correct, check it out!")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: wikiNearbyLocationURL)
            let items = try JSONDecoder().decode(Result.self, from: data)
            pages = items.query.pages.values.sorted()
            loadingState = .loaded
        } catch {
            loadingState = .failed
        }
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                
//MARK: - Modify Location details
                
                Section("Edit name and description") {
                    TextField("Place name:", text: $name)
                    TextField("Description:", text: $description)
                }
                
//MARK: - Show Nearby info if availiable
                
                Section("Nearby...") {
                    switch loadingState {
                    case .loading: Text("Loading...")
                    case .loaded: ForEach(pages, id: \.pageid) { page in
                        Text(page.title + ": ").font(.headline) + Text(page.description).italic()
                        }
                    case .failed: Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            //fetch data immidiatly right after this page awake
            .task {
                await fetchNearbyPlaces()
            }
            
//MARK: - Press button to save location
            
            .toolbar {
                Button("Save") {
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.description = description
                    saveLocation(newLocation)
                    dismiss()
                }
            }
        }
    }
}

//MARK: - Preview

#Preview {
    EditLocationV(location: .exampleLocation) { _ in }
}
