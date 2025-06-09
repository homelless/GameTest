import UIKit

class NotificationManager {
    
    static let shared = NotificationManager()
    
    private init() {}
}
    
    
    
    
    
    
    
    
    
    
    
    
    
//    override func didMove(to view: SKView) {
//        backgroundColor = UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0)
//        
//        let titleLabel = SKLabelNode(text: "Notifications")
//        titleLabel.fontName = "Avenir-Bold"
//        titleLabel.fontSize = 36
//        titleLabel.fontColor = .white
//        titleLabel.position = CGPoint(x: size.width/2, y: size.height * 0.8)
//        addChild(titleLabel)
//        
//        let enableButton = SKSpriteNode(color: .systemGreen, size: CGSize(width: 300, height: 60))
//        enableButton.position = CGPoint(x: size.width/2, y: size.height * 0.6)
//        enableButton.name = "enableButton"
//        
//        let enableLabel = SKLabelNode(text: "Enable Notifications")
//        enableLabel.fontName = "Avenir-Bold"
//        enableLabel.fontSize = 24
//        enableLabel.fontColor = .white
//        enableLabel.verticalAlignmentMode = .center
//        enableButton.addChild(enableLabel)
//        
//        addChild(enableButton)
//        
//        let disableButton = SKSpriteNode(color: .systemRed, size: CGSize(width: 300, height: 60))
//        disableButton.position = CGPoint(x: size.width/2, y: size.height * 0.45)
//        disableButton.name = "disableButton"
//        
//        let disableLabel = SKLabelNode(text: "Disable Notifications")
//        disableLabel.fontName = "Avenir-Bold"
//        disableLabel.fontSize = 24
//        disableLabel.fontColor = .white
//        disableLabel.verticalAlignmentMode = .center
//        disableButton.addChild(disableLabel)
//        
//        addChild(disableButton)
//        
//        let backButton = SKSpriteNode(color: .systemGray, size: CGSize(width: 200, height: 50))
//        backButton.position = CGPoint(x: size.width/2, y: size.height * 0.2)
//        backButton.name = "backButton"
//        
//        let backLabel = SKLabelNode(text: "Back")
//        backLabel.fontName = "Avenir-Bold"
//        backLabel.fontSize = 24
//        backLabel.fontColor = .white
//        backLabel.verticalAlignmentMode = .center
//        backButton.addChild(backLabel)
//        
//        addChild(backButton)
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard let touch = touches.first else { return }
//        let location = touch.location(in: self)
//        let nodes = self.nodes(at: location)
//        
//        for node in nodes {
//            if node.name == "enableButton" || node.name == "disableButton" {
//               // AudioManager.shared.playSoundEffect(name: "clickButton")
//                VibrationManager.shared.vibrate()
//                
//                // Здесь можно добавить реальную логику для уведомлений
//                // В этом примере просто вибрация и звук
//            }
//            else if node.name == "backButton" {
//             //   AudioManager.shared.playSoundEffect(name: "clickButton")
//                VibrationManager.shared.vibrate()
//                
//                let settingsScene = SettingsScene(size: size, previousScene: self)
//                settingsScene.scaleMode = .aspectFill
//                view?.presentScene(settingsScene, transition: SKTransition.push(with: .left, duration: 0.3))
//            }
//        }
//    }
//}
