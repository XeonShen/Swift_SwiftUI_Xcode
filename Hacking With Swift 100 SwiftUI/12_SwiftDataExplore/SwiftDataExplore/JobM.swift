import Foundation
import SwiftData

@Model
class JobM {
    var name: String
    var priority: Int
    var owner: UserM?
    
    init(name: String, priority: Int, owner: UserM? = nil) {
        self.name = name
        self.priority = priority
        self.owner = owner
    }
}
