import Foundation

struct RecycleItemM {
    
    struct item: Identifiable, Codable, Hashable {
        var id: UUID
        var name: String
        var imageName: String
        var category: Categories
        var subCategory: Categories?
        var description: String
        var advise: String
    }
    enum Categories: String, Codable { case recyclable, nonrecyclable, food, liquid, donate, biodegradable }
    
    
    var items = [item]()
    var tempItems: [item]
    
    
    mutating func resetRound() {
        items.removeAll()
        items = tempItems
        items.shuffle()
    }
    
//MARK: - Return an empty bottle after pour out the liquid inside
    
    mutating func insertEmptyAlcoholBottle(at index: Int) {
        let emptyAlcoholBottle = item(id: UUID(), name: "Empty Alcohol Bottle", imageName: "bottleGlassEmpty",
                                      category: .recyclable,
                                      description: "This is an empty glass bottle with the alcohol already poured out, tap me for more info.",
                                      advise: "Tips: You've already poured the alcohol out of the glass bottle, the rest of the bottle is of course recyclable!")
        items.insert(emptyAlcoholBottle, at: index)
    }
    
    mutating func insertEmptyPlasticBottle(at index: Int) {
        let emptyPlasticBottle = item(id: UUID(), name: "Empty Plastic Bottle", imageName: "bottlePlasticEmpty",
                                      category: .recyclable,
                                      description: "This is an empty plastic bottle, tap me for more info.",
                                      advise: "Tips: Plastic bottles are usually made from PET or HDPE, which can be melted down to make new plastic bottles, making them highly recyclable.")
        items.insert(emptyPlasticBottle, at: index)
    }
    
    mutating func insertemptyGlass(at index: Int) {
        let emptyGlass = item(id: UUID(), name: "Empty Glass", imageName: "cupGlassEmpty",
                              category: .recyclable,
                              description: "The ice in this cracked glass has been poured out, you can throw it away now.",
                              advise: "Tips: We rarely throw away a glass in our daily lives unless it was broken, which can make it difficult to determine the type. The fact is that glass is highly recyclable, as long as it is given to the relevant recycling department.")
        items.insert(emptyGlass, at: index)
    }
    
    mutating func insertPaperCup(at index: Int) {
        let paperCup = item(id: UUID(), name: "Empty Paper Cup", imageName: "cupPaperEmpty",
                            category: .recyclable,
                            description: "The drink in this paper cup has been successfully poured out, you can throw it away now.",
                            advise: "Tips: You've poured the liquid out of the paper cups, and the rest of the cups are recyclable. It may become a component of your next shipping box!")
        items.insert(paperCup, at: index)
    }
    
//MARK: - Add items to list
    
