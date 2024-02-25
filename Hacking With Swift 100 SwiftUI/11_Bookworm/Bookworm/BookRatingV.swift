import SwiftUI

struct BookRatingV: View {
    @Binding var rating: Int
    let maximumRating = 5
    
    var starSymbol = Image(systemName: "star.fill")
    var starSymbolOnColor = Color.yellow
    var starSymbolOffColor = Color.gray
    
    var body: some View {
        HStack {
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                Button {
                    rating = number
                } label: {
                    starSymbol
                        .foregroundColor(number > rating ? starSymbolOffColor : starSymbolOnColor)
                }
            }
        }
        .buttonStyle(.plain) //let swift treat each button individually in a row
    }
}

#Preview {
    BookRatingV(rating: .constant(4))
}
