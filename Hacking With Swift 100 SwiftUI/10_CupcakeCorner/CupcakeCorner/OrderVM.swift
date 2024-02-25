import SwiftUI

class OrderVM: ObservableObject {
    
//MARK: - Model - store model data when change happens
    
    @Published var orderM: OrderM {
        didSet {
            if let encoded = try? JSONEncoder().encode(orderM) {
                UserDefaults.standard.set(encoded, forKey: "orderM")
            }
        }
    }
    
//MARK: - Initializer - restore model data
    
    init() {
        if let savesItems = UserDefaults.standard.data(forKey: "orderM") {
            if let decodedItems = try? JSONDecoder().decode(OrderM.self, from: savesItems) {
                orderM = decodedItems
                return
            }
        }
        orderM = OrderM()
    }
    
    
}
