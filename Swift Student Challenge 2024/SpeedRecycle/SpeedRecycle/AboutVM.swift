import SwiftUI

class AboutVM: ObservableObject {
    @Published var textArray: [String] = []
    
    init() {
        textArray.append("Hi, thanks for using the App I made!")
        textArray.append("Speed Recycle is an App aiming to help people to build waste separation awareness.")
        textArray.append("In my country, waste separation has just started to be practiced, ")
        textArray.append("Soooo many people still don't know how to properly segregate their waste, ")
        textArray.append("This is going to put a heavy burden on our environment, which is sad to see.")
        textArray.append("That's why I'm trying to make a small contribution to the environment I live in - ")
        textArray.append("Let people learn about trash sorting by playing my games.\n")
        
        textArray.append("As a Swift beginner, It took me long to finish this and I hope you're happy with it.")
        textArray.append("All assets was drawn with Stable Diffusion by myself, so there should not have any copyright issues.")
        textArray.append("All code was written by myself as well, 100% original.\n")
        
        textArray.append("Special thanks to Stanford CS193p, awesome lectures, learned a lot.")
        textArray.append("Special thanks to Paul Hudson, Hacking With Swift is a good learning website.")
        textArray.append("Special thanks to Swift Community, clear documentations and support.\n")
        
        textArray.append("Final version, 21 Feb 2024, made by xeon with ❤️")
    }
}


