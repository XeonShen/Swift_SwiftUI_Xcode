import SwiftUI

class SinglePlayerVM: ObservableObject {
    @Published var recycleItemM = RecycleItemM()
    var items: Array<RecycleItemM.item> { recycleItemM.items }
    
//MARK: - Round Counting Down

    @Published var roundIsOver: Bool?
    @Published var roundTimeLeft: Int = 110
    @Published var roundScore: Int = 0
    @Published var disableComponent = true
    @Published var playerWin = false
    
    private var timer: Timer?
        
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            self.roundTimeLeft -= 1
            //if lose
            if self.roundTimeLeft <= 0 {
                disableComponent = true
                resetRound()
                self.roundIsOver = true
                self.timer?.invalidate()
            }
            //if win
            if items.count == 0 {
                disableComponent = true
                resetRound()
                self.roundIsOver = true
                self.playerWin = true
                self.timer?.invalidate()
            }
        }
    }
    
//MARK: - Trash Classification
    
    //trashbin animation properties
    @Published var trashbinScaleDictionary: [String: Bool] = 
    ["biodegradable": false, "donate": false, "food": false, "liquid": false, "nonrecyclable": false, "recyclable": false]
    @Published var trashbinShakeDictionary: [String: CGFloat] = 
    ["biodegradable": 0, "donate": 0, "food": 0, "liquid": 0, "nonrecyclable": 0, "recyclable": 0]
    
    //when drop trash on trash bin, this func executed
    func classifyTrash(item: NSSecureCoding?, category: RecycleItemM.Categories) {
        guard let item = item as? Data,
              let jsonString = String(data: item, encoding: .utf8),
              let jsonData = jsonString.data(using: .utf8)
        else { return }
        
        if let decodedObject = try? JSONDecoder().decode(RecycleItemM.item.self, from: jsonData) {
            DispatchQueue.main.async {
                //create names for each catagories
                var catagoryName: String
                switch category {
                case .biodegradable: catagoryName = "biodegradable"
                case .donate: catagoryName = "donate"
                case .food: catagoryName = "food"
                case .liquid: catagoryName = "liquid"
                case .nonrecyclable: catagoryName = "nonrecyclable"
                case .recyclable: catagoryName = "recyclable"
                }
                //if the category is right
                if decodedObject.category == category {
                    //if contains liquid, return empty bottle
                    if decodedObject.name == "Alcohol in Bottle" {
                        let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                        self.recycleItemM.insertEmptyAlcoholBottle(at: index)
                    }
                    if decodedObject.name == "Water Bottle" {
                        let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                        self.recycleItemM.insertEmptyPlasticBottle(at: index)
                    }
                    if decodedObject.name == "Ice in Glass" {
                        let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                        self.recycleItemM.insertemptyGlass(at: index)
                    }
                    if decodedObject.name == "Coffee" {
                        let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                        self.recycleItemM.insertPaperCup(at: index)
                    }
                    if decodedObject.name == "Cup Of Water" {
                        let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                        self.recycleItemM.insertPaperCup(at: index)
                    }
                    //find the item then delete
                    let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                        self.removeItem(at: index)
                    }
                    //scale the trashbin
                    withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                        self.trashbinScaleDictionary[catagoryName] = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                            self.trashbinScaleDictionary[catagoryName] = false
                        }
                    }
                    //add score
                    self.addRoundScore()
                }
                //if category wrong
                else {
                    //handle subcatagory
                    if decodedObject.subCategory != nil {
                        if (decodedObject.subCategory!) == category {
                            let index = self.items.firstIndex { $0.id == decodedObject.id } ?? 0
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0.5)) {
                                self.removeItem(at: index)
                            }
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                                self.trashbinScaleDictionary[catagoryName] = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.spring(response: 0.2, dampingFraction: 0.5, blendDuration: 0)) {
                                    self.trashbinScaleDictionary[catagoryName] = false
                                }
                            }
                            self.addBonusScore()
                        }
                        else {
                            withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = -20 }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = 20 }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = -20 }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = 20 }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = 0 }
                            }
                            self.minusRoundScore()
                        }
                    }
                    else {
                        //shake trash bin left to right
                        withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = -20 }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = 20 }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = -20 }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = 20 }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.default) { self.trashbinShakeDictionary[catagoryName] = 0 }
                        }
                        //minus score
                        self.minusRoundScore()
                    }
                }
            }
        }
    }
    
    
//MARK: - Functions - Intents
    
    func removeItem(at index: Int) {
        recycleItemM.items.remove(at: index)
    }
    
    func resetRound() {
        recycleItemM.resetRound()
    }
    
    func addRoundScore() {
        roundScore += 10
    }
    
    func addBonusScore() {
        roundScore += 15
    }
    
    func minusRoundScore() {
        roundScore -= 5
        if roundScore < 0 {
            roundScore = 0
        }
    }

}

