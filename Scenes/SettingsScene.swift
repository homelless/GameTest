import SpriteKit

class SettingsScene: SKScene {
    var backToMenu: Bool = true
    private var soundButton: SKSpriteNode!
    private var vibrationButton: SKSpriteNode!
    private var backButton: SKSpriteNode!
    private var notificationButton: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.3, alpha: 1.0)
        
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.fontName = "Avenir-Bold"
        titleLabel.fontSize = 36
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.8)
        addChild(titleLabel)
        
        // Кнопка звука
        soundButton = SKSpriteNode(color: Settings.shared.isSoundOn ? .systemGreen : .systemRed, size: CGSize(width: 300, height: 60))
        soundButton.position = CGPoint(x: size.width/2, y: size.height * 0.6)
        soundButton.name = "soundButton"
        
        let soundLabel = SKLabelNode(text: "Sound: \(Settings.shared.isSoundOn ? "ON" : "OFF")")
        soundLabel.fontName = "Avenir-Bold"
        soundLabel.fontSize = 24
        soundLabel.fontColor = .white
        soundLabel.verticalAlignmentMode = .center
        soundButton.addChild(soundLabel)
        
        addChild(soundButton)
        
        // Кнопка вибрации
        vibrationButton = SKSpriteNode(color: Settings.shared.isVibrationOn ? .systemGreen : .systemRed, size: CGSize(width: 300, height: 60))
        vibrationButton.position = CGPoint(x: size.width/2, y: size.height * 0.45)
        vibrationButton.name = "vibrationButton"
        
        let vibrationLabel = SKLabelNode(text: "Vibration: \(Settings.shared.isVibrationOn ? "ON" : "OFF")")
        vibrationLabel.fontName = "Avenir-Bold"
        vibrationLabel.fontSize = 24
        vibrationLabel.fontColor = .white
        vibrationLabel.verticalAlignmentMode = .center
        vibrationButton.addChild(vibrationLabel)
        
        addChild(vibrationButton)
        
        // Кнопка уведомлений (опционально)
        notificationButton = SKSpriteNode(color: .systemPurple, size: CGSize(width: 300, height: 60))
        notificationButton.position = CGPoint(x: size.width/2, y: size.height * 0.3)
        notificationButton.name = "notificationButton"
        
        let notificationLabel = SKLabelNode(text: "Notifications")
        notificationLabel.fontName = "Avenir-Bold"
        notificationLabel.fontSize = 24
        notificationLabel.fontColor = .white
        notificationLabel.verticalAlignmentMode = .center
        notificationButton.addChild(notificationLabel)
        
        addChild(notificationButton)
        
        // Кнопка назад
        backButton = SKSpriteNode(color: .systemGray, size: CGSize(width: 200, height: 50))
        backButton.position = CGPoint(x: size.width/2, y: size.height * 0.1)
        backButton.name = "backButton"
        
        let backLabel = SKLabelNode(text: "Back")
        backLabel.fontName = "Avenir-Bold"
        backLabel.fontSize = 24
        backLabel.fontColor = .white
        backLabel.verticalAlignmentMode = .center
        backButton.addChild(backLabel)
        
        addChild(backButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "soundButton" {
             //   AudioManager.shared.playSoundEffect(name: "clickButton")
                VibrationManager.shared.vibrate()
                
                Settings.shared.isSoundOn.toggle()
                if let soundLabel = soundButton.children.first as? SKLabelNode {
                    soundLabel.text = "Sound: \(Settings.shared.isSoundOn ? "ON" : "OFF")"
                    soundButton.color = Settings.shared.isSoundOn ? .systemGreen : .systemRed
                }
            }
            else if node.name == "vibrationButton" {
             //   AudioManager.shared.playSoundEffect(name: "clickButton")
                VibrationManager.shared.vibrate()
                
                Settings.shared.isVibrationOn.toggle()
                if let vibrationLabel = vibrationButton.children.first as? SKLabelNode {
                    vibrationLabel.text = "Vibration: \(Settings.shared.isVibrationOn ? "ON" : "OFF")"
                    vibrationButton.color = Settings.shared.isVibrationOn ? .systemGreen : .systemRed
                }
            }
            else if node.name == "notificationButton" {
             //   AudioManager.shared.playSoundEffect(name: "clickButton")
                VibrationManager.shared.vibrate()
                
                let notificationScene = NotificationScene(size: size)
                notificationScene.scaleMode = scaleMode
                view?.presentScene(notificationScene, transition: SKTransition.push(with: .left, duration: 0.3))
            }
            else if node.name == "backButton" {
              //  AudioManager.shared.playSoundEffect(name: "clickButton")
                VibrationManager.shared.vibrate()
                
                if backToMenu {
                    let menuScene = MenuScene(size: size)
                    menuScene.scaleMode = scaleMode
                    view?.presentScene(menuScene, transition: SKTransition.push(with: .right, duration: 0.3))
                } else {
                    let gameScene = GameScene(size: size)
                    gameScene.scaleMode = scaleMode
                    view?.presentScene(gameScene, transition: SKTransition.push(with: .right, duration: 0.3))
                }
            }
        }
    }
}
