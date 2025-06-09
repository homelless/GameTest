import AVFoundation

class AudioManager {
    static let shared = AudioManager()
    
    // Музыкальные треки для разных экранов
    enum musicTrack: String {
        case menu = "menu.mp3"
        case match = "match.wav"
        case win = "winSound.wav"
    }
    
    // Звуковые эффекты
    enum soundEffect: String {
        case buttonClick = "clickButton.wav"
        case cardFlip = "flipCard.wav"
    }
    
    private var musicPlayer: AVAudioPlayer?
    private var soundPlayers: [soundEffect: AVAudioPlayer] = [:]
    private var currentMusic: musicTrack?
    
    // Предзагрузка всех звуков доделать
    func preloadAllSounds() {
        preloadMusic()
        preloadSoundEffects()
    }
    
    private func preloadMusic() {}
    
    private func preloadSoundEffects() {
        soundEffect.allCases.forEach { effect in
            guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: nil) else {
                print("Effect file not found: \(effect.rawValue)")
                return
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                soundPlayers[effect] = player
            } catch {
                print("Error loading \(effect.rawValue):", error)
            }
        }
    }
    
    // Управление музыкой
    func playMusic(_ track: musicTrack, loop: Bool = true) {
        guard Settings.shared.isSoundOn else { return }
        
        // Если уже играет эта музыка, ничего не делаем
        if currentMusic == track { return }
        
        stopMusic()
        
        guard let url = Bundle.main.url(forResource: track.rawValue, withExtension: nil) else {
            print("Music file not found: \(track.rawValue)")
            return
        }
        
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = loop ? -1 : 0
            player.volume = 0.7 // Громкость музыки
            player.prepareToPlay()
            player.play()
            
            musicPlayer = player
            currentMusic = track
        } catch {
            print("Music playback error:", error)
        }
    }
    
    func stopMusic() {
        musicPlayer?.stop()
        musicPlayer = nil
        currentMusic = nil
    }
    
    func pauseMusic() {
        musicPlayer?.pause()
    }
    
    func resumeMusic() {
        guard Settings.shared.isSoundOn else { return }
        musicPlayer?.play()
    }
    
    // Управление звуковыми эффектами
    func playEffect(_ effect: soundEffect, volume: Float = 1.0) {
        guard Settings.shared.isSoundOn else { return }
        
        guard let player = soundPlayers[effect] else {
            print("Effect not preloaded: \(effect.rawValue)")
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            player.currentTime = 0
            player.volume = volume
            player.play()
        }
    }
    
    // Обновление состояния звука
    func updateSoundState() {
        if Settings.shared.isSoundOn {
            resumeMusic()
        } else {
            pauseMusic()
        }
    }
    
    // Плавное переключение музыки
    func transitionToMusic(_ track: musicTrack, fadeDuration: TimeInterval = 1.0) {
        guard Settings.shared.isSoundOn else { return }
        
        if currentMusic == track { return }
        
        // Плавное затухание текущей музыки
        if let player = musicPlayer {
            player.setVolume(0, fadeDuration: fadeDuration)
            DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
                player.stop()
                self.playMusic(track)
            }
        } else {
            playMusic(track)
        }
    }
}

// Расширение для перечисления всех звуковых эффектов
extension AudioManager.soundEffect: CaseIterable {
    static var allCases: [AudioManager.soundEffect] = [
        .buttonClick,
        .cardFlip
    ]
}
    
extension AudioManager.musicTrack: CaseIterable {
    static var allCases: [AudioManager.musicTrack] = [
            .menu,
            .match,
            .win
    ]
}
//    private var player: AVAudioPlayer?
//    private var soundEffectPlayers: [String: AVAudioPlayer] = [:]
//    private let soundEffects = [
//        "clickButton",
//        "flipCard",
//        "match",
//        "winSound"
//    ]
//    
//    func preloadSounds(soundFiles: [String]) {
//            for file in soundFiles {
//                guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
//                    print("Файл \(file) не найден")
//                    continue
//                }
//                
//                do {
//                    let player = try AVAudioPlayer(contentsOf: url)
//                    player.prepareToPlay()
//                    soundEffectPlayers[file] = player
//                } catch {
//                    print("Ошибка загрузки \(file):", error)
//                }
//            }
//        }
//    
//    
//    
//    
//    
//    
//    func playMusic(name: String) {
//        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
//            return
//        }
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.numberOfLoops = -1 // Бесконечный цикл
//            player?.volume = 0.5
//            player?.prepareToPlay()
//            player?.play()
//        } catch {
//            print("Ошибка воспроизведения:", error.localizedDescription)
//        }
//    }
//    
//    func playEffect(name: String) {
//        guard let url = Bundle.main.url(forResource: name, withExtension: nil) else {
//            return
//        }
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.numberOfLoops = 1
//            player?.volume = 1
//            player?.prepareToPlay()
//            player?.play()
//        } catch {
//            print("Ошибка воспроизведения:", error.localizedDescription)
//        }
//    }
//   
//    func stopMusic(name: String) {
//        player?.stop()
//        player = nil
//    }
//    
//    func updateSoundState() {
//        if Settings.shared.isSoundOn {
//            player?.play()
//        } else {
//            player?.pause()
//        }
//    }
//}

