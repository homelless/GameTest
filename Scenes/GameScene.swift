import SpriteKit

final class GameScene: SKScene {
    
    // MARK: - Constants
    private enum Constants {
        static let cardSize = CGSize(width: 77, height: 77)
        static let spacing: CGFloat = 15
        static let fieldMargin = UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20)
        static let rows = 4
        static let cols = 4
        static let cardTypes = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"]
        static let initialCardShowDuration: TimeInterval = 2.0
        static let cardFlipDelay: TimeInterval = 0.1
        static let matchCheckDelay: TimeInterval = 0.5
        static let mismatchDelay: TimeInterval = 1.0
        static let fadeDuration: TimeInterval = 0.5
        static let pushTransitionDuration: TimeInterval = 0.3
        static let doorTransitionDuration: TimeInterval = 0.5
        
        enum NodeNames {
            static let settingsButton = "settingsButton"
            static let backButton = "back"
            static let reloadButton = "reloadButton"
            static let pauseButton = "pause"
            static let continueButton = "continueButton"
        }
        
        enum ZPositions {
            static let background: CGFloat = -1
            static let cards: CGFloat = 1
            static let uiElements: CGFloat = 2
            static let buttons: CGFloat = 3
            static let pauseOverlay: CGFloat = 10
            static let pauseUI: CGFloat = 11
        }
    }
    
    // MARK: - Properties
    private var cards: [Card] = []
    private var selectedCards: [Card] = []
    private var movesCount = 0
    private var startTime: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var isGamePaused = false
    private var pauseTimeStamp: TimeInterval = 0
    
    // MARK: - UI Nodes
    private lazy var background: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "backgroundGame")
        node.position = CGPoint(x: size.width/2, y: size.height/2)
        node.zPosition = Constants.ZPositions.background
        node.size = self.size
        return node
    }()
    
    private lazy var backButton: SKSpriteNode = {
        createButtonNode(imageNamed: "back", name: Constants.NodeNames.backButton,
                         position: CGPoint(x: size.width/6.2, y: size.height/7),
                         size: CGSize(width: 43, height: 43))
    }()
    
    private lazy var pauseButton: SKSpriteNode = {
        createButtonNode(imageNamed: "pause", name: Constants.NodeNames.pauseButton,
                         position: CGPoint(x: size.width/2, y: size.height/7),
                         size: CGSize(width: 43, height: 43))
    }()
    
    private lazy var reloadButton: SKSpriteNode = {
        createButtonNode(imageNamed: "reload", name: Constants.NodeNames.reloadButton,
                         position: CGPoint(x: size.width/1.2, y: size.height/7),
                         size: CGSize(width: 43, height: 43))
    }()
    
    private lazy var settingsButton: SKSpriteNode = {
        createButtonNode(imageNamed: "settings", name: Constants.NodeNames.settingsButton,
                         position: CGPoint(x: size.width/10, y: size.height/1.2),
                         size: CGSize(width: 43, height: 43))
    }()
    
    private lazy var labelMovesTimer: SKSpriteNode = {
        let node = SKSpriteNode(imageNamed: "groupMoves&timer")
        node.position = CGPoint(x: size.width/2, y: size.height/1.3)
        node.size = CGSize(width: 380, height: 42)
        node.zPosition = Constants.ZPositions.uiElements
        return node
    }()
    
    private lazy var timerLabel: SKLabelNode = {
        createLabelNode(text: "Time: 0", position: CGPoint(x: size.width/1.3, y: size.height/1.313))
    }()
    
    private lazy var movesLabel: SKLabelNode = {
        createLabelNode(text: "Moves: 0", position: CGPoint(x: size.width/5.5, y: size.height/1.313))
    }()
    
    private lazy var pauseOverlay: SKSpriteNode = {
        let node = SKSpriteNode(color: .black.withAlphaComponent(0.7), size: size)
        node.position = CGPoint(x: size.width/2, y: size.height/2)
        node.zPosition = Constants.ZPositions.pauseOverlay
        node.isHidden = true
        return node
    }()
    
    private lazy var continueButton: SKSpriteNode = {
        let button = SKSpriteNode(imageNamed: "play")
        button.position = CGPoint(x: 0, y: -50)
        button.zPosition = Constants.ZPositions.pauseUI
        button.name = Constants.NodeNames.continueButton
        return button
    }()
    
    // MARK: - Lifecycle
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        setupGame()
    }
    
    // обновление игрового состояния
    override func update(_ currentTime: TimeInterval) {
        guard !isGamePaused else { return }
        
        elapsedTime = currentTime - startTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timerLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    // MARK: - Setup Methods
    private func setupGame() {
        startTime = CACurrentMediaTime()
        setupUI()
        setupCards()
        setupPauseUI()
    }
    
    private func setupUI() {
        addChild(background)
        addChild(backButton)
        addChild(pauseButton)
        addChild(reloadButton)
        addChild(settingsButton)
        addChild(labelMovesTimer)
        addChild(timerLabel)
        addChild(movesLabel)
    }
    
    private func setupPauseUI() {
        let pauseLabel = SKLabelNode(text: "PAUSED")
        pauseLabel.fontName = "Avenir-Black"
        pauseLabel.fontSize = 48
        pauseLabel.fontColor = .white
        pauseLabel.position = CGPoint(x: 0, y: 50)
        pauseLabel.zPosition = Constants.ZPositions.pauseUI
        
        pauseOverlay.addChild(pauseLabel)
        pauseOverlay.addChild(continueButton)
        addChild(pauseOverlay)
    }
    
    // MARK: - Node Factory Methods
    private func createButtonNode(imageNamed: String, name: String, position: CGPoint, size: CGSize) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: imageNamed)
        node.name = name
        node.position = position
        node.size = size
        node.zPosition = Constants.ZPositions.buttons
        return node
    }
    
    private func createLabelNode(text: String, position: CGPoint) -> SKLabelNode {
        let label = SKLabelNode(text: text)
        label.fontName = "Avenir-Bold"
        label.fontSize = 20
        label.fontColor = .white
        label.position = position
        label.zPosition = Constants.ZPositions.uiElements
        return label
    }
    
    // MARK: - Card Management
    // настройка карточек (создание и перешивание)
    private func setupCards() {
        var cardPairs = Constants.cardTypes + Constants.cardTypes
        cardPairs.shuffle()
        
        // размеры игрового поля
        let fieldWidth = size.width - Constants.fieldMargin.left - Constants.fieldMargin.right
        let fieldHeight = size.height - Constants.fieldMargin.top - Constants.fieldMargin.bottom
        
        // проверка ращмещения карточек
        let requiredWidth = CGFloat(Constants.cols) * Constants.cardSize.width +
        CGFloat(Constants.cols - 1) * Constants.spacing
        let requiredHeight = CGFloat(Constants.rows) * Constants.cardSize.height +
        CGFloat(Constants.rows - 1) * Constants.spacing
        
        guard requiredWidth <= fieldWidth && requiredHeight <= fieldHeight else {
            return
        }
        
        // начальные координаты
        let startX = Constants.fieldMargin.left + (fieldWidth - requiredWidth) / 2
        let startY = Constants.fieldMargin.bottom + (fieldHeight - requiredHeight) / 2
        
        // создаем и размешиваем карточки
        for row in 0..<Constants.rows {
            for col in 0..<Constants.cols {
                let index = row * Constants.cols + col
                let cardType = cardPairs[index]
                
                let card = Card(type: cardType)
                card.position = CGPoint(
                    x: startX + CGFloat(col) * (Constants.cardSize.width + Constants.spacing) + Constants.cardSize.width/2,
                    y: startY + CGFloat(row) * (Constants.cardSize.height + Constants.spacing) + Constants.cardSize.height/2
                )
                
                card.size = Constants.cardSize
                card.name = "card\(row)_\(col)"
                card.zPosition = Constants.ZPositions.cards
                
                addChild(card)
                cards.append(card)
                
                // анимация первоначального показывания карточек
                let flipSequence = SKAction.sequence([
                    SKAction.wait(forDuration: Double(index) * Constants.cardFlipDelay),
                    SKAction.run { card.flipToFront() },
                    SKAction.wait(forDuration: Constants.initialCardShowDuration),
                    SKAction.run { card.flipToBack() }
                ])
                
                card.currentFlipSequence = flipSequence
                card.run(flipSequence)
            }
        }
    }
    
    // MARK: - Game Logic
    // проверка совпадений
    private func checkForMatch() {
        guard selectedCards.count == 2 else { return }
        
        movesCount += 1
        movesLabel.text = "Moves: \(movesCount)"
        
        if selectedCards[0].type == selectedCards[1].type {
            // совпадение
            VibrationManager.shared.vibrate(for: .success)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.matchCheckDelay) {
                self.selectedCards.removeAll()
                self.checkGameCompletion()
            }
        } else {
            // не совпадение
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.mismatchDelay) {
                self.selectedCards.forEach { $0.flipToBack() }
                self.selectedCards.removeAll()
            }
        }
    }
    
    // проверка завершения игры
    private func checkGameCompletion() {
        if cards.allSatisfy({ $0.isFlipped }) {
            showWinScreen()
            AudioManager.shared.playMusic(.win)
        }
    }
    
    // MARK: - Touch Handling
    // обработка касаний 
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in nodes(at: location) {
            handleNodeTap(node)
        }
    }
    
    private func handleNodeTap(_ node: SKNode) {
        switch node.name {
        case Constants.NodeNames.settingsButton:
            handleSettingsButtonTap()
        case Constants.NodeNames.backButton:
            handleBackButtonTap()
        case Constants.NodeNames.reloadButton:
            handleReloadButtonTap()
        case Constants.NodeNames.pauseButton:
            handlePauseButtonTap()
        case Constants.NodeNames.continueButton:
            handleContinueButtonTap()
        default:
            handleCardTap(node)
        }
    }
    
    private func handleCardTap(_ node: SKNode) {
        guard !isGamePaused,
              let card = node as? Card,
              !card.isFlipped,
              selectedCards.count < 2 else { return }
        
        AudioManager.shared.playEffect(.cardFlip)
        VibrationManager.shared.vibrate()
        
        card.flipToFront()
        selectedCards.append(card)
        
        if selectedCards.count == 2 {
            checkForMatch()
        }
    }
    
    private func handleSettingsButtonTap() {
        AudioManager.shared.playEffect(.buttonClick)
        VibrationManager.shared.vibrate()
        
        let settingsScene = SettingsScene(size: size, previousScene: self)
        pauseGame()
        settingsScene.scaleMode = .aspectFill
        view?.presentScene(settingsScene, transition: SKTransition.push(with: .left, duration: Constants.pushTransitionDuration))
    }
    
    private func handleBackButtonTap() {
        AudioManager.shared.playEffect(.buttonClick)
        VibrationManager.shared.vibrate()
        transitionToMainMenu()
        AudioManager.shared.playMusic(.menu)
    }
    
    private func handleReloadButtonTap() {
        AudioManager.shared.playEffect(.buttonClick)
        VibrationManager.shared.vibrate()
        restartGame()
    }
    
    private func handlePauseButtonTap() {
        isGamePaused ? resumeGame() : pauseGame()
        AudioManager.shared.playEffect(.buttonClick)
        VibrationManager.shared.vibrate()
    }
    
    private func handleContinueButtonTap() {
        resumeGame()
        AudioManager.shared.playEffect(.buttonClick)
        VibrationManager.shared.vibrate()
    }
    
    // MARK: - Game State Management
    private func showWinScreen() {
        let texture = view?.texture(from: self)
        let frozenScene = SKSpriteNode(texture: texture)
        frozenScene.position = CGPoint(x: size.width/2, y: size.height/2)
        frozenScene.zPosition = 0
        
        let winScene = WinScene(size: self.size)
        winScene.scaleMode = self.scaleMode
        winScene.addChild(frozenScene)
        
        view?.presentScene(winScene, transition: .fade(withDuration: Constants.fadeDuration))
        winScene.moves = movesCount
        winScene.time = elapsedTime
    }
    
    private func transitionToMainMenu() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = self.scaleMode
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseVertical(withDuration: Constants.doorTransitionDuration))
    }
    
    func restartGame() {
        cards.forEach { $0.removeFromParent() }
        cards.removeAll()
        selectedCards.removeAll()
        setupCards()
        resetGameStats()
    }
    
    private func resetGameStats() {
        movesCount = 0
        movesLabel.text = "Moves: \(movesCount)"
        startTime = CACurrentMediaTime()
        elapsedTime = 0
        timerLabel.text = "Time: 00:00"
    }
    
    // MARK: - Pause/Resume
    func pauseGame() {
        guard !isGamePaused else { return }
        
        isGamePaused = true
        pauseTimeStamp = CACurrentMediaTime()
        
        cards.forEach { card in
            card.flipAnimation = card.action(forKey: "flipAnimation")
            card.removeAllActions()
            card.isHidden = true
            card.isUserInteractionEnabled = false
        }
        
        pauseOverlay.isHidden = false
        pauseButton.texture = SKTexture(imageNamed: "play")
    }
    
    func resumeGame() {
        guard isGamePaused else { return }
        
        isGamePaused = false
        let pauseDuration = CACurrentMediaTime() - pauseTimeStamp
        startTime += pauseDuration
        
        cards.forEach { card in
            card.isHidden = false
            card.isUserInteractionEnabled = true
            
            if let flipAnimation = card.flipAnimation {
                card.run(flipAnimation, withKey: "flipAnimation")
            } else if let flipSequence = card.currentFlipSequence {
                card.run(flipSequence, withKey: "flipAnimation")
            }
        }
        
        pauseOverlay.isHidden = true
        pauseButton.texture = SKTexture(imageNamed: "pause")
    }
}



