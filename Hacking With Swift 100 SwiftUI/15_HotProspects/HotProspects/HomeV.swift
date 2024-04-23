import SwiftUI

struct HomeV: View {
    
    var body: some View {
        TabView {
            ProspectsV(filter: .none)
                .tabItem {
                    Label("Everyone", systemImage: "person.3")
                }
            
            ProspectsV(filter: .contacted)
                .tabItem {
                    Label("Contacted", systemImage: "checkmark.circle")
                }
            
            ProspectsV(filter: .uncontacted)
                .tabItem {
                    Label("Uncontacted", systemImage: "questionmark.diamond")
                }
            
            MeV()
                .tabItem {
                    Label("Me", systemImage: "person.crop.square")
                }
        }
    }
}

#Preview {
    HomeV()
}
