import SpriteKit
import SafariServices

class MenuScene: SKScene {
    private var playButton: SKSpriteNode!
    private var privacyButton: SKSpriteNode!
    private var settingsButton: SKSpriteNode!
    private var titleLabel: SKLabelNode!
    
    private var backgroundNode: SKSpriteNode!
    private var loadingLabel: SKLabelNode!
    private var loadingLight: SKSpriteNode!
    private var grape: SKSpriteNode!
    private var lemon: SKSpriteNode!
    private var orange: SKSpriteNode!
    private var cherries: SKSpriteNode!
    private var starsOne: SKSpriteNode!
    private var starsTwo: SKSpriteNode!
    private var starsThree: SKSpriteNode!
    private var cap: SKSpriteNode!
    
    weak var viewController: UIViewController?
    
    override func didMove(to view: SKView) {
        UIElements()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "playButton" {
                AudioManager.shared.playEffect(.buttonClick)
                VibrationManager.shared.vibrate()
                
                let gameScene = GameScene(size: size)
                gameScene.scaleMode = scaleMode
                view?.presentScene(gameScene, transition: SKTransition.doorsOpenVertical(withDuration: 0.5))
                AudioManager.shared.transitionToMusic(.match)
            }
            else if node.name == "privacyButton" {
                AudioManager.shared.playEffect(.buttonClick)
                VibrationManager.shared.vibrate()
                
                if let url = URL(string: "https://en.wikipedia.org/wiki/Privacy_policy#:~:text=A%20privacy%20policy%20is%20a,a%20customer%20or%20client's%20data.") {
                    UIApplication.shared.open(url)                }
            }
            else if node.name == "settingsButton" {
                AudioManager.shared.playEffect(.buttonClick)
                VibrationManager.shared.vibrate()
                
                let settingsScene = SettingsScene(size: size)
                settingsScene.scaleMode = scaleMode
                settingsScene.backToMenu = true
                view?.presentScene(settingsScene, transition: SKTransition.push(with: .left, duration: 0.3))
            }
        }
    }
    
    private func UIElements() {
        backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.size = self.size
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
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
        loadingLight.zPosition = 1
        loadingLight.size = CGSize(width: 301, height: 460)
        addChild(loadingLight)
        
        playButton = SKSpriteNode(imageNamed: "playButton")
        playButton.name = "playButton"
        playButton.position = CGPoint(x: size.width/2, y: size.height/2.5)
        playButton.zPosition = 1
        playButton.size = CGSize(width: 250, height: 61)
        addChild(playButton)
        
        cap = SKSpriteNode(imageNamed: "cap")
        cap.position = CGPoint(x: size.width/2, y: size.height/1.65)
        cap.zPosition = 2
        cap.size = CGSize(width: 330, height: 330)
        addChild(cap)
        
        privacyButton = SKSpriteNode(imageNamed: "privacyButton")
        privacyButton.name = "privacyButton"
        privacyButton.position = CGPoint(x: size.width/2, y: size.height/4)
        privacyButton.zPosition = 2
        privacyButton.size = CGSize(width: 160, height: 31)
        addChild(privacyButton)
        
        settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.name = "settingsButton"
        settingsButton.position = CGPoint(x: size.width/1.1, y: size.height/1.1)
        settingsButton.zPosition = 2
        settingsButton.size = CGSize(width: 43, height: 43)
        addChild(settingsButton)
        
        
    }
    
    
    
    
    
}
