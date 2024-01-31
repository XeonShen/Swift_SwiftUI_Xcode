import SwiftUI

struct AddressV: View {
    @ObservedObject var orderVM: OrderVM
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderVM.orderM.name)
                TextField("Street Address", text: $orderVM.orderM.streetAddress)
                TextField("City", text: $orderVM.orderM.city)
                TextField("Zip", text: $orderVM.orderM.zip)
            }
            
            Section {
                NavigationLink("Check out") {
                    CheckoutV(orderVM: orderVM)
                }
            }
            .disabled(orderVM.orderM.hasValidAddress == false)
        }
        .navigationTitle("Delivery details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressV(orderVM: OrderVM())
    }
}
