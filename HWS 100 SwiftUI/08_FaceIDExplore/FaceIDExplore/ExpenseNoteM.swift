import Foundation

struct ExpenseNote: Identifiable, Codable {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}
