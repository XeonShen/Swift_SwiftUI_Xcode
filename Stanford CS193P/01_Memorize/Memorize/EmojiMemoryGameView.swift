import SwiftUI

struct EmojiMemoryGameView: View {
    
//MARK: - Constants and Vars
    
    @ObservedObject var game: EmojiMemoryGame
    
    @State private var dealt = Set<Int>()
    @Namespace private var dealingNamespace
    
//MARK: - Functions - deal the cards
    
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        return !dealt.contains(card.id)
    }
    
    //custom the animation of every card, so cards can be dealt one by one
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
//MARK: - Function - reverse the index of cards, so they shows correctly in ZStack
    
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
//MARK: - Body Components
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: 2 / 3, content: { card in
            if isUndealt(card) || card.isMatched && !card.isFaceUp {
                Color.clear
            } else {
                cardView(card: card)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .padding(4)
                        .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                        .zIndex(zIndex(of: card))
                        .onTapGesture {
                            withAnimation {
                                game.choose(card)
                            }
                        }
            }
        })
        .foregroundColor(CardConstants.color)
    }
    
    var restart: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.restart()
            }
        }
    }
    
    var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                game.shuffle()
            }
        }
    }
    
    var deckBody: some View {
        ZStack{
            ForEach(game.cards.filter(isUndealt)) { card in
                cardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of:card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
//MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                gameBody
                HStack {
                    restart
                    Spacer()
                    shuffle
                }
                .padding(.horizontal)
            }
            .padding()
            deckBody
        }
        .padding()
    }
}

//MARK: - Body Component

struct cardView: View {
    let card: EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaining: Double = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngel: Angle(degrees: (1 - animatedBonusRemaining) * 360 - 90)).fill(.red)
                            .onAppear{
                                animatedBonusRemaining = card.bonusTimeRemainingPersentage
                                withAnimation(.linear(duration: card.bonusTimeRemaining)) {
                                    animatedBonusRemaining = 0
                                }
                            }
                    } else {
                        Pie(startAngle: Angle(degrees: 0 - 90), endAngel: Angle(degrees: (1 - card.bonusTimeRemaining) * 360 - 90)).fill(.red)
                    }
                }
                .opacity(0.5).padding(3)

                Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        return EmojiMemoryGameView(game: game).preferredColorScheme(.dark)
    }
}
