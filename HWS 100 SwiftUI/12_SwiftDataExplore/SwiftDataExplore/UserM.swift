import Foundation
import SwiftData

@Model
class UserM {
    var name: String
    var city: String
    var joinDate: Date
    //After using Job here, the User class and Job class will be linked together automatically
    //After using .cascade, the jobs propertity will be deleted with user object together
    @Relationship(deleteRule: .cascade) var jobs = [JobM]()
    
    init(name: String, city: String, joinDate: Date) {
        self.name = name
        self.city = city
        self.joinDate = joinDate
    }
}
