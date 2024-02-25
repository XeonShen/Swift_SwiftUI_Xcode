import SwiftUI
import SwiftData

struct UserV: View {
    
//MARK: - Constants and Vars
    
    @Environment(\.modelContext) var modelContext
    @State private var path = [UserM]()
    
    @State private var showingUpcomingOnly = false
    @State private var sortOrder = [
        SortDescriptor(\UserM.name),
        SortDescriptor(\UserM.joinDate)
    ]
    
//MARK: - Body
    
    var body: some View {
        NavigationStack(path: $path) {
            //when showingUpcomingOnly changes, this view will be rebuilt
            UserFilterV(minimumJoinDate: showingUpcomingOnly ? .now : .distantPast, sortOrder: sortOrder)
                .navigationTitle("Users")
                .navigationDestination(for: UserM.self) { user in //edit a given user
                    UserEditorV(user: user)
                }
                .toolbar {
                    ToolbarItemGroup {
                        
//MARK: - Create an empty user than edit it
                        
                        Button("Add User", systemImage: "plus") {
                            let user = UserM(name: "", city: "", joinDate: .now)
                            modelContext.insert(user)
                            path = [user]
                        }

//MARK: - Delete all users in database, create 4 sample users, add 2 sample jobs to first sample user
                        
                        Button("Add Sample", systemImage: "plus.circle.fill") {
                            try? modelContext.delete(model: UserM.self)
                            
                            let firstSample = UserM(name: "Ed Sheeran", city: "London", joinDate: .now.addingTimeInterval(86400 * -10))
                            let secondSample = UserM(name: "Rosa Diaz", city: "New York", joinDate: .now.addingTimeInterval(86400 * -5))
                            let thirdSample = UserM(name: "Roy Kent", city: "London", joinDate: .now.addingTimeInterval(86400 * 5))
                            let forthSample = UserM(name: "Johnny English", city: "London", joinDate: .now.addingTimeInterval(86400 * 10))
                            modelContext.insert(firstSample)
                            modelContext.insert(secondSample)
                            modelContext.insert(thirdSample)
                            modelContext.insert(forthSample)
                            
                            let firstJob = JobM(name: "reading", priority: 3)
                            let secondJob = JobM(name: "Listening", priority: 2)
                            firstSample.jobs.append(firstJob)
                            firstSample.jobs.append(secondJob)

                        }
                        
//MARK: - Toggle a filter (which applied to database) on and off
                        
                        Button(showingUpcomingOnly ? "Show Everyone" : "Show Upcoming", systemImage: "arrow.left.arrow.right") {
                            showingUpcomingOnly.toggle()
                        }
                        
//MARK: - Change sort order, so the database will show in a different order
                        
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort", selection: $sortOrder) {
                                Text("Sort by Name")
                                    .tag([SortDescriptor(\UserM.name),
                                          SortDescriptor(\UserM.joinDate)])
                                Text("Sort by Join Date")
                                    .tag([SortDescriptor(\UserM.joinDate),
                                          SortDescriptor(\UserM.name)])
                            }
                        }
                    }
                }
        }
    }
}

//MARK: - Preview

#Preview {
    UserV()
}
