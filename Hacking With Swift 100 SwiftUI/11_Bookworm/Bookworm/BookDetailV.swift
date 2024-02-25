import SwiftUI
import SwiftData

struct BookDetailV: View {
    
//MARK: - Constants and Vars
    let book: BookM
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false

//MARK: - Functions
    
    //delete current SwiftData object
    func deleteBook() {
        modelContext.delete(book)
        dismiss()
    }
    
    //format date to a string
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
    
//MARK: - Body
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomTrailing) {
                Image(book.genre)
                    .resizable()
                    .scaledToFit()
                Text(book.genre.uppercased())
                    .fontWeight(.black)
                    .padding(10)
                    .foregroundStyle(.white)
                    .background(.black.opacity(0.75))
                    .clipShape(.capsule)
                    .offset(x: -10, y: -10)
            }
            
            VStack {
                Text(book.author)
                    .font(.title)
                    .foregroundStyle(.secondary)
                    .padding(.top)
                Text(book.review)
                    .padding()
                BookRatingV(rating: .constant(book.rating))
                    .font(.title)
                Text("Adding Date: " + formatDate(book.addingDate))
                    .padding()
            }
        }
        .navigationTitle(book.title)
        .navigationBarTitleDisplayMode(.inline)
        .scrollBounceBehavior(.basedOnSize)
        .toolbar {
            Button("Delete this book", systemImage: "trash") {
                showingDeleteAlert = true
            }
        }
        .alert("Delete book", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive, action: deleteBook)
            Button("Cancel", role: .cancel, action: {})
        } message: { Text("Are you sure?") }
    }
}

//MARK: - Preview

#Preview {
    do {
        //to use SwiftData with Preview, create an example only exist in RAM forth
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: BookM.self, configurations: config)
        return BookDetailV(book: BookM(title: "test", author: "test", genre: "Fantasy", review: "good.", rating: 4, addingDate: Date.now))
            .modelContainer(container)
    } catch {
        return Text("Failed to create preview: \(error.localizedDescription)")
    }
}
