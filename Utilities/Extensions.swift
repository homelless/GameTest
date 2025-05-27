import SpriteKit

extension SKScene {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        
        if let viewController = self.view?.window?.rootViewController {
            viewController.present(alertController, animated: true)
        }
    }
}
