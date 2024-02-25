import SwiftUI
import LocalAuthentication

class ExpenseNoteVM: ObservableObject {
    
//MARK: - Instance of ExpenseNoteM - everytime the Model data changed, save the data
    
    @Published var items = [ExpenseNote]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
//MARK: - Initializer - restore data after initialized
    
    init() {
        if let savesItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseNote].self, from: savesItems) {
                items = decodedItems
                return
            }
        }
        items = []
    }
    
//MARK: - Remove item in the ForEach view
    
    func removeItems(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
    }
    
//MARK: - Unlock the App with FaceID
    
    @Published var faceIDIsUnlocked = false
    
    func authenticate() {
        let laContext = LAContext()
        var nsError: NSError?
        
        if laContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &nsError) {
            let reson = "Please authenticate yourself to unlock your Expense Note."
            laContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reson) {
                success, authenticationError in
                if success {
                    self.faceIDIsUnlocked = true
                } else {
                    //try to scan your face but recognize failed, try again
                }
            }
        } else {
            //device does not have bio sensor, handle this NSError
        }
    }
    
}
