import SwiftUI

struct ExpenseNoteV: View {
    
//MARK: - Constants and Vars
    
    @ObservedObject private var expense = ExpenseNote()
    @State private var showingAddExpense = false
    @State private var navigationTitle = "ExpenseNote"
    
//MARK: - Functions
    
    func removeItems(at offsets: IndexSet) {
        expense.items.remove(atOffsets: offsets)
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal Expense") {
                    ForEach(expense.items) { item in
                        if item.type == "Personal" {
                            expenseItemCard(item: item)
                        }
                    }
                    .onDelete(perform: removeItems)
                }
                
                Section("Business Expense") {
                    ForEach(expense.items) { item in
                        if item.type == "Business" {
                            expenseItemCard(item: item)
                        }
                    }
                    .onDelete(perform: removeItems)
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
                AddView(expense: expense)
            }
        }
    }
}

//MARK: - Body Components

struct expenseItemCard: View {
    var item: ExpenseItem
    
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
                    if item.amount < 10 {
                        return Color.green
                    } else if item.amount < 50 {
                        return Color.yellow
                    } else {
                        return Color.red
                    }
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
