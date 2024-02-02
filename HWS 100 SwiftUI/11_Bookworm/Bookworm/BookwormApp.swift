import SwiftUI
import SwiftData

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            BookwormV()
        }
        .modelContainer(for: BookM.self) //to use SwiftData, add .modelContainer in App file second
    }
}
