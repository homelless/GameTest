import SpriteKit
import SafariServices

final class MenuScene: SKScene {
    
    // MARK: - Constants
    private enum Constants {
        static let buttonClickSound: AudioManager.soundEffect = .buttonClick
        static let transitionMusic: AudioManager.musicTrack = .match
        static let privacyPolicyURL = "https://en.wikipedia.org/wiki/Privacy_policy"
        static let transitionDuration: TimeInterval = 0.5
        static let pushTransitionDuration: TimeInterval = 0.3
        
        enum NodeNames {
            static let playButton = "playButton"
            static let privacyButton = "privacyButton"
            static let settingsButton = "settingsButton"
        }
        
        enum ZPosition {
            static let background: CGFloat = -1
            static let defaultNode: CGFloat = 1
            static let foregroundNode: CGFloat = 2
            static let lightNode: CGFloat = 1
        }
    }
    
    // MARK: - Nodes
    private lazy var backgroundNode: SKSpriteNode = {
        createBackgroundNode()
    }()
    
    private lazy var playButton: SKSpriteNode = {
        createButtonNode(
            imageNamed: "playButton",
            name: Constants.NodeNames.playButton,
            position: CGPoint(x: size.width/2, y: size.height/2.5),
            size: CGSize(width: 250, height: 61)
        )
    }()
    
    private lazy var privacyButton: SKSpriteNode = {
        createButtonNode(
            imageNamed: "privacyButton",
            name: Constants.NodeNames.privacyButton,
            position: CGPoint(x: size.width/2, y: size.height/3.1),
            size: CGSize(width: 160, height: 31)
        )
    }()
    
    private lazy var settingsButton: SKSpriteNode = {
        createButtonNode(
            imageNamed: "settings",
            name: Constants.NodeNames.settingsButton,
            position: CGPoint(x: size.width/1.1, y: size.height/1.1),
            size: CGSize(width: 43, height: 43)
        )
    }()
    
    private lazy var cap: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "cap")
        node.position = CGPoint(x: size.width/2, y: size.height/1.65)
        node.zPosition = Constants.ZPosition.foregroundNode
        node.size = CGSize(width: 330, height: 330)
        return node
    }()
    
    private lazy var loadingLight: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "light")
        node.position = CGPoint(x: size.width/1.9, y: size.height/1.3)
        node.zPosition = Constants.ZPosition.lightNode
        node.size = CGSize(width: 301, height: 460)
        return node
    }()
    
    private lazy var fruitNodes: [SKSpriteNode] = {
        [
            createFruitNode(imageNamed: "grape", position: CGPoint(x: size.width/1.3, y: size.height/1.15), size: CGSize(width: 70, height: 70)),
            createFruitNode(imageNamed: "lemon", position: CGPoint(x: size.width/8, y: size.height/3.2), size: CGSize(width: 45, height: 55)),
            createFruitNode(imageNamed: "orange", position: CGPoint(x: size.width/1.1, y: size.height/7.5), size: CGSize(width: 70, height: 80)),
            createFruitNode(imageNamed: "cherries", position: CGPoint(x: size.width/1.08, y: size.height/2.3), size: CGSize(width: 110, height: 120))
        ]
    }()
    
    private lazy var starNodes: [SKSpriteNode] = {
        [
            createStarNode(imageNamed: "starsOne", position: CGPoint(x: size.width/3.4, y: size.height/1.2), size: CGSize(width: 220, height: 180)),
            createStarNode(imageNamed: "starsTwo", position: CGPoint(x: size.width/1.5, y: size.height/1.8), size: CGSize(width: 300, height: 222)),
            createStarNode(imageNamed: "starsThree", position: CGPoint(x: size.width/2.7, y: size.height/4.6), size: CGSize(width: 280, height: 200))
        ]
    }()
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }
    
    // MARK: - Scene Setup
    private func setupScene() {
        addChild(backgroundNode)
        fruitNodes.forEach { addChild($0) }
        starNodes.forEach { addChild($0) }
        addChild(loadingLight)
        addChild(playButton)
        addChild(cap)
        addChild(privacyButton)
        addChild(settingsButton)
    }
    
    // MARK: - Node Factory Methods
    private func createBackgroundNode() -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: "background")
        node.position = CGPoint(x: size.width/2, y: size.height/2)
        node.size = self.size
        node.zPosition = Constants.ZPosition.background
        return node
    }
    
    private func createButtonNode(imageNamed: String, name: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.name = name
        node.position = position
        node.zPosition = Constants.ZPosition.foregroundNode
        node.size = size
        return node
    }
    
    private func createFruitNode(imageNamed: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.position = position
        node.zPosition = Constants.ZPosition.foregroundNode
        node.size = size
        return node
    }
    
    private func createStarNode(imageNamed: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.position = position
        node.zPosition = Constants.ZPosition.foregroundNode
        node.size = size
        return node
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            handleButtonTap(on: node)
        }
    }
    
    private func handleButtonTap(on node: SKNode) {
        switch node.name {
        case Constants.NodeNames.playButton:
            handlePlayButtonTap()
        case Constants.NodeNames.privacyButton:
            handlePrivacyButtonTap()
        case Constants.NodeNames.settingsButton:
            handleSettingsButtonTap()
        default:
            break
        }
    }
    
    private func handlePlayButtonTap() {
        playButtonEffects()
        
        let gameScene = GameScene(size: size)
        gameScene.scaleMode = scaleMode
        view?.presentScene(gameScene, transition: SKTransition.doorsOpenVertical(withDuration: Constants.transitionDuration))
        AudioManager.shared.transitionToMusic(Constants.transitionMusic)
    }
    
    private func handlePrivacyButtonTap() {
        playButtonEffects()
        
        if let url = URL(string: Constants.privacyPolicyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    private func handleSettingsButtonTap() {
        playButtonEffects()
        
        let settingsScene = SettingsScene(size: size, previousScene: self)
        settingsScene.scaleMode = .aspectFill
        view?.presentScene(settingsScene, transition: SKTransition.push(with: .left, duration: Constants.pushTransitionDuration))
    }
    
    private func playButtonEffects() {
        AudioManager.shared.playEffect(Constants.buttonClickSound)
        VibrationManager.shared.vibrate()
    }
}






