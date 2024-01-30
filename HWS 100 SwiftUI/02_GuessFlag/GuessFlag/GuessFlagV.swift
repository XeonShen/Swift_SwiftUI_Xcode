import SwiftUI

struct GuessFlagV: View {
    
//MARK: - Constants and Vars
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var roundIsOver = false
    @State private var answerIsCorrect = false
    @State private var gameIsOver = false
    
    @State private var round = 0
    @State private var score: Int = 0
    
    @State private var scoreMessage = ""
    @State private var alertMessage = ""

//MARK: - Functions
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreMessage = "Correct"
            answerIsCorrect.toggle()
            score += 1
            alertMessage = "Correct! The answer is \(countries[number])"
        } else {
            scoreMessage = "Wrong"
            if score > 0 {
                score -= 1
            }
            alertMessage = "Wrong! You picked \(countries[number])"
        }
        roundIsOver = true
        if round == 3 {
            round += 1
            gameIsOver = true
        } else if round < 3 {
            round += 1
        }
    }
    
    func resetRound() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        answerIsCorrect = false
    }
    
    func resetGame() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        answerIsCorrect = false
        roundIsOver = false
        gameIsOver = false
        round = 0
        score = 0
        scoreMessage = ""
        alertMessage = ""
    }
    
//MARK: - Body Components
    
    var background: some View {
        RadialGradient(stops: [
            .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
            .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
        ], center: .top,startRadius: 200, endRadius: 700)
    }
    
    var flags: some View {
        VStack(spacing: 30) {
            VStack {
                Text("Tap the flag of")
                    .foregroundColor(.secondary)
                    .font(.subheadline.weight(.heavy))
                Text(countries[correctAnswer])
                    .font(.largeTitle.weight(.semibold))
            }
            
            ForEach(0..<3) { number in
                Button {
                    flagTapped(number)
                } label: {
                    Image(countries[number])
                        .shadow(radius: 5)
                        .clipShape(Capsule())
                }
                .rotation3DEffect(Angle(degrees: (answerIsCorrect && number == correctAnswer) ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                .opacity((answerIsCorrect && number != correctAnswer) ? 0.25 : 1)
                .scaleEffect((answerIsCorrect && number != correctAnswer) ? 0.5 : 1)
                .animation(.default, value: answerIsCorrect)
            }
        }
    }
    
//MARK: - Body
    
    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                flags
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                Spacer()
                Spacer()
                Text("Round: \(round), Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        
//MARK: - Alert windows
        
        .alert(scoreMessage, isPresented: $roundIsOver) {
            Button("Continue", action: resetRound)
        } message: { Text(alertMessage) }
        
        .alert("Game is over", isPresented: $gameIsOver) {
            Button("Retry", action: resetGame)
        } message: { Text("You played \(round), Score: \(score)") }
        
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GuessFlagV()
    }
}
