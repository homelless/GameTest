
import SpriteKit

class WinScene: SKScene {
    private var frozenBackground: SKSpriteNode!
    private var dimmingLayer: SKSpriteNode!
    
    private var grape: SKSpriteNode!
    private var lemon: SKSpriteNode!
    private var orange: SKSpriteNode!
    private var cherries: SKSpriteNode!
    private var starsOne: SKSpriteNode!
    private var starsTwo: SKSpriteNode!
    private var starsThree: SKSpriteNode!
    private var loadingLight: SKSpriteNode!
    private var menuButton: SKSpriteNode!
    private var reloadButton: SKSpriteNode!
    private var timerLabel: SKLabelNode!
    private var movesLabel: SKLabelNode!
    private var winLabel: SKSpriteNode!
    private var resaltsTable: SKSpriteNode!
    
    //
    var moves: Int = 0
    var time: TimeInterval = 0
    
    
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        // Создаем полупрозрачный фон
        dimmingLayer = SKSpriteNode(color: UIColor.black.withAlphaComponent(0.5), size: self.size)
        dimmingLayer.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        dimmingLayer.zPosition = 1
        addChild(dimmingLayer)
        
        grape = SKSpriteNode(imageNamed: "grape")
        grape.position = CGPoint(x: size.width/1.3, y: size.height/1.15)
        grape.zPosition = 2
        grape.size = CGSize(width: 70, height: 70)
        addChild(grape)
        
        lemon = SKSpriteNode(imageNamed: "lemon")
        lemon.position = CGPoint(x: size.width/8, y: size.height/3.2)
        lemon.zPosition = 2
        lemon.size = CGSize(width: 45, height: 55)
        addChild(lemon)
        
        orange = SKSpriteNode(imageNamed: "orange")
        orange.position = CGPoint(x: size.width/1.1, y: size.height/7.5)
        orange.zPosition = 2
        orange.size = CGSize(width: 70, height: 80)
        addChild(orange)
        
        cherries = SKSpriteNode(imageNamed: "cherries")
        cherries.position = CGPoint(x: size.width/1.08, y: size.height/2.3)
        cherries.zPosition = 2
        cherries.size = CGSize(width: 110, height: 120)
        addChild(cherries)
        
        starsOne = SKSpriteNode(imageNamed: "starsOne")
        starsOne.position = CGPoint(x: size.width/3.4, y: size.height/1.2)
        starsOne.zPosition = 2
        starsOne.size = CGSize(width: 220, height: 180)
        addChild(starsOne)
        
        starsTwo = SKSpriteNode(imageNamed: "starsTwo")
        starsTwo.position = CGPoint(x: size.width/1.5, y: size.height/1.8)
        starsTwo.zPosition = 2
        starsTwo.size = CGSize(width: 300, height: 222)
        addChild(starsTwo)
        
        starsThree = SKSpriteNode(imageNamed: "starsThree")
        starsThree.position = CGPoint(x: size.width/2.7, y: size.height/4.6)
        starsThree.zPosition = 2
        starsThree.size = CGSize(width: 280, height: 200)
        addChild(starsThree)
        
        
        loadingLight = SKSpriteNode(imageNamed: "light")
        loadingLight.position = CGPoint(x: size.width/1.9, y: size.height/1.3)
        loadingLight.zPosition = 3
        loadingLight.size = CGSize(width: 301, height: 460)
        addChild(loadingLight)
        
        reloadButton = SKSpriteNode(imageNamed: "reload")
        reloadButton.position = CGPoint(x: size.width/2.2, y: size.height/3.7)
        reloadButton.size = CGSize(width: 43, height: 43)
        reloadButton.zPosition = 5
        reloadButton.name = "reloadButton"
        addChild(reloadButton)
        
        
        timerLabel = SKLabelNode(text: "Time: \(Int(time))")
        timerLabel.fontName = "Avenir-Bold"
        timerLabel.fontSize = 20
        timerLabel.fontColor = .white
        timerLabel.zPosition = 5
        timerLabel.position = CGPoint(x: size.width/2, y: size.height/2.7)
        addChild(timerLabel)
        
        // Счетчик ходов
        movesLabel = SKLabelNode(text: "Movies: \(moves)")
        movesLabel.fontName = "Avenir-Bold"
        movesLabel.fontSize = 20
        movesLabel.fontColor = .white
        movesLabel.zPosition = 5
        movesLabel.position = CGPoint(x: size.width/2, y: size.height/2.5)
        addChild(movesLabel)
        
        menuButton = SKSpriteNode(imageNamed: "menuButton")
        menuButton.size = CGSize(width: 43, height: 43)
        menuButton.zPosition = 5
        menuButton.name = "menuButton"
        menuButton.position = CGPoint(x: size.width/1.7, y: size.height/3.7)
        addChild(menuButton)
        
        winLabel = SKSpriteNode(imageNamed: "win")
        winLabel.size = CGSize(width: 350, height: 350)
        winLabel.zPosition = 5
        winLabel.position = CGPoint(x: size.width/2, y: size.height/1.75)
        addChild(winLabel)
        
        resaltsTable = SKSpriteNode(imageNamed: "bordResalts")
        resaltsTable.size = CGSize(width: 305, height: 162)
        resaltsTable.zPosition = 4
        resaltsTable.position = CGPoint(x: size.width/2, y: size.height/2.5)
        addChild(resaltsTable)
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        timerLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "menuButton" {
                let scaleAction = SKAction.scale(to: 0.9, duration: 0.1)
                node.run(scaleAction) {
                    let menu = MenuScene(size: self.size)
                    self.view?.presentScene(menu, transition: .doorsCloseVertical(withDuration: 0.3))
                }
            } else if node.name == "reloadButton" {
                let scaleAction = SKAction.scale(to: 0.9, duration: 0.1)
                node.run(scaleAction) {
                        let newGame = GameScene(size: self.size)
                        self.view?.presentScene(newGame, transition: .fade(withDuration: 0.5))
                }
            }
        }
    }
}
