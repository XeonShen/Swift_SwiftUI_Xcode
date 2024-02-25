import SwiftUI
import SwiftData

@main
struct SwiftDataExploreApp: App {
    var body: some Scene {
        WindowGroup {
            UserV()
        }
        .modelContainer(for: UserM.self) //no need to add Job.self here, swift will link 2 class together automatically
    }
}
