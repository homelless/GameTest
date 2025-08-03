import SpriteKit

final class SettingsScene: SKScene {
    
    // MARK: - Constants
    private enum Constants {
        static let buttonSize = CGSize(width: 250, height: 61)
        static let transitionDuration: TimeInterval = 0.3
        static let titleFontSize: CGFloat = 36
        static let buttonFontSize: CGFloat = 24
        
        enum NodeNames {
            static let soundButton = "soundButton"
            static let vibrationButton = "vibrationButton"
            static let notificationButton = "notificationButton"
            static let backButton = "backButton"
        }
        
        enum Positions {
            static let title = CGPoint(x: 0.5, y: 0.8)
            static let sound = CGPoint(x: 0.5, y: 0.58)
            static let vibration = CGPoint(x: 0.5, y: 0.45)
            static let notification = CGPoint(x: 0.5, y: 0.33)
            static let back = CGPoint(x: 0.5, y: 0.14)
        }
        
        enum Colors {
            static let enabled = SKColor.systemGreen
            static let disabled = SKColor.systemRed
        }
    }
    
    
    // MARK: - Properties
    private var previousScene: SKScene?
    private var soundButton: SKSpriteNode!
    private var vibrationButton: SKSpriteNode!
    private var backButton: SKSpriteNode!
    private var notificationButton: SKSpriteNode!
    
    // MARK: - Initialization
    // инициализация с передачей предыдущей сцены
    init(size: CGSize, previousScene: SKScene? = nil) {
        self.previousScene = previousScene
        super.init(size: size)
        scaleMode = .aspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupScene()
    }
    
    // MARK: - Scene Setup
    private func setupScene() {
        setupBackground()
        setupTitle()
        setupButtons()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(imageNamed: "backgroundSetting")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
    }
    
    private func setupTitle() {
        let titleLabel = SKLabelNode(text: "Settings")
        titleLabel.fontName = "Avenir-Bold"
        titleLabel.fontSize = Constants.titleFontSize
        titleLabel.fontColor = .white
        titleLabel.position = CGPoint(
            x: size.width * Constants.Positions.title.x,
            y: size.height * Constants.Positions.title.y
        )
        addChild(titleLabel)
    }
    
    private func setupButtons() {
        soundButton = createToggleButton(
            text: "Sound: \(Settings.shared.isSoundOn ? "ON" : "OFF")",
            position: CGPoint(
                x: size.width * Constants.Positions.sound.x,
                y: size.height * Constants.Positions.sound.y
            ),
            name: Constants.NodeNames.soundButton,
            isOn: Settings.shared.isSoundOn
        )
        addChild(soundButton)
        
        vibrationButton = createToggleButton(
            text: "Vibration: \(Settings.shared.isVibrationOn ? "ON" : "OFF")",
            position: CGPoint(
                x: size.width * Constants.Positions.vibration.x,
                y: size.height * Constants.Positions.vibration.y
            ),
            name: Constants.NodeNames.vibrationButton,
            isOn: Settings.shared.isVibrationOn
        )
        addChild(vibrationButton)
        
        notificationButton = createToggleButton(
            text: "Notifications: \(Settings.shared.isNotificationOn ? "ON" : "OFF")",
            position: CGPoint(
                x: size.width * Constants.Positions.notification.x,
                y: size.height * Constants.Positions.notification.y
            ),
            name: Constants.NodeNames.notificationButton,
            isOn: Settings.shared.isNotificationOn
        )
        addChild(notificationButton)
        
        backButton = createButton(
            text: "Back",
            position: CGPoint(
                x: size.width * Constants.Positions.back.x,
                y: size.height * Constants.Positions.back.y
            ),
            name: Constants.NodeNames.backButton
        )
        addChild(backButton)
    }
    
    // MARK: - Button Factory Methods
    // создание обычной кнопки
    private func createButton(text: String, position: CGPoint, name: String) -> SKSpriteNode {
        let button = SKSpriteNode(imageNamed: "emptyButton")
        button.position = position
        button.size = Constants.buttonSize
        button.name = name
        
    // добавление текста на кнопку
        let label = SKLabelNode(text: text)
        label.fontName = "Avenir-Bold"
        label.fontSize = Constants.buttonFontSize
        label.fontColor = .white
        label.verticalAlignmentMode = .center
        button.addChild(label)
        
        return button
    }
    // переключение кнопки с изменением цвета
    private func createToggleButton(text: String, position: CGPoint, name: String, isOn: Bool) -> SKSpriteNode {
        let button = createButton(text: text, position: position, name: name)
        button.color = isOn ? Constants.Colors.enabled : Constants.Colors.disabled
        button.colorBlendFactor = 1.0
        return button
    }
    
    // MARK: - Touch Handling
    // обработка касаний 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            handleButtonTap(node)
        }
    }
    
    private func handleButtonTap(_ node: SKNode) {
        VibrationManager.shared.vibrate()
       
        
        switch node.name {
        case Constants.NodeNames.soundButton:
            toggleSound()
        case Constants.NodeNames.vibrationButton:
            AudioManager.shared.playEffect(.buttonClick)
            toggleVibration()
        case Constants.NodeNames.notificationButton:
            AudioManager.shared.playEffect(.buttonClick)
            toggleNotifications()
        case Constants.NodeNames.backButton:
            AudioManager.shared.playEffect(.buttonClick)
            handleBackButton()
        default:
            break
        }
    }
    
    // MARK: - Button Actions
    private func toggleSound() {
        Settings.shared.isSoundOn.toggle()
        updateButtonAppearance(
            button: soundButton,
            isOn: Settings.shared.isSoundOn,
            text: "Sound: \(Settings.shared.isSoundOn ? "ON" : "OFF")"
        )
    }
    
    private func toggleVibration() {
        Settings.shared.isVibrationOn.toggle()
        updateButtonAppearance(
            button: vibrationButton,
            isOn: Settings.shared.isVibrationOn,
            text: "Vibration: \(Settings.shared.isVibrationOn ? "ON" : "OFF")"
        )
    }
    
    private func toggleNotifications() {
        Settings.shared.isNotificationOn.toggle()
        updateButtonAppearance(
            button: notificationButton,
            isOn: Settings.shared.isNotificationOn,
            text: "Notifications: \(Settings.shared.isNotificationOn ? "ON" : "OFF")"
        )
    }
    
    private func handleBackButton() {
        if let previousScene = previousScene {
            let transition: SKTransition
            
            if previousScene is GameScene {
                let newGameScene = GameScene(size: size)
                transition = SKTransition.push(with: .right, duration: Constants.transitionDuration)
                view?.presentScene(newGameScene, transition: transition)
                AudioManager.shared.transitionToMusic(.match)
            } else {
                let newMenuScene = MenuScene(size: size)
                transition = SKTransition.push(with: .right, duration: Constants.transitionDuration)
                view?.presentScene(newMenuScene, transition: transition)
                AudioManager.shared.transitionToMusic(.menu)
            }
        }
    }
    
    // MARK: - Helper Methods
    private func updateButtonAppearance(button: SKSpriteNode, isOn: Bool, text: String) {
        button.color = isOn ? Constants.Colors.enabled : Constants.Colors.disabled
        
        if let label = button.children.first as? SKLabelNode {
            label.text = text
        }
    }
}

