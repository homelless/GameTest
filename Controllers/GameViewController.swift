import UIKit
import SpriteKit
import SafariServices


class GameViewController: UIViewController {
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView

        //let scene = GameScene(size: skView.bounds.size)
        let scene = LoadingScene(size: skView.bounds.size)
        scene.scaleMode = .aspectFill
        
        skView.presentScene(scene)
        AudioManager.shared.preloadAllSounds()
//        AudioManager.shared.playMusic(.menu)
    }
}