    init() {
        let toteBag = item(id: UUID(), name: "Tote Bag", imageName: "bagCloth", 
                           category: .recyclable,
                           subCategory: .donate,
                           description: "This a cloth tote bag, tap me for more info.",
                           advise: "Tips: Cloth bags can typically be recycled, either by repurposing the material or by being broken down into fibers for reuse. Many recycling centers accept textiles for recycling. It'll be a better option if you can donate or reuse it.")
        items.append(toteBag)
        
        let paperBag = item(id: UUID(), name: "Paper Bag", imageName: "bagPaper", 
                            category: .recyclable,
                            description: "This a paper bag for fast food, tap me for more info.",
                            advise: "Tips: Paper bags are usually recyclable, they can be degraded into fibres and made into new paper products. Before throwing them away, remember to check that there are no food remnants in the bag.")
        items.append(paperBag)
        
        let plasticBag = item(id: UUID(), name: "Plastic Bag", imageName: "bagPlastic", 
                              category: .nonrecyclable,
                              description: "This is a plastic bag from shopping mall, tap me for more info.",
                              advise: "Tips: Most plastic-based waste is not recyclable unless it is clearly marked biodegradable. They often end up in landfills or as litter, contributing to environmental pollution and posing hazards to wildlife.")
        items.append(plasticBag)
        
        let buttonBattery = item(id: UUID(), name: "Button Battery", imageName: "batteryButton", 
                                 category: .nonrecyclable,
                                 description: "This is a button battery removed from a toy, tap me for more info.",
                                 advise: "Tips: Button batteries are non-recyclable waste, lot of toxic materials like mercury or cadmium is contained, posing environmental and health risks if not disposed correctly. It's essential to following local disposal guidelines and handle it responsibly.")
        items.append(buttonBattery)
        
        let dryCellBattery = item(id: UUID(), name: "Dry Cell Battery", imageName: "batteryCell", 
                                  category: .nonrecyclable,
                                  description: "This is a dry cell battery removed from a remote, tap me for more info.",
                                  advise: "Tips: Although dry cell batteries are not as harmful as button batteries and contain few harmful substances, they are still non-recyclable waste. You should collect used batteries and give them to the local recycling department.")
        items.append(dryCellBattery)
        
        let book = item(id: UUID(), name: "Book", imageName: "book", 
                        category: .recyclable,
                        subCategory: .donate,
                        description: "It's a school textbook, tap me for more info.",
                        advise: "Tips: Paper books are recyclable and they can often be reused as material for the production of newspapers, but it is best to remove the book's plastic cover before recycling. A better practice is to donate them.")
        items.append(book)
        
        let can = item(id: UUID(), name: "Aluminium Can", imageName: "bottleCan",
                       category: .recyclable,
                       description: "It's a very common beverage can, tap me for more info.",
                       advise: "Tips: Things made of aluminium are usually recyclable, they can be melted down and reused in many e-products, which will save a lot of energy compared to make aluminium from raw material, thus protecting the environment.")
        items.append(can)
        
        let alcoholBottle = item(id: UUID(), name: "Alcohol in Bottle", imageName: "bottleGlassAlcohol",
                                 category: .liquid,
                                 description: "This bottle contains alcohol for sanitary, tap me for more info.",
                                 advise: "Tips: Alcohol is classed as Liquid waste, although it can damage the environment like killing micro-organisms in the soil, in most cases this won't happen. Alcohol doesn't usually dissolve the pipe, so it can be safely poured down the sink.")
        items.append(alcoholBottle)
        
        let tolueneBottle = item(id: UUID(), name: "Toluene Bottle", imageName: "bottleGlassToluene",
                                 category: .nonrecyclable,
                                 description: "This is a glass bottle filled with toluene, tap me for more info.",
                                 advise: "Tips: Toluene as a corrosive chemical is non-recyclablble. This liquid is often used as a paint thinner at home, which is fairy common. It's harmful to human and the environment and should not be disposed directly.")
        items.append(tolueneBottle)
        
        let waterBottle = item(id: UUID(), name: "Water Bottle", imageName: "bottlePlasticWater",
                               category: .liquid,
                               description: "This is a plastic bottle contains water, tap me for more info.",
                               advise: "Tips: Plastic bottles are usually made from PET or HDPE, which can be melted down to make new plastic bottles, making them highly recyclable. Before you recycle this plastic bottle, you should pour out the water inside.")
        items.append(waterBottle)
        
        let paperBox = item(id: UUID(), name: "Paper Box", imageName: "boxPaper",
                            category: .recyclable,
                            description: "This is a very common delivery carton, tap me for more info.",
                            advise: "Tips: As a paper product, those packaging box are usually recyclable. It can become a material for making other paper products. If possible, you should reuse it as much as possible, such as use it as a shipping box.")
        items.append(paperBox)
        
        let packagingFoams = item(id: UUID(), name: "Packaging Foams", imageName: "boxStyrofoam",
                                category: .nonrecyclable,
                                description: "This peanut-shaped foam is used for packaging items, tap me for more info.",
                                advise: "Tips: Packaging foams are non-recyclable waste, they are challenging to recycle due to their lightweight and bulky nature, toss it in the non-recyclable bin or save them for future use!")
        items.append(packagingFoams)
        
        let backpack = item(id: UUID(), name: "Backpack", imageName: "clothBackpack",
                            category: .donate,
                            description: "It's a canvas bag, old and worn out, tap me for more info.",
                            advise: "Tips: Cloth items are usually recyclable, but for items with complex structures like backpacks, the best way is to donate them. Help those in need!")
        items.append(backpack)
        
        let scarf = item(id: UUID(), name: "Scarf", imageName: "clothScarf",
                         category: .donate,
                         description: "It's an old scarf, tap me for more info.",
                         advise: "Tips: If you no longer need this great looking scarf, the best place for it is to be donated. Or you can use it as a rag, these flat cloths are great for wiping tables, I'm serious!")
        items.append(scarf)
        
        let shoes = item(id: UUID(), name: "Shoes", imageName: "clothShoes",
                         category: .donate,
                         description: "It's an old pair of shoes, tap me for more info.",
                         advise: "Tips: Items like shoes, which are made from many different materials, are hard to recycle, so if you have an old pair of shoes, then donate them to someone else, there are a lot of people who need your help!")
        items.append(shoes)

        let socks = item(id: UUID(), name: "Socks", imageName: "clothSocks",
                         category: .donate,
                         description: "It's an old pair of socks, tap me for more info.",
                         advise: "Tips: Although socks are made of cotton, they can contain substances such as polyester or nylon, making them difficult to recycle. The correct way is to remove the germs by boil them then donate them to others.")
        items.append(socks)
        
        let tshirt = item(id: UUID(), name: "Tshirt", imageName: "clothTshirt",
                          category: .donate,
                          description: "This is an old T-shirt, tap me for more info.",
                          advise: "Tips: Clothing donations are common, make sure you wash it before put it in the donate station!")
        items.append(tshirt)
        
        let ice = item(id: UUID(), name: "Ice in Glass", imageName: "cupGlassIce",
                       category: .liquid,
                       description: "It's a cracked shot glass with ice in it, tap me for more info.",
                       advise: "Tips: This cup has ice in it, if thrown it straight into the bin it will wet the rest of the rubbish, pour the ice into the sink first is better.")
        items.append(ice)
        
        let coffee = item(id: UUID(), name: "Coffee", imageName: "cupPaperCoffee",
                          category: .liquid,
                          description: "It's a disposable paper cup filled with coffee, tap me for more info.",
                          advise: "Tips: This paper cup is filled with coffee, pour the coffee out so the paper cup is recyclable!")
        items.append(coffee)
        
        let cupOfWater = item(id: UUID(), name: "Cup Of Water", imageName: "cupPaperWater",
                              category: .liquid,
                              description: "This is a single use paper cup filled with water, tap me for more info.",
                              advise: "Tips: This paper cup has water in it, so pour out the water first and recycle the rest of the paper cup pls.")
        items.append(cupOfWater)
        
        let bittenApple = item(id: UUID(), name: "Bitten Apple", imageName: "foodApple",
                               category: .food,
                               subCategory: .biodegradable,
                               description: "It's an apple with a bite on it, who knows if it has anything to do with that company ;)",
                               advise: "Tips: A bitten apple can be classified as either food waste or biodegradable; if it is classified as the former, it may be landfilled, while the latter can be allowed to degrade naturally and become fertiliser for the soil.")
        items.append(bittenApple)
        
        let staleBiscuit = item(id: UUID(), name: "Stale Biscuit", imageName: "foodBiscuit",
                           category: .food,
                           description: "This package of cookies has expired and is inedible, tap me for more info.",
                           advise: "Tips: Stale biscuits belongs to the food waste, if you have pet fish at home, it's good to break up these biscuits and feed them. My little fish at home just love it!")
        items.append(staleBiscuit)
        
        let staleBread = item(id: UUID(), name: "Stale Bread", imageName: "foodBread",
                         category: .food,
                         description: "Bread expires really fast, doesn't it?",
                         advise: "Tips: Bread is a food waste, and like biscuits, it's good to feed it to fish before you have to throw it away.")
        items.append(staleBread)
        
        let staleCheese = item(id: UUID(), name: "Stale Cheese", imageName: "foodCheese",
                          category: .food,
                          description: "This cheese has expired without you realizing it, tap me for more info.",
                          advise: "Tips: Expired cheese is classed as food waste and unfortunately we can't feed it to the fish this time. Maybe the ants will eat it, but let's not throw it around!")
        items.append(staleCheese)
        
        let coffeeGrounds = item(id: UUID(), name: "Coffee Grounds", imageName: "foodCoffeeGrounds",
                                 category: .food,
                                 subCategory: .biodegradable,
                                 description: "Here's the grounds left over after the coffee lovers have finished making their coffee.",
                                 advise: "Tips: If you drink coffee on a regular basis, the resulting coffee grounds are a good thing. It can be discarded straight away as food waste, but even more amazingly, you can ferment it in the open air and use it as fertiliser for your plants!")
        items.append(coffeeGrounds)
        
        let eggShell = item(id: UUID(), name: "Egg Shell", imageName: "foodEggShell",
                            category: .food,
                            subCategory: .biodegradable,
                            description: "These are leftover eggshells from cooking, tap me for more info.",
                            advise: "Tips: Egg shells are very common food waste, but it would be a shame if you just threw them away. They can be placed in pots and the residual egg white can seep into the soil to nourish the plants. The houseplants grew well after I did this!")
        items.append(eggShell)
        
        let orange = item(id: UUID(), name: "Orange", imageName: "foodOrange",
                          category: .food,
                          subCategory: .biodegradable,
                          description: "This is half an orange, because it's just too sour and you don't want to eat it.",
                          advise: "Tips: How can you not eat all this delicious orange. What? Too sour? Well, sort it into food waste. In fact it is also biodegradable, but few people will use oranges to nourish the soil I guess...")
        items.append(orange)
        
        let orangePeel = item(id: UUID(), name: "Orange Peel", imageName: "foodOrangePeel",
                              category: .food,
                              subCategory: .biodegradable,
                              description: "This is leftover orange peel from an orange, tap me for more info.",
                              advise: "Tips: Orange peels can be thrown straight away as food waste or placed in pots to provide nutrients to the soil. Most unexpectedly, it is edible when pickled! In my country everyone loves orange peels, try it and protect the environment!")
        items.append(orangePeel)
        
        let riceWater = item(id: UUID(), name: "Water from Washed Rice", imageName: "foodRiceWater",
                             category: .liquid,
                             subCategory: .biodegradable,
                             description: "This is the water left over from washing the rice. It looks cloudy, tap me for more info.",
                             advise: "Tips: If you steam rice regularly, then this water is very common in the process of cleaning rice. You can either pour it in sink or use it to water your flowers, it provides a lot of nutrients to the soil. Yes, it's biodegradable as well.")
        items.append(riceWater)
        
        let teabag = item(id: UUID(), name: "Teabag", imageName: "foodTeabag",
                          category: .food,
                          subCategory: .biodegradable,
                          description: "It's a disposable tea bag left over from drinking tea, tap me for more info.",
                          advise: "Tips: The teabag belongs to food waste, but of course, you can also take out the tea inside, and after fermentation the tea can be degraded by microorganisms in the soil.")
        items.append(teabag)
        
        let brokeniPhone = item(id: UUID(), name: "Broken iPhone", imageName: "iphoneBroken",
                                category: .donate,
                                description: "Oops! You found a broken iPhone, tap me for more info.",
                                advise: "Tips: A broken iPhone is technically e-waste and should be given to organizations that specializes in recycling electronics. But this time, let's count it as donatable item. If you have an old iPhone, you can sell it or check out Apple Trade In Plan XD")
        items.append(brokeniPhone)
        
        let clingFilm = item(id: UUID(), name: "Cling Film", imageName: "plasticFilm",
                               category: .nonrecyclable,
                               description: "It's a very common piece of plastic wrap found in kitchens, tap me for more info.",
                               advise: "Tips: Cling film is very common in everyday life, but so many people in my neighborhood mistakenly think it is recyclable, when in fact it is a non-recyclable waste.")
        items.append(clingFilm)
        
        let bulb = item(id: UUID(), name: "Broken Blub", imageName: "sharpBlub",
                        category: .nonrecyclable,
                        description: "It's a replaced bulb that no longer works, tap me for more info.",
                        advise: "Tips: Light bulbs are non-recyclable garbage, if you throw them away randomly, they will break into glass shards and cause damage. Before you throw it away, it's better to find a box and put it inside before throwing it away.")
        items.append(bulb)
        
        let glassShard = item(id: UUID(), name: "Glass Shard", imageName: "sharpGlassShard",
                              category: .nonrecyclable,
                              description: "It's a very sharp shard of glass, tap me for more info.",
                              advise: "Tips: Glass shard is non-recyclable garbage and must be wrapped in tape before throwing it away, otherwise it can easily hurt others!")
        items.append(glassShard)
        
        let mercuryThermometer = item(id: UUID(), name: "Mercury Thermometer", imageName: "mercuryThermometer",
                                  category: .nonrecyclable,
                                  description: "It's an old mercury thermometer that doesn't work anymore, tap me for more info.",
                                  advise: "Tips: Mercury thermometers are dangerous items, once they break, not only will the glass shard hurt human, but the mercury inside is even more harmful. This non-recyclable garbage should always be thrown away in a container.")
        items.append(mercuryThermometer)
        
        tempItems = items
    }
}
