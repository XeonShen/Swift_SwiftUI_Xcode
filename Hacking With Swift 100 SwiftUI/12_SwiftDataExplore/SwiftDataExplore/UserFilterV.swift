import SwiftUI
import SwiftData

struct UserFilterV: View {
    
//MARK: - Constants and Vars - fetch all data from database
    
    @Query var users: [UserM]
    
//MARK: - Initializer - act like a data filter, re-arrange all the data
    
    init(minimumJoinDate: Date, sortOrder: [SortDescriptor<UserM>]) {
        _users = Query(filter: #Predicate<UserM> { user in user.joinDate >= minimumJoinDate },
                       sort: sortOrder)
    }
    
//MARK: - Body - put the filtered data inside, return a small view
    
    var body: some View {
        List(users) { user in
            NavigationLink(value: user) {
                HStack {
                    Text(user.name)
                    Spacer()
                    Text(String(user.jobs.count))
                        .fontWeight(.black)
                        .padding(.horizontal,10)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(.capsule)
                }
            }
        }
    }
}

//MARK: - Preview

#Preview {
    UserFilterV(minimumJoinDate: .now, sortOrder: [SortDescriptor(\UserM.name)])
        .modelContainer(for: UserM.self)
}
