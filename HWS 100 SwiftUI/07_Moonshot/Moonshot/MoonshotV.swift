import SwiftUI

struct MoonshotV: View {
    
//MARK: - Constants and Vars
    
    let astronauts: [String: AstronautM] = Bundle.main.decode("astronauts.json")
    let missions: [MissionM] = Bundle.main.decode("missions.json")
    
    @State private var isShowingScrollView = true
    let columns = [GridItem(.adaptive(minimum: 150))]
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            
//MARK: - Scroll View
            
            if isShowingScrollView {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        ForEach(missions) { mission in
                            NavigationLink(value: mission) {
                                
                                VStack {
                                    Image(mission.image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .padding()
                                    VStack {
                                        Text(mission.displayName)
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                        Text(mission.formattedLaunchDate)
                                            .font(.caption)
                                            .foregroundStyle(.white.opacity(0.5))
                                    }
                                    .padding(.vertical)
                                    .frame(maxWidth: .infinity)
                                    .background(.lightBackground)
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.lightBackground)
                                )
                            }
                            
                            .navigationDestination(for: MissionM.self) { mission in
                                MissionV(mission: mission, astronauts: astronauts)
                            }
                        }
                    }
                    .padding([.horizontal, .bottom])
                    
                }
                .navigationTitle("Moonshot")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .toolbar {
                    Button {
                        isShowingScrollView.toggle()
                    } label: {
                        Image(systemName: "arrowshape.right")
                    }
                }
            }
            
//MARK: - List View
            
            else {
                List {
                    ForEach(missions) { mission in
                        NavigationLink(destination: MissionV(mission: mission, astronauts: astronauts)) {
                            HStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                Spacer()
                                VStack {
                                    Text(mission.displayName)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(mission.formattedLaunchDate)
                                        .font(.caption)
                                        .foregroundStyle(.white.opacity(0.5))
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Moonshot")
                .background(.darkBackground)
                .preferredColorScheme(.dark)
                .navigationTitle("iExpense")
                .toolbar {
                    Button {
                        isShowingScrollView.toggle()
                    } label: {
                        Image(systemName: "arrowshape.right")
                    }
                }
            }
            
        }
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MoonshotV()
    }
}
