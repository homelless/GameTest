import SpriteKit

class Card: SKSpriteNode {
    let type: String
    var isFlipped = false
    var frontTexture: SKTexture
    
    var flipAnimation: SKAction?
    var currentFlipSequence: SKAction?
    
    private var backTexture = SKTexture(imageNamed: "card_back")
    
    init(type: String) {
        self.type = type
        self.frontTexture = SKTexture(imageNamed: type)
        super.init(texture: backTexture, color: .clear, size: backTexture.size())
        
        isUserInteractionEnabled = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func flipToFront() {
        isFlipped = true
        let flipAction = SKAction.scaleX(to: 0, duration: 0.1)
        let changeTexture = SKAction.run { [weak self] in
            self?.texture = self?.frontTexture
        }
        let flipBack = SKAction.scaleX(to: 1, duration: 0.1)
        run(SKAction.sequence([flipAction, changeTexture, flipBack]))
    }
    
    func flipToBack() {
        isFlipped = false
        let flipAction = SKAction.scaleX(to: 0, duration: 0.1)
        let changeTexture = SKAction.run { [weak self] in
            self?.texture = self?.backTexture
        }
        let flipBack = SKAction.scaleX(to: 1, duration: 0.1)
        run(SKAction.sequence([flipAction, changeTexture, flipBack]))
    }
}
