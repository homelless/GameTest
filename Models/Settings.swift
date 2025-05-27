
import Foundation

class Settings {
    static let shared = Settings()
    
    var isSoundOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")
            AudioManager.shared.updateSoundState()
        }
    }
    
    var isVibrationOn: Bool {
        didSet {
            UserDefaults.standard.set(isVibrationOn, forKey: "isVibrationOn")
        }
    }
    
    private init() {
        isSoundOn = UserDefaults.standard.object(forKey: "isSoundOn") as? Bool ?? true
        isVibrationOn = UserDefaults.standard.object(forKey: "isVibrationOn") as? Bool ?? true
    }
}
