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
    private var musicPlayers: [musicTrack: AVAudioPlayer] = [:]
    private var soundPlayers: [soundEffect: AVAudioPlayer] = [:]
    private var currentMusic: musicTrack?
    
    // Предзагрузка всех звуков доделать
    func preloadAllSounds() {
        preloadMusic()
        preloadSoundEffects()
    }
    
    private func preloadMusic() {
        musicTrack.allCases.forEach { track in
            guard let url = Bundle.main.url(forResource: track.rawValue, withExtension: nil) else {
                print("Effect file not found: \(track.rawValue)")
                return
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                musicPlayers[track] = player
            } catch {
                print("Error loading \(track.rawValue):", error)
            }
        }
    }
    
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
