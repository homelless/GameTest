import UIKit

class VibrationManager {
    static let shared = VibrationManager()
    
    private init() {}
    
    func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType = .success) {
        guard Settings.shared.isVibrationOn else { return }
        
        DispatchQueue.main.async {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(type)
        }
    }
    
    func vibrate() {
        guard Settings.shared.isVibrationOn else { return }
        
        DispatchQueue.main.async {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}
