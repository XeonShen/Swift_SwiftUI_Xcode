import SwiftUI

struct CardEditV: View {
    
//MARK: - Constants & Vars
    
    @Environment(\.dismiss) var dismiss
    
    @State private var cards = [Card]()
    
    @State private var newPrompt = ""
    @State private var newAnswer = ""
    
//MARK: - Functions
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                cards = decoded
            }
        }
    }
    
    func saveData() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: "Cards")
        }
    }
    
    func addCard() {
        let trimmedPrompt = newPrompt.trimmingCharacters(in: .whitespaces)
        let trimmedAnswer = newAnswer.trimmingCharacters(in: .whitespaces)
        guard trimmedPrompt.isEmpty == false && trimmedAnswer.isEmpty == false else { return }
        cards.insert(Card(prompt: trimmedPrompt, answer: trimmedAnswer), at: 0)
        saveData()
        newPrompt = ""
        newAnswer = ""
    }
    
    func removeCard(at offset: IndexSet) {
        cards.remove(atOffsets: offset)
        saveData()
    }
    
//MARK: -  Body
    
    var body: some View {
        NavigationStack {
            List {
                Section("Add new card") {
                    TextField("Prompt", text: $newPrompt)
                    TextField("Answer", text: $newAnswer)
                    Button("Add Card", action: addCard)
                }
                
                Section {
                    ForEach(0..<cards.count, id: \.self) { index in
                        VStack(alignment: .leading) {
                            Text(cards[index].prompt)
                                .font(.headline)
                            Text(cards[index].answer)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: removeCard)
                }
            }
            .navigationTitle("Edit Cards")
            .toolbar { Button("Done", action: { dismiss() }) }
            .onAppear(perform: loadData)
        }
    }
}

//MARK: - Preview

#Preview {
    CardEditV()
}
