import Foundation

struct MemoryGame<CardContant> where CardContant: Equatable {
    
    struct Card: Identifiable{
        
//MARK: - Basic Properties
        
        let id: Int
        var isFaceUp = false {
            didSet {
                if isFaceUp {
                    startUsingBonusTime()
                } else {
                    stopUsingBonusTime()
                }
            }
        }
        var isMatched = false {
            didSet {
                stopUsingBonusTime()
            }
        }
        let content: CardContant
        
//MARK: - Bonus Time Properties
        
        var bonusTimeLimit: TimeInterval = 6
        var lastFaceUpDate: Date?
        var pastFaceUpTime: TimeInterval = 0
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        var bonusTimeRemaining: TimeInterval {
            max(0, bonusTimeLimit - faceUpTime)
        }
        var bonusTimeRemainingPersentage: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining / bonusTimeLimit : 0
        }
        var isConsumingBonusTime: Bool{
            isFaceUp && !isMatched && bonusTimeRemaining > 0
        }
        var isEarnedBonus: Bool {
            isMatched && bonusTimeRemaining > 0
        }
        
//MARK: - Bonus Time Functions
        
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil{
                lastFaceUpDate = Date()
            }
        }
        
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
    }
    
//MARK: - Cards Properties
    
    private(set) var cards: Array<Card>
    private var indexOfTheOneAndOnlyFacedUpCard: Int? {
        get {
            return cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
        }
        set {
            cards.indices.forEach({ index in
                cards[index].isFaceUp = (index == newValue) })
        }
    }
    
//MARK: - Initializer of Cards
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContant) {
        cards = []
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(id:pairIndex * 2, content: content))
            cards.append(Card(id:pairIndex * 2 + 1,content: content))
        }
        cards.shuffle()
    }
    
//MARK: - Cards Functions
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[chosenIndex].isFaceUp,
            !cards[chosenIndex].isMatched {
            if let lastChosenIndex = indexOfTheOneAndOnlyFacedUpCard {
                if cards[chosenIndex].content == cards[lastChosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[lastChosenIndex].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                indexOfTheOneAndOnlyFacedUpCard = chosenIndex
            }

        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
}
