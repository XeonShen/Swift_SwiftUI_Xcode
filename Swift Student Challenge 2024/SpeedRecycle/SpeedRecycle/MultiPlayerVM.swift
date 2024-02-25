import SwiftUI
import SpriteKit
import CoreMotion

class PlayerGameData: ObservableObject {
    @Published var score: Int = 0
    @Published var gameIsStart: Bool = false
    @Published var playerWin: Bool = false
}

class PlayerGameScene: SKScene {
    var playerGameData: PlayerGameData?
    
    var recycleItemM = RecycleItemM()
    var items: Array<RecycleItemM.item> { recycleItemM.items }
    var itemIndex = 0
    
    let motionManager = CMMotionManager()
    
//MARK: - Functions - set scene items
    
    func setBackgroundImage() {
        let backgroundImage = SKSpriteNode(imageNamed: "BackgroundMarble")
        backgroundImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundImage.zPosition = -2
        backgroundImage.scale(to: self.size)
        addChild(backgroundImage)
    }
    
    func setDock() {
        //create a container node
        let container = SKNode()
        container.position = CGPoint(x: 50, y: size.height / 7)
        
        //add images as children of container
        let trashbinImageName = ["BinRecyclable", "BinNonrecyclable", "BinFood", "BinFluid", "BinDonate", "BinBiodegradable"]
        for (index, imageName) in trashbinImageName.enumerated() {
            let trashbinSprite = SKSpriteNode(imageNamed: imageName)
            trashbinSprite.size = CGSize(width: 50, height: 50)
            trashbinSprite.position = CGPoint(x: 50, y: CGFloat(index) * size.height / 7)
            trashbinSprite.zRotation = CGFloat(-90 * CGFloat.pi / 180)
            trashbinSprite.name = imageName
            container.addChild(trashbinSprite)
        }
        
        //add a rounded rectangle without having a physcial body
        let roundedRect = SKShapeNode(rect: CGRect(x: 0, y: -50, width: 100, height: size.height * 6 / 7), cornerRadius: 30)
        roundedRect.fillColor = SKColor.white
        roundedRect.strokeColor = SKColor.clear
        roundedRect.zPosition = -1
        container.addChild(roundedRect)
        
        //set physical body of container node
        container.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: size.height + 500))
        container.physicsBody?.isDynamic = false
        container.physicsBody?.restitution = 1
        addChild(container)
    }
    
//MARK: - Functions - create and remove items
    
    func CreateSprites(_ index: Int) {
        //get item category name for later use
        var catagoryName: String
        switch items[index].category {
        case .biodegradable: catagoryName = "biodegradable"
        case .donate: catagoryName = "donate"
        case .food: catagoryName = "food"
        case .liquid: catagoryName = "liquid"
        case .nonrecyclable: catagoryName = "nonrecyclable"
        case .recyclable: catagoryName = "recyclable"
        }
        
        //generate random number for later use
        let randomX = CGFloat.random(in: -100...100)
        let randomY = CGFloat.random(in: -100...100)
        
        //create sprite
        guard index < items.count else { return }
        let sprite = SKSpriteNode(imageNamed: items[index].imageName)
        sprite.size = CGSize(width: 100, height: 100)
        sprite.position = CGPoint(x: size.width * 0.75 + randomX, y: size.height / 2 + randomY)
        sprite.zRotation = CGFloat(-90 * CGFloat.pi / 180) //rotate 90 degree clockwise
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width / 2) //give it a physical body
        sprite.physicsBody?.isDynamic = true //make it moveable
        sprite.physicsBody?.angularVelocity = CGFloat.random(in: -5...5)
        sprite.physicsBody?.applyTorque(CGFloat.random(in: -0.1...0.1))
        sprite.physicsBody?.restitution = 1 //make it bouncy
        sprite.name = catagoryName //assign it a name(tag)
        addChild(sprite) //add it to scene
    }
    
    func RemoveSprites(moveTo: CGPoint) {
        let spriteName = ["biodegradable", "donate", "food", "liquid", "nonrecyclable", "recyclable"]
        for name in spriteName {
            if let sprite = self.childNode(withName: name) {
                //create a move action
                let moveAction = SKAction.move(to: moveTo, duration: 0.4)
                //create a fadeout action
                let scaledownAction = SKAction.scale(to: 0, duration: 0.3)
                //create a custom remove action
                let removeSpriteAction = SKAction.run {
                    sprite.removeFromParent()
                    if self.itemIndex == self.items.count - 1 {
                        self.playerGameData?.gameIsStart = false
                        self.playerGameData?.playerWin = true
                        self.isPaused = true
                    }
                    if self.itemIndex < self.items.count - 1 {
                        self.itemIndex += 1
                        self.CreateSprites(self.itemIndex)
                    }
                }
                //those actions run in parallel
                let parallelAction = SKAction.group([moveAction, scaledownAction])
                //those actions run in serial
                let serialAction = SKAction.sequence([parallelAction, removeSpriteAction])
                //run those action
                sprite.run(serialAction)
            }
        }
        playerGameData?.score += 10
    }
        
//MARK: - Set Game Scene
    
    override func didMove(to view: SKView) {
        //set gravity
        self.physicsWorld.gravity = CGVector(dx: -6, dy: 0)
        //set background image
        setBackgroundImage()
        //create sprites
        CreateSprites(itemIndex)
        //Create Dock
        setDock()
        //create invisable boundary around scene
        super.didMove(to: view)
        let screenBounds = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: screenBounds)
        //start accelerometer sensor
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 1.0 / 60.0
            motionManager.startAccelerometerUpdates()
        }
    }
    
//MARK: - Handle Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if node.name == "BinRecyclable" {
                if self.childNode(withName: "recyclable") != nil {
                    RemoveSprites(moveTo: node.position)
                }
            }
            if node.name == "BinNonrecyclable" {
                if self.childNode(withName: "nonrecyclable") != nil {
                    RemoveSprites(moveTo: node.position)
                }
            }
            if node.name == "BinFood" {
                if self.childNode(withName: "food") != nil {
                    RemoveSprites(moveTo: node.position)
                }
            }
            if node.name == "BinFluid" {
                if self.childNode(withName: "liquid") != nil {
                    RemoveSprites(moveTo: node.position)
                }
            }
            if node.name == "BinDonate" {
                if self.childNode(withName: "donate") != nil {
                    RemoveSprites(moveTo: node.position)
                }
            }
            if node.name == "BinBiodegradable" {
                if self.childNode(withName: "biodegradable") != nil {
                    RemoveSprites(moveTo: node.position)
                }
            }
        }
    }
    
//MARK: - Handle Accelerometer Tilting
    
    override func update(_ currentTime: TimeInterval) {
        if let accelerometerData = motionManager.accelerometerData {
            let acceleration = accelerometerData.acceleration
            let movement = CGFloat(acceleration.y) * 10
            
            let spriteName = ["biodegradable", "donate", "food", "liquid", "nonrecyclable", "recyclable"]
            for name in spriteName {
                if let sprite = self.childNode(withName: name) as? SKSpriteNode {
                    //update sprite movement along y axis
                    sprite.position.y += movement
                    //limit movement to screen bounds
                    sprite.position.y = max(sprite.position.y, sprite.size.height / 2)
                    sprite.position.y = min(sprite.position.y, size.height - sprite.size.height / 2)
                }
            }
        }
    }
    
}


