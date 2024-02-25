import SwiftUI
import SwiftData

struct BookwormV: View {
    
//MARK: - Constants and Vars - related to SwiftData
    
    @Environment(\.modelContext) var modelContext // to store SwiftData, add @Environment
    @Query(sort: [
        SortDescriptor(\BookM.title),
        SortDescriptor(\BookM.author)
    ]) var books: [BookM] //to retrive SwiftData, add @Query before target data third
    
//MARK: - Constants and Vars
    
    @State private var showingAddScreen = false
    
//MARK: - Function - delete SwiftData object
    
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            modelContext.delete(book)
        }
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(books) { book in
                    NavigationLink(value: book) {
                        HStack {
                            EmojiRating(rating: book.rating)
                                .font(.largeTitle)
                            VStack(alignment: .leading) {
                                Text(book.title)
                                    .font(.headline)
                                    .foregroundStyle(book.rating == 1 ? Color.red : Color.black)
                                Text(book.author)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
            .navigationTitle("Bookworm")
            .navigationDestination(for: BookM.self) { book in
                BookDetailV(book: book)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Book", systemImage: "plus") {
                        showingAddScreen.toggle()
                    }
                }
            }
            .sheet(isPresented: $showingAddScreen) {
                AddBookV()
            }
        }
    }
}

//MARK: - Body Component

struct EmojiRating: View {
    let rating: Int
    var body: some View {
        switch rating {
        case 1: Text("☹️")
        case 2: Text("🥱")
        case 3: Text("🤨")
        case 4: Text("🙂")
        default: Text("😃")
        }
    }
}

//MARK: - Preview

#Preview {
    BookwormV()
}
