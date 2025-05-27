import SpriteKit

class WinScene: SKScene {
    var moves: Int = 0
    var time: TimeInterval = 0
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.1, green: 0.5, blue: 0.1, alpha: 1.0)
        
        let winLabel = SKLabelNode(text: "You Win!")
        winLabel.fontName = "Avenir-Bold"
        winLabel.fontSize = 48
        winLabel.fontColor = .white
        winLabel.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        addChild(winLabel)
        
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        let timeLabel = SKLabelNode(text: String(format: "Time: %02d:%02d", minutes, seconds))
        timeLabel.fontName = "Avenir-Bold"
        timeLabel.fontSize = 36
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: size.width/2, y: size.height * 0.55)
        addChild(timeLabel)
        
        let movesLabel = SKLabelNode(text: "Moves: \(moves)")
        movesLabel.fontName = "Avenir-Bold"
        movesLabel.fontSize = 36
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: size.width/2, y: size.height * 0.45)
        addChild(movesLabel)
        
        let menuButton = SKSpriteNode(color: .systemBlue, size: CGSize(width: 200, height: 60))
        menuButton.position = CGPoint(x: size.width/2, y: size.height * 0.3)
        menuButton.name = "menuButton"
        
        let menuLabel = SKLabelNode(text: "Back to Menu")
        menuLabel.fontName = "Avenir-Bold"
        menuLabel.fontSize = 24
        menuLabel.fontColor = .white
        menuLabel.verticalAlignmentMode = .center
        menuButton.addChild(menuLabel)
        
        addChild(menuButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "menuButton" {
                AudioManager.shared.transitionToMusic(.menu)
                VibrationManager.shared.vibrate()
                
                let menuScene = MenuScene(size: size)
                menuScene.scaleMode = scaleMode
                view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 0.5))
            }
        }
    }
}
