import SwiftUI
import CoreMotion
import Combine

class ItemsIntroVM: ObservableObject {
    
//MARK: - Properties
    
    //ViewModel Properties
    @Published private var recycleItemM = RecycleItemM()
    var items: Array<RecycleItemM.item> { recycleItemM.items }
    //CoreMotion Properties
    private var motionManager = CMMotionManager()
    @Published var position = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2 - 100)
    private let circleSize: CGFloat = 40
    
//MARK: - Initializer
    
    init() {
        startGyroscope()
        //make sure items array contain all items
        recycleItemM.insertEmptyAlcoholBottle(at: recycleItemM.items.count)
        recycleItemM.insertPaperCup(at: recycleItemM.items.count)
        recycleItemM.insertemptyGlass(at: recycleItemM.items.count)
        recycleItemM.insertEmptyPlasticBottle(at: recycleItemM.items.count)
    }
    
//MARK: - Functions
    
    func returnCategoryName(item: RecycleItemM.item) -> (String, String) {
        var itemCategory: String {
            switch item.category {
            case .recyclable:
                return "recyclable"
            case .nonrecyclable:
                return "nonrecyclable"
            case .food:
                return "food"
            case .liquid:
                return "Liquid"
            case .donate:
                return "donate"
            case .biodegradable:
                return "biodegradable"
            }
        }
        var itemSubcatagory: String {
            switch item.subCategory {
            case .recyclable:
                return "recyclable"
            case .nonrecyclable:
                return "nonrecyclable"
            case .food:
                return "food"
            case .liquid:
                return "Liquid"
            case .donate:
                return "donate"
            case .biodegradable:
                return "biodegradable"
            case .none:
                return "No Subcategory"
            }
        }
        return (itemCategory, itemSubcatagory)
    }
    
    func returnCategoryImage(category: RecycleItemM.Categories) -> String {
        switch category {
        case .biodegradable:
            return "BinBiodegradable"
        case .donate:
            return "BinDonate"
        case .food:
            return "BinFood"
        case .liquid:
            return "BinFluid"
        case .nonrecyclable:
            return "BinNonrecyclable"
        case .recyclable:
            return "BinRecyclable"
        }
            
    }
    
    func startGyroscope() {
        if motionManager.isGyroAvailable {
            //update in 60Hz
            motionManager.gyroUpdateInterval = 1 / 60
            motionManager.startGyroUpdates(to: .main) { [weak self] (gyroData, error) in
                guard let self = self, let data = gyroData else { return }
                //gyro point moving sensitivity
                let sensitivity: CGFloat = 10.0
                DispatchQueue.main.async {
                    //update gyro point position
                    var newX = self.position.x + CGFloat(data.rotationRate.y) * sensitivity
                    var newY = self.position.y + CGFloat(data.rotationRate.x) * sensitivity
                    //keep gyro point in the screen
                    newX = min(max(newX, self.circleSize / 2), UIScreen.main.bounds.width - self.circleSize / 2)
                    newY = min(max(newY, self.circleSize / 2), UIScreen.main.bounds.height - self.circleSize / 2)
                    self.position = CGPoint(x: newX, y: newY)
                }
                //keep gyro point within the bound
                
            }
        }
    }
    
    func setPositionToItem(x: CGFloat, y: CGFloat) {
        position = CGPoint(x: x, y: y)
    }
    
}
