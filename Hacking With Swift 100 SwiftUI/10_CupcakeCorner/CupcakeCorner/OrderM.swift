import Foundation

struct OrderM: Codable {
    
//MARK: - Constants and Vars
    
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraForsting = false
                addSprinkles = false
            }
        }
    }
    var extraForsting = false
    var addSprinkles = false
    
    var name = ""
    var streetAddress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.isEmpty || name.trim() == "" || streetAddress.isEmpty || streetAddress.trim() == "" || city.isEmpty || city.trim() == "" || zip.isEmpty || zip.trim() == "" {
            return false
        }
        return true
    }
    var cost: Decimal {
        var cost = Decimal(quantity) * 2
        cost += Decimal(type) / 2
        if extraForsting {
            cost += Decimal(quantity)
        }
        if addSprinkles {
            cost += Decimal(quantity) / 2
        }
        return cost
    }
    
//MARK: - Initializer
    
    init() { }
    
//MARK: - CodingKeys
    
    enum CodingKeys: String, CodingKey {
           case type
           case quantity
           case specialRequestEnabled
           case extraForsting
           case addSprinkles
           case name
           case streetAddress
           case city
           case zip
       }
       
       init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)

           type = try container.decode(Int.self, forKey: .type)
           quantity = try container.decode(Int.self, forKey: .quantity)
           specialRequestEnabled = try container.decode(Bool.self, forKey: .specialRequestEnabled)
           extraForsting = try container.decode(Bool.self, forKey: .extraForsting)
           addSprinkles = try container.decode(Bool.self, forKey: .addSprinkles)
           name = try container.decode(String.self, forKey: .name)
           streetAddress = try container.decode(String.self, forKey: .streetAddress)
           city = try container.decode(String.self, forKey: .city)
           zip = try container.decode(String.self, forKey: .zip)
       }
       
       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           
           try container.encode(type, forKey: .type)
           try container.encode(quantity, forKey: .quantity)
           try container.encode(specialRequestEnabled, forKey: .specialRequestEnabled)
           try container.encode(extraForsting, forKey: .extraForsting)
           try container.encode(addSprinkles, forKey: .addSprinkles)
           try container.encode(name, forKey: .name)
           try container.encode(streetAddress, forKey: .streetAddress)
           try container.encode(city, forKey: .city)
           try container.encode(zip, forKey: .zip)
       }
    
}
