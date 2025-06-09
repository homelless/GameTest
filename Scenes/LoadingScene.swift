
import SpriteKit

final class LoadingScene: SKScene {
    
    // MARK: - Constants
    private enum Constants {
        static let loadingDuration: TimeInterval = 4.0
        static let fadeDuration: TimeInterval = 1.0
        static let blinkDuration: TimeInterval = 1.0
        static let bounceDuration: TimeInterval = 2.5
        static let loadingText = "Loading..."
        static let fontName = "Avenir-Bold"
        static let fontSize: CGFloat = 21
    }
    
    // MARK: - Nodes
    private lazy var backgroundNode: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "background")
        node.position = CGPoint(x: size.width/2, y: size.height/2)
        node.size = self.size
        node.zPosition = -1
        return node
    }()
    
    private lazy var loadingLabel: SKLabelNode = {
        let label = SKLabelNode(text: Constants.loadingText)
        label.fontName = Constants.fontName
        label.fontSize = Constants.fontSize
        label.fontColor = .white
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        return label
    }()
    
    private lazy var loadingLight: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "light")
        node.position = CGPoint(x: size.width/1.9, y: size.height/1.25)
        node.zPosition = 5
        node.size = CGSize(width: 301, height: 460)
        return node
    }()
    
    private lazy var fruitNodes: [SKSpriteNode] = {
        let grape = createFruitNode(imageNamed: "grape", position: CGPoint(x: size.width/1.3, y: size.height/1.15), size: CGSize(width: 70, height: 70))
        let lemon = createFruitNode(imageNamed: "lemon", position: CGPoint(x: size.width/8, y: size.height/3.2), size: CGSize(width: 45, height: 55))
        let orange = createFruitNode(imageNamed: "orange", position: CGPoint(x: size.width/1.1, y: size.height/7.5), size: CGSize(width: 70, height: 80))
        let cherries = createFruitNode(imageNamed: "cherries", position: CGPoint(x: size.width/1.08, y: size.height/2.3), size: CGSize(width: 110, height: 120))
        return [grape, lemon, orange, cherries]
    }()
    
    private lazy var starNodes: [SKSpriteNode] = {
        let starsOne = createStarNode(imageNamed: "starsOne", position: CGPoint(x: size.width/3.4, y: size.height/1.2), size: CGSize(width: 220, height: 180))
        let starsTwo = createStarNode(imageNamed: "starsTwo", position: CGPoint(x: size.width/1.5, y: size.height/1.8), size: CGSize(width: 300, height: 222))
        let starsThree = createStarNode(imageNamed: "starsThree", position: CGPoint(x: size.width/2.7, y: size.height/4.6), size: CGSize(width: 280, height: 200))
        return [starsOne, starsTwo, starsThree]
    }()
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
        startAnimations()
        scheduleTransition()
    }
    
    // MARK: - Scene Setup
    private func setupScene() {
        addChild(backgroundNode)
        fruitNodes.forEach { addChild($0) }
        starNodes.forEach { addChild($0) }
        addChild(loadingLight)
        addChild(loadingLabel)
    }
    
    // MARK: - Node Factory Methods
    private func createFruitNode(imageNamed: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.position = position
        node.zPosition = 2
        node.size = size
        return node
    }
    
    private func createStarNode(imageNamed: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.position = position
        node.zPosition = 2
        node.size = size
        return node
    }
    
    // MARK: - Animations
    private func startAnimations() {
        startLoadingAnimation()
        startLightBounceAnimation()
    }
    
    private func startLoadingAnimation() {
        let blinkAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: Constants.blinkDuration),
            SKAction.fadeIn(withDuration: Constants.blinkDuration)
        ])
        loadingLabel.run(SKAction.repeatForever(blinkAction))
    }
    
    private func startLightBounceAnimation() {
        let moveUp = SKAction.moveTo(y: size.height * 0.85, duration: Constants.bounceDuration)
        moveUp.timingMode = .easeInEaseOut
        
        let moveDown = SKAction.moveTo(y: size.height/4, duration: Constants.bounceDuration)
        moveDown.timingMode = .easeInEaseOut
        
        let bounceSequence = SKAction.sequence([moveDown, moveUp])
        loadingLight.run(SKAction.repeatForever(bounceSequence))
    }
    
    // MARK: - Scene Transition
    private func scheduleTransition() {
        let waitAction = SKAction.wait(forDuration: Constants.loadingDuration)
        let transitionAction = SKAction.run { [weak self] in
            self?.transitionToMainMenu()
        }
        
        run(SKAction.sequence([waitAction, transitionAction]))
    }
    
    private func transitionToMainMenu() {
        let menuScene = MenuScene(size: size)
        menuScene.scaleMode = scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: Constants.fadeDuration))
    }
}
