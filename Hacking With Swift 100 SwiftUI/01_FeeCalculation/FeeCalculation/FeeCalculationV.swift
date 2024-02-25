import SwiftUI

struct FeeCalculationV: View {
    
//MARK: - Constants and Vars for first form
    
    @State private var checkAmount = 0.0
    @State private var numberOfPeople = 2
    @State private var tipPercentage = 20
    let tipPercentages = [10, 15, 20, 25, 0]
    var totalPerPerson: Double {
        let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentage)
        return (checkAmount + checkAmount / 100 * tipSelection) / peopleCount
    }
    
    @FocusState private var amountIsFocused: Bool //Make a button to hide the keyboard
    
//MARK: - Constants and Vars for second form
    
    let currencyUnit = ["USD", "AUD", "CAD", "YUAN"]
    @State private var inputCurrencyUnit = "USD"
    @State private var outputCurrencyUnit = "AUD"
    @State private var inputCurrencyAmount = 0.0
    
    var inputCurrencyConvertToUSD: Double {
        var convertToUSD = 0.0
        if inputCurrencyUnit == "USD" {
            convertToUSD = inputCurrencyAmount
        } else if inputCurrencyUnit == "AUD" {
            convertToUSD = inputCurrencyAmount / 2
        } else if inputCurrencyUnit == "CAD" {
            convertToUSD = inputCurrencyAmount / 3
        } else {
            convertToUSD = inputCurrencyAmount / 4
        }
        return convertToUSD
    }
    var USDConvertToOutputCurrency: Double {
        var USDConvertTo = inputCurrencyConvertToUSD
        if outputCurrencyUnit == "AUD" {
            USDConvertTo *= 2
        } else if outputCurrencyUnit == "CAD" {
            USDConvertTo *= 3
        } else if outputCurrencyUnit == "YUAN"{
            USDConvertTo *= 4
        }
        return USDConvertTo
    }

//MARK: - Body
    
    var body: some View {
        NavigationStack {
            
//MARK: - First form for tips calculation
            
            Form {
                Section {
                    TextField("Amount", value: $checkAmount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused) //Make a button to hide the keyboard
                    Picker("Number of People", selection: $numberOfPeople) {
                        ForEach(2..<100) { Text("\($0) people") }
                    } //Jump to another page when click the picker use .pickerStyle(.navigationLink)
                }
                Section("How much you want to tip?") {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(tipPercentages, id:\.self) {
                            Text($0, format: .percent)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Amount per person") {
                    Text(totalPerPerson, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                }
            }
            .navigationTitle("WeSplit")
            .toolbar { //Make a button to hide the keyboard
                if amountIsFocused {
                    Button("Done") { amountIsFocused = false }
                }
            }
            
//MARK: - Second form for currency convert
            
            Form {
                Section("Pick the input & output currency unit") {
                    Picker("Input currency type", selection: $inputCurrencyUnit) {
                        ForEach(currencyUnit, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                    Picker("Output currency type", selection: $outputCurrencyUnit) {
                        ForEach(currencyUnit, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
                Section("How many money you want to convert?") {
                    TextField("Amount", value: $inputCurrencyAmount, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($amountIsFocused)
                    Text("Return: \(USDConvertToOutputCurrency.formatted())")
                }
            }
        }
    }
}

//MARK: - Preview

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FeeCalculationV()
    }
}
