import SwiftUI
import SwiftData

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            HomeV()
        }
        .modelContainer(for: ProspectsM.self)
    }
}
