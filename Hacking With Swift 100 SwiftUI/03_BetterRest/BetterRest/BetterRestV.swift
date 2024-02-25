import SwiftUI
import CoreML

struct BetterRestV: View {
    
//MARK: - Constants and Vars
    
    static private var defaultWakeUpTime: Date {
        var component = DateComponents()
        component.hour = 7
        component.minute = 0
        return Calendar.current.date(from: component) ?? .now
    }
    
    @State private var wakeUpTime = defaultWakeUpTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 2
    @State private var recommandedBedtime = ""
    
//MARK: - Body components
    
    var firstSection: some View {
        Section {
            Text("When do you want to wake up?")
                .font(.headline)
            DatePicker("Enter a time", selection: $wakeUpTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .onChange(of: wakeUpTime) { _ in
                    calculateBedtime()
                }
        }
    }
    
    var secondSection: some View {
        Section {
            Text("Desired amount of sleep")
                .font(.headline)
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                .onChange(of: sleepAmount) { _ in
                    calculateBedtime()
                }
        }
    }
    
    var thirdSection: some View {
        Section {
            Text("Display coffee intake")
                .font(.headline)
            //An alternative option to Picker, you can use the stepper
            //Stepper("^[\(coffeeAmount) cup](inflect: true)", value: $coffeeAmount, in: 1...20)
            Picker("How many coffee you wanna drink", selection: $coffeeAmount) {
                ForEach(1..<6){
                    Text($0, format: .number)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: coffeeAmount) { _ in
                calculateBedtime()
            }
        }
    }
    
    var forthSection: some View {
        Section("The recommanded bedtime is:") {
            Text(recommandedBedtime)
        }
    }
    
//MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                firstSection
                secondSection
                thirdSection
                forthSection
            }
            .navigationTitle("BetterRest")
        }
    }
    
//MARK: - Use coreML to calculate the recommanded bedtime
    
    func calculateBedtime() {
        do {
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUpTime)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60 * 60
            
            let config = MLModelConfiguration()
            let model = try BetterRestCoreML(configuration: config)
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount + 1))
            
            let sleepTime = wakeUpTime - prediction.actualSleep
            recommandedBedtime = "Your ideal bedtime is: \(sleepTime.formatted(date: .omitted, time: .shortened))"
        } catch {
            recommandedBedtime = "Sorry, some issue with the coreML model"
        }
    }
    
}

//Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BetterRestV()
    }
}
