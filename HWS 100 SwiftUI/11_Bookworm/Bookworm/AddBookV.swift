import SwiftUI

struct AddBookV: View {
    
//MARK: - Constants and Vars
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var rating = 3
    @State private var genre = "Fantasy"
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    @State private var review = ""
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section("Write a review") {
                    TextEditor(text: $review)
                    BookRatingV(rating: $rating)
                }
                
                Section {
                    Button("Save") {
                        let newBook = BookM(title: title, author: author, genre: genre, review: review, rating: rating, addingDate: Date.now)
                        modelContext.insert(newBook)
                        dismiss()
                    }
                    .disabled({
                        if title.trim() == "" || author.trim() == "" || review.trim() == "" {
                            return true
                        } else {
                            return false
                        }
                    }())
                }
            }
            .navigationTitle("Add Book")
        }
    }
}

#Preview {
    AddBookV()
}
