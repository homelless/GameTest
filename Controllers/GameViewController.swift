import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    // устанавливаем SKView в качестве корневого view контроллера
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    // настройка заставочного view и предварительная загрузка звуков 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        let scene = LoadingScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        skView.presentScene(scene)
        
        AudioManager.shared.preloadAllSounds()
        AudioManager.shared.playMusic(.menu)
    }
}
