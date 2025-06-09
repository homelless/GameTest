
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
    
    var isNotificationOn: Bool {
        didSet {
            UserDefaults.standard.set(isNotificationOn, forKey: "isNotificationOn")
        }
    }
    
    private init() {
        isSoundOn = UserDefaults.standard.object(forKey: "isSoundOn") as? Bool ?? true
        isVibrationOn = UserDefaults.standard.object(forKey: "isVibrationOn") as? Bool ?? true
        isNotificationOn = UserDefaults.standard.object(forKey: "isNotificationOn") as? Bool ?? true
    }
}
