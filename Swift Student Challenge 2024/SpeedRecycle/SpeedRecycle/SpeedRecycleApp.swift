import SwiftUI

@main
struct SpeedRecycleApp: App {
    var body: some Scene {
        WindowGroup {
            //this view determines showing GuideV or HomeV
            ShowGuideOrHomeV()
                .preferredColorScheme(.light)
                .statusBar(hidden: true)
        }
    }
}
