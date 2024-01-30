import SwiftUI

struct AstronautV: View {
    let astronaut: AstronautM
    
    var body: some View {
        ScrollView {
            VStack {
                Image(astronaut.id)
                    .resizable()
                    .scaledToFit()
                Text(astronaut.description)
                    .padding()
            }
        }
        .background(.darkBackground)
        .navigationTitle(astronaut.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static var previews: some View {
        let astronauts: [String: AstronautM] = Bundle.main.decode("astronauts.json")
        return AstronautV(astronaut: astronauts["aldrin"]!)
            .preferredColorScheme(.dark)
    }
}
