import UIKit
import SpriteKit
import SafariServices

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
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
