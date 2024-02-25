//
// ContentView.swift
// Vortex
// https://www.github.com/twostraws/Vortex
// See LICENSE for license information.
//

import SwiftUI

/// The main view for the app, allowing preset selection and display.
struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            List {
                NavigationLink("Confetti", destination: ConfettiView.init)
                NavigationLink("Fire", destination: FireView.init)
                NavigationLink("Fireflies", destination: FirefliesView.init)
                NavigationLink("Fireworks", destination: FireworksView.init)
                NavigationLink("Magic", destination: MagicView.init)
                NavigationLink("Rain", destination: RainView.init)
                NavigationLink("Smoke", destination: SmokeView.init)
                NavigationLink("Snow", destination: SnowView.init)
                NavigationLink("Spark", destination: SparkView.init)
                NavigationLink("Splash", destination: SplashView.init)
            }
            .navigationTitle("Vortex Sandbox")
        } detail: {
            WelcomeView()
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
