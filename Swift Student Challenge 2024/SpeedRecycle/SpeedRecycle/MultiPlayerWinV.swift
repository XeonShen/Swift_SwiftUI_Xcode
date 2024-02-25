import SwiftUI
import Vortex

struct MultiPlayerWinV: View {
    @Environment(\.dismiss) private var dismiss
    var isWin: Bool = true
    var congretsWord: String
    
    @State private var emojiPosition: CGPoint = CGPoint(x: 100, y: 100)
    @State private var emojiOpacity: Double = 0.0
    @State private var emojiScale: CGFloat = 0.1
    let screenSize = UIScreen.main.bounds

    func animateEmoji() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            //appear with scaling up
            withAnimation(Animation.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0.5)) {
                self.emojiOpacity = 1.0
                self.emojiScale = 1
            }
            //wait a bit, disappear with scaling down
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(Animation.spring(response: 0.45, dampingFraction: 0.65, blendDuration: 0.5)) {
                    self.emojiOpacity = 0.0
                    self.emojiScale = 0.1
                }
            }
            //generate random positon
            let newX = CGFloat.random(in: 200...screenSize.width - 200)
            let newY = CGFloat.random(in: 200...screenSize.height - 200)
            //move emoji to random position
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.emojiPosition = CGPoint(x: newX, y: newY)
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.yellow.opacity(0.1)
                .ignoresSafeArea()
            
//MARK: - Background Emojis
            
            Text(isWin ? "🤩" : "💪")
                .font(.system(size: 600))
                .opacity(0.75)
                .rotationEffect(Angle(degrees: 90))
                .offset(x: 0,
                        y: UIScreen.main.bounds.height / 2)
            
            Text(isWin ? "😎" : "✊")
                .font(.system(size: 600))
                .opacity(0.75)
                .rotationEffect(Angle(degrees: 90))
                .offset(x: 0,
                        y: -UIScreen.main.bounds.height / 2)
            
//MARK: - Special Effects
            
            if isWin {
                Text("🎉")
                    .font(.system(size: 150))
                    .opacity(emojiOpacity)
                    .scaleEffect(emojiScale)
                    .position(emojiPosition)
                    .rotationEffect(Angle(degrees: 90))
                    .onAppear {
                        animateEmoji()
                    }
                
                VortexView(.fireworks) {
                    Circle()
                        .fill(.white)
                        .blendMode(.plusLighter)
                        .frame(width: 64)
                        .tag("circle")
                }
                .rotationEffect(Angle(degrees: 90))
            }
            
//MARK: - Titles
            
            VStack {
                Text(isWin ? "You Win!" : "You Lose")
                    .font(.system(size: 90))
                    .bold()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 30)
                Text(congretsWord)
                    .font(.system(size: 60))
                    .bold()
                    .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .leading, endPoint: .trailing))
                    
                Button("Return") {
                    dismiss()
                }
                .frame(width: 300, height: 80)
                .font(.system(size: 55))
                .bold()
                .foregroundColor(.white)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 35))
                .padding(30)
            }
            .rotationEffect(Angle(degrees: 90))
        }
    }
}

#Preview {
    MultiPlayerWinV(congretsWord: "Congratulations, Player One!")
}
