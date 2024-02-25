import SwiftUI
import CoreHaptics

struct HapticExploreV: View {
    
//MARK: - Constants and Vars - for build in haptic
    
    @State private var simpleHapticButtonCounter = 0
    @State private var softHapticButtonCounter = 0
    @State private var heavyHapticButtonCounter = 0
    
//MARK: - Constants and Vars - for custom haptic
    
    @State private var hapticEngine: CHHapticEngine?
    
//MARK: - Functions - for custom haptic
    
    func prepareHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error starting the haptic engine: \(error.localizedDescription)")
        }
    }
    
    func complexHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        //this for loop create a haptic pattern stronger and stronger
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }
        //this for loop create a haptic pattern weaker and weaker
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(1 - i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(1 - i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            events.append(event)
        }
        //combine all the haptic patterns together, then play it
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play custom haptic pattern: \(error.localizedDescription)")
        }
    }
    
//MARK: - Body
    
    var body: some View {
        VStack {
            
//MARK: - Buttons with build in haptic
            
            Button("Simple Haptic Button: \(simpleHapticButtonCounter)") {
                simpleHapticButtonCounter += 1
            }
            .sensoryFeedback(.increase, trigger: simpleHapticButtonCounter)
            
            Button("Soft Haptic Button: \(softHapticButtonCounter)") {
                softHapticButtonCounter += 1
            }
            .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: softHapticButtonCounter)
            
            Button("Heavy Haptic Button: \(heavyHapticButtonCounter)") {
                heavyHapticButtonCounter += 1
            }
            .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: heavyHapticButtonCounter)

//MARK: - Button with custom haptic
            
            Button("Custom Haptic Button", action: complexHaptic)
                .onAppear(perform: prepareHapticEngine)
        }
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HapticExploreV()
    }
}
