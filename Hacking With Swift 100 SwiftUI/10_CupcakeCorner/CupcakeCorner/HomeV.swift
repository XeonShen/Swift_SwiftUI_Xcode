import SwiftUI

struct HomeV: View {
    @ObservedObject private var orderVM = OrderVM()
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orderVM.orderM.type) {
                        ForEach(OrderM.types.indices, id: \.self) {
                            Text(OrderM.types[$0])
                        }
                    }
                    
                    Stepper("Number of cakes: \(orderVM.orderM.quantity)", value: $orderVM.orderM.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special request?", isOn: $orderVM.orderM.specialRequestEnabled.animation())
                    
                    if orderVM.orderM.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $orderVM.orderM.extraForsting)
                        Toggle("Add extra sprinkles", isOn: $orderVM.orderM.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink("Delivery details") {
                        AddressV(orderVM: orderVM)
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeV()
    }
}
