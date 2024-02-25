import SwiftUI

struct ExpenseNoteV: View {
    
//MARK: - Constants and Vars
    
    @ObservedObject private var expenseNoteVM = ExpenseNoteVM()
    @State private var showingAddExpense = false
    @State private var navigationTitle = "ExpenseNote"
    
//MARK: - Body
    
    var body: some View {
        //if the App is unlocked successfully, show the view
        if expenseNoteVM.faceIDIsUnlocked {
            NavigationStack {
                List {
                    Section("Personal Expense") {
                        ForEach(expenseNoteVM.items) { item in
                            if item.type == "Personal" {
                                expenseItemCard(item: item)
                            }
                        }
                        .onDelete(perform: expenseNoteVM.removeItems)
                    }
                    
                    Section("Business Expense") {
                        ForEach(expenseNoteVM.items) { item in
                            if item.type == "Business" {
                                expenseItemCard(item: item)
                            }
                        }
                        .onDelete(perform: expenseNoteVM.removeItems)
                    }
                }
                .navigationTitle($navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button {
                        showingAddExpense = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .sheet(isPresented: $showingAddExpense) {
                    AddExpenseNoteV(expense: expenseNoteVM)
                }
            }
        }
        //if haven't unlocked, press to authenticate
        else {
            Button("Unlock ExpenseNote", action: expenseNoteVM.authenticate)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }
}

//MARK: - Body Components

struct expenseItemCard: View {
    var item: ExpenseNote
    
    var body: some View{
        HStack {
            VStack(alignment: .leading) {
                Text(item.name)
                    .font(.headline)
                Text(item.type)
            }
            Spacer()
            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                .foregroundColor({
                    if item.amount < 10 { return Color.green }
                    else if item.amount < 50 { return Color.yellow }
                    else { return Color.red }
                }())
        }
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseNoteV()
    }
}
