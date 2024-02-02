import Foundation
import SwiftData

@Model //to use SwiftData, add @Model in your M file first
class BookM {
    var title: String
    var author: String
    var genre: String
    var review: String
    var rating: Int
    var addingDate: Date
    
    init(title: String, author: String, genre: String, review: String, rating: Int, addingDate: Date) {
        self.title = title
        self.author = author
        self.genre = genre
        self.review = review
        self.rating = rating
        self.addingDate = addingDate
    }
}
