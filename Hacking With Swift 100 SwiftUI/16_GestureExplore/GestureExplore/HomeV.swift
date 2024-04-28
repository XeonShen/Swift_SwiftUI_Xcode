import SwiftUI

struct HomeV: View {
    
//MARK: - Constants & Vars
    
    //check whether the iOS accessibility is enabled
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    
    //check whether the APP is in active on iOS
    @Environment(\.scenePhase) var scenePhase
    @State private var isActive = true
    
    @State private var cards = [Card]()
    
    //create a timer counting down from 100
    @State private var timeRemaining = 100
    let timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    
    @State private var showingEditScreen = false
    
//MARK: - Function
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        cards.remove(at: index)
        if cards.isEmpty {
            isActive = false
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
//MARK: - Body
    
    var body: some View {
        ZStack {
            
            //background image
            Image(decorative: "background")
                .resizable()
                .ignoresSafeArea()
            
            VStack {
                
                //time counting down
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.6))
                    .clipShape(.capsule)
                
                //stack of cards
                ZStack {
                    ForEach(0..<cards.count, id: \.self) { index in
                        CardV(card: cards[index],
                              removal: { withAnimation { removeCard(at: index) } })
                        .stacked(at: index, in: cards.count)
                        //only allow user interacting with the top card
                        .allowsHitTesting(index == cards.count - 1)
                        //only show the top card if accessibility is enabled
                        .accessibilityHidden(index < cards.count - 1)
                    }
                }
                .allowsHitTesting(timeRemaining > 0)
                
                //restart game button
                if cards.isEmpty {
                    Button("Start Again", action: resetCards)
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(.capsule)
                }
            }
            
            //edit card view button
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        showingEditScreen = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(.black.opacity(0.7))
                            .clipShape(.circle)
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
            .font(.largeTitle)
            .padding()
            
            //if iOS accessibility is enabled, show this view to color blinded people
            if accessibilityDifferentiateWithoutColor || accessibilityVoiceOverEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button {
                            withAnimation { removeCard(at: cards.count - 1) }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Wrong")
                        .accessibilityHint("Mark your answer as being incorrect.")
                        
                        Spacer()
                        
                        Button {
                            withAnimation { removeCard(at: cards.count - 1) }
                        } label: {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(.black.opacity(0.7))
                                .clipShape(.circle)
                        }
                        .accessibilityLabel("Correct")
                        .accessibilityHint("Mark your answer as being correct.")
                    }
                    .foregroundStyle(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        
        //let this view subscribe to the timer publisher
        .onReceive(timer) { time in
            guard isActive else { return }
            if timeRemaining > 0 {
                timeRemaining -= 1
            }
        }
        
        //track the scenePhase changes
        .onChange(of: scenePhase) {
            if (scenePhase == .active) && (cards.isEmpty == false) {
                isActive = true
            } else {
                isActive = false
            }
        }
        
        //bring up CardEditV
        .sheet(isPresented: $showingEditScreen, onDismiss: resetCards, content: CardEditV.init)
        
        //reset the game when view shows
        .onAppear(perform: resetCards)
        
    }
}

//MARK: - Extension

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(y: offset * 10)
    }
}

//MARK: - Preview

#Preview {
    HomeV()
}
