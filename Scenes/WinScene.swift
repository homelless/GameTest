import SpriteKit

class WinScene: SKScene {
    
    // MARK: - Constants
    private enum Constants {
        static let buttonScaleActionDuration: TimeInterval = 0.1
        static let buttonScaleFactor: CGFloat = 0.9
        static let sceneTransitionDuration: TimeInterval = 0.3
        static let fadeTransitionDuration: TimeInterval = 0.5
        
        static let timerFormat = "Time: %02d:%02d"
        static let movesText = "Movies: %d"
        
        static let dimmingLayerAlpha: CGFloat = 0.5
    }
    
    // MARK: - Nodes
    private var dimmingLayer: SKSpriteNode!
    private var timerLabel: SKLabelNode!
    private var movesLabel: SKLabelNode!
    
 
    private let fruits: [(name: String, position: CGPoint, size: CGSize, zPosition: CGFloat)] = [
        ("grape", CGPoint(x: 1.3, y: 1.15), CGSize(width: 70, height: 70), 2),
        ("lemon", CGPoint(x: 8, y: 3.2), CGSize(width: 45, height: 55), 2),
        ("orange", CGPoint(x: 1.1, y: 7.5), CGSize(width: 70, height: 80), 2),
        ("cherries", CGPoint(x: 1.08, y: 2.3), CGSize(width: 110, height: 120), 2)
    ]
    

    private let stars: [(name: String, position: CGPoint, size: CGSize, zPosition: CGFloat)] = [
        ("starsOne", CGPoint(x: 3.4, y: 1.2), CGSize(width: 220, height: 180), 2),
        ("starsTwo", CGPoint(x: 1.5, y: 1.8), CGSize(width: 300, height: 222), 2),
        ("starsThree", CGPoint(x: 2.7, y: 4.6), CGSize(width: 280, height: 200), 2)
    ]
    
   
    private lazy var menuButton: SKSpriteNode = {
        createButton(named: "menuButton", position: CGPoint(x: 1.7, y: 3.7), size: CGSize(width: 43, height: 43), name: "menuButton")
    }()
    
    private lazy var reloadButton: SKSpriteNode = {
        createButton(named: "reload", position: CGPoint(x: 2.2, y: 3.7), size: CGSize(width: 43, height: 43), name: "reloadButton")
    }()
    

    private lazy var loadingLight: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "light")
        node.position = relativePosition(for: CGPoint(x: 1.9, y: 1.3))
        node.zPosition = 3
        node.size = CGSize(width: 301, height: 460)
        return node
    }()
    
    private lazy var winLabel: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "win")
        node.size = CGSize(width: 350, height: 350)
        node.zPosition = 5
        node.position = CGPoint(x: size.width/2, y: size.height/1.75)
        return node
    }()
    
    private lazy var resultsTable: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "bordResalts")
        node.size = CGSize(width: 305, height: 162)
        node.zPosition = 4
        node.position = CGPoint(x: size.width/2, y: size.height/2.5)
        return node
    }()
    
    // MARK: - Properties
    var moves: Int = 0 {
        didSet {
            movesLabel.text = String(format: Constants.movesText, moves)
        }
    }
    
    var time: TimeInterval = 0 {
        didSet {
            updateTimerText()
        }
    }
    
    // MARK: - Initialization
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Scene Lifecycle
    override func didMove(to view: SKView) {
        setupDimmingLayer()
        setupFruits()
        setupStars()
        setupUIElements()
    }
    
    override func update(_ currentTime: TimeInterval) {
        updateTimerText()
    }
    
    // MARK: - Touch Handling
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            handleButtonTap(on: node)
        }
    }
    
    // MARK: - Private Methods
    private func setupDimmingLayer() {
        dimmingLayer = SKSpriteNode(
            color: UIColor.black.withAlphaComponent(Constants.dimmingLayerAlpha),
            size: size
        )
        dimmingLayer.position = CGPoint(x: size.width/2, y: size.height/2)
        dimmingLayer.zPosition = 1
        addChild(dimmingLayer)
    }
    
    private func setupFruits() {
        for fruit in fruits {
            let node = SKSpriteNode(imageNamed: fruit.name)
            node.position = relativePosition(for: fruit.position)
            node.zPosition = fruit.zPosition
            node.size = fruit.size
            addChild(node)
        }
    }
    
    private func setupStars() {
        for star in stars {
            let node = SKSpriteNode(imageNamed: star.name)
            node.position = relativePosition(for: star.position)
            node.zPosition = star.zPosition
            node.size = star.size
            addChild(node)
        }
    }
    
    private func setupUIElements() {
        
        timerLabel = createLabel(
            text: "",
            position: CGPoint(x: size.width/2, y: size.height/2.7),
            fontSize: 20
        )
        updateTimerText()
        
       
        movesLabel = createLabel(
            text: String(format: Constants.movesText, moves),
            position: CGPoint(x: size.width/2, y: size.height/2.5),
            fontSize: 20
        )
        
        // Add other UI elements
        addChild(loadingLight)
        addChild(winLabel)
        addChild(resultsTable)
        addChild(menuButton)
        addChild(reloadButton)
    }
    
    private func createButton(named imageName: String, position: CGPoint, size: CGSize, name: String) -> SKSpriteNode {
        let button = SKSpriteNode(imageNamed: imageName)
        button.position = relativePosition(for: position)
        button.size = size
        button.zPosition = 5
        button.name = name
        return button
    }
    
    private func createLabel(text: String, position: CGPoint, fontSize: CGFloat) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "Avenir-Bold"
        label.fontSize = fontSize
        label.fontColor = .white
        label.zPosition = 5
        label.position = position
        addChild(label)
        return label
    }
    // преобразование относительных координат в абсолютные
    private func relativePosition(for relativePoint: CGPoint) -> CGPoint {
        CGPoint(x: size.width / relativePoint.x, y: size.height / relativePoint.y)
    }
    
    private func updateTimerText() {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        timerLabel.text = String(format: Constants.timerFormat, minutes, seconds)
    }
    
    private func handleButtonTap(on node: SKNode) {
        guard let name = node.name else { return }
        
        let scaleAction = SKAction.scale(
            to: Constants.buttonScaleFactor,
            duration: Constants.buttonScaleActionDuration
        )
        
        node.run(scaleAction) { [weak self] in
            guard let self = self else { return }
            
            switch name {
            case "menuButton":
                self.presentMenuScene()
            case "reloadButton":
                self.presentGameScene()
            default:
                break
            }
            
            AudioManager.shared.playEffect(.buttonClick)
            VibrationManager.shared.vibrate()
        }
    }
    
    private func presentMenuScene() {
        let menu = MenuScene(size: size)
        view?.presentScene(menu, transition: .doorsCloseVertical(withDuration: Constants.sceneTransitionDuration))
        AudioManager.shared.playMusic(.menu)
    }
    
    private func presentGameScene() {
        let newGame = GameScene(size: size)
        view?.presentScene(newGame, transition: .fade(withDuration: Constants.fadeTransitionDuration))
        AudioManager.shared.playMusic(.match)
    }
}




