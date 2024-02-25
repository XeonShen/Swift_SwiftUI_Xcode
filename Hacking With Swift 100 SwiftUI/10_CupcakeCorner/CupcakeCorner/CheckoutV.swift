import SwiftUI

struct CheckoutV: View {
    
    @ObservedObject var orderVM: OrderVM
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    @State private var showingNetworkError = false
    
//MARK: - Function - Send request to the network
    
    func placeOrder() async {
        //prepare the json data
        guard let encoded = try? JSONEncoder().encode(orderVM.orderM) else {
            print("Failed to encode order.")
            return
        }
        //configure the http request
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            //send the data out, then recieve some data back
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            //decode the recieved data
            let decodedOrder = try JSONDecoder().decode(OrderM.self, from: data)
            confirmationMessage = "Your order for \(decodedOrder.quantity) x \(OrderM.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingConfirmation = true
        } catch {
            print("Check out failed: \(error.localizedDescription)")
            showingNetworkError = true
        }
    }
    
//MARK: - Body Components
    
    var cakeImage: some View {
        AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg"), scale: 3) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
            } else if phase.error != nil {
                Text("There was an error loading the image.")
            } else {
                ProgressView()
            }
        }
        .frame(height: 233)
    }
    
//MARK: - Body
    
    var body: some View {
        ScrollView {
            VStack {
                cakeImage
                Text("Your total cost is \(orderVM.orderM.cost, format: .currency(code: "USD"))")
                Button("Place Order") {
                    Task {
                        await placeOrder()
                    }
                }
                    .padding()
            }
        }
        .navigationTitle("Check Out")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Thank you!", isPresented: $showingConfirmation) {
            Button("OK") { }
        } message: { Text(confirmationMessage) }
        .alert("Network Error!", isPresented: $showingNetworkError) {
            Button("OK") { }
        }
    }
}

//MARK: - Preview

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutV(orderVM: OrderVM())
    }
}
