import SwiftUI

class EmojiMemoryGame: ObservableObject {
    
//MARK: - Constants and Vars
    
    typealias Card = MemoryGame<String>.Card
    
    private static let emojis = ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎️", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "🚛", "🚜", "🛴", "🚲", "🛵", "🏍️", "🛺", "🚍", "🚘", "🚖", "🚡", "🚠"]
    
    @Published private var model = EmojiMemoryGame.createMemoryGame()
    var cards: Array<Card> { model.cards }

//MARK: - Function - Create a brand new Model
    
    private static func createMemoryGame() -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 8) { pairIndex in EmojiMemoryGame.emojis[pairIndex] }
    }

//MARK: - Functions - Intents passed to Model
    
    func choose(_ card: Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func restart() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}



