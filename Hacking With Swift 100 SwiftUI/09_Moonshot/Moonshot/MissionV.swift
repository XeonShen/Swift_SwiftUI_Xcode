import SwiftUI

struct MissionV: View {
    
//MARK: - Constants and Vars
    
    let mission: MissionM
    let crew: [CrewMember]
    
//MARK: - Initializer
    
    init(mission: MissionM, astronauts: [String: AstronautM]) {
        self.mission = mission
        self.crew = mission.crew.map { member in
            if let astronaut = astronauts[member.name] {
                return CrewMember(role: member.role, astronaut: astronaut)
            } else {
                fatalError("Missing \(member.name)")
            }
        }
    }
    
//MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width * 0.6)
                    
                    Text(mission.launchDate?.formatted(date: .complete, time: .complete) ?? "Launch date unclear")
                        .foregroundStyle(.secondary)
                        .padding(.top)
                    
                    VStack(alignment: .leading) {
                        Divider()
                        
                        Text("Mission Highlights")
                            .font(.title.bold())
                            .padding(.bottom, 5)
                        
                        Text(mission.description)
                        
                        Rectangle()
                            .frame(height: 2)
                            .foregroundStyle(.lightBackground)
                            .padding(.vertical)
                        
                        Text("Crew")
                            .font(.title)
                            .padding(.bottom, 5)
                    }
                    .padding(.horizontal)
                    
                    MissionViewHorizentalScroll(crew: crew)

                }
                .padding(.bottom)
            }
            .navigationTitle(mission.displayName)
            .navigationBarTitleDisplayMode(.inline)
            .background(.darkBackground)
        }
    }
}

//MARK: - Body Components

struct MissionViewHorizentalScroll: View {
    var crew: [CrewMember]
    
    var body: some View{
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.role) { crewMember in
                    NavigationLink {
                        AstronautV(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )
                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .foregroundStyle(.white)
                                    .font(.headline)
                                Text(crewMember.role)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

struct Divider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

//MARK: - Preview

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        let missions: [MissionM] = Bundle.main.decode("missions.json")
        let astronauts: [String: AstronautM] = Bundle.main.decode("astronauts.json")
        
        return MissionV(mission: missions[0], astronauts: astronauts)
            .preferredColorScheme(.dark)
    }
}
