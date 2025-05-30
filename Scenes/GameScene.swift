import SpriteKit

class GameScene: SKScene {
    
    private let cardSize = CGSize(width: 77, height: 77)
    private let spacing: CGFloat = 15
    private let fieldMargin = UIEdgeInsets(top: 100, left: 20, bottom: 20, right: 20)
    private var backButton: SKSpriteNode!
    private var pauseButton: SKSpriteNode!
    private var reloadButton: SKSpriteNode!
    
    
    private var isGamePaused = false
    private var pauseOverlay: SKSpriteNode!
    private var continueButton: SKSpriteNode!
    private var pauseTimeStamp: TimeInterval = 0
    
    
    private var cards: [Card] = []
    private var selectedCards: [Card] = []
    private var movesCount = 0
    private var startTime: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var timerLabel: SKLabelNode!
    private var movesLabel: SKLabelNode!
    private var settingsButton: SKSpriteNode!
    private var background: SKSpriteNode!
    private var labelMovesTimer : SKSpriteNode!
    private let cardTypes = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"]
    private let rows = 4
    private let cols = 4
    
    override func didMove(to view: SKView) {
        startTime = CACurrentMediaTime()
        UIElements()
        setupCards()
        createPauseUI()
    }
    
    private func UIElements() {
        
        backButton = SKSpriteNode(imageNamed: "back")
        backButton.position = CGPoint(x: size.width/6.2, y: size.height/7)
        backButton.size = CGSize(width: 43, height: 43)
        backButton.zPosition = 3
        backButton.name = "back"
        addChild(backButton)
        
        pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.position = CGPoint(x: size.width/2, y: size.height/7)
        pauseButton.size = CGSize(width: 43, height: 43)
        pauseButton.zPosition = 3
        pauseButton.name = "pause"
        addChild(pauseButton)
        
        
        reloadButton = SKSpriteNode(imageNamed: "reload")
        reloadButton.position = CGPoint(x: size.width/1.2, y: size.height/7)
        reloadButton.size = CGSize(width: 43, height: 43)
        reloadButton.zPosition = 3
        reloadButton.name = "reloadButton"
        addChild(reloadButton)
        
        background = SKSpriteNode(imageNamed: "backgroundGame")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        background.size = self.size
        addChild(background)
        
        
        // Таймер
        timerLabel = SKLabelNode(text: "Time: 0")
        timerLabel.fontName = "Avenir-Bold"
        timerLabel.fontSize = 20
        timerLabel.fontColor = .white
        timerLabel.zPosition = 3
        timerLabel.position = CGPoint(x: size.width/1.3, y: size.height/1.313)
        addChild(timerLabel)
        
        // Счетчик ходов
        movesLabel = SKLabelNode(text: "Movies: 0")
        movesLabel.fontName = "Avenir-Bold"
        movesLabel.fontSize = 20
        movesLabel.fontColor = .white
        movesLabel.zPosition = 3
        movesLabel.position = CGPoint(x: size.width/5.5, y: size.height/1.313)
        addChild(movesLabel)
        
        // Кнопка настроек
        settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.position = CGPoint(x: size.width/10, y: size.height/1.2)
        settingsButton.name = "settingsButton"
        settingsButton.size = CGSize(width: 43, height: 43)
        addChild(settingsButton)
        
        // Кнопка с количеством ходов и таймером
        labelMovesTimer = SKSpriteNode(imageNamed: "groupMoves&timer")
        labelMovesTimer.position = CGPoint(x: size.width/2, y: size.height/1.3)
        labelMovesTimer.size = CGSize(width: 380, height: 42)
        labelMovesTimer.zPosition = 2
        addChild(labelMovesTimer)
        
        
    }
    
    private func setupCards() {
        // Создаем пары карточек
        var cardPairs = cardTypes + cardTypes
        cardPairs.shuffle()
        
        // Расчет начальрой позиции
        let fieldWidht = size.width - fieldMargin.left - fieldMargin.right
        let fieldHeight = size.height - fieldMargin.top - fieldMargin.bottom
        
        //Проверяем, помещаются ли карты с текущими настройками
        let requiredWigth = CGFloat(cols) * cardSize.width + CGFloat(cols - 1) * spacing
        let requiredHeght = CGFloat(rows) * cardSize.height + CGFloat(rows - 1) * spacing
        
        guard requiredWigth <= fieldWidht && requiredHeght <= fieldHeight else {
            print("Ошибка: Карты не помещаются на поле с текущими настройками")
            return
        }
        
        // Центрируем карты на доступном поле
        let startX = fieldMargin.left + (fieldWidht - requiredWigth) / 2
        let startY = fieldMargin.bottom + (fieldHeight - requiredHeght) / 2
        
        for row in 0..<rows {
            for col in 0..<cols {
                let index = row * cols + col
                let cardType = cardPairs[index]
                
                let card = Card(type: cardType)
                card.position = CGPoint(x: startX + CGFloat(col) * (cardSize.width + spacing) + cardSize.width/2,
                                        y: startY + CGFloat(row) * (cardSize.height + spacing) + cardSize.height/2)
                
                card.size = cardSize
                card.name = "card\(row)_\(col)"
                
                addChild(card)
                cards.append(card)
                
                // Показываем карточки на короткое время в начале игры
                let flipSequence = SKAction.sequence([
                    SKAction.wait(forDuration: Double(index) * 0.1),
                    SKAction.run { card.flipToFront() },
                    SKAction.wait(forDuration: 2.0),
                    SKAction.run { card.flipToBack() }
                ])
                card.currentFlipSequence = flipSequence
                card.run(flipSequence)
                
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        elapsedTime = currentTime - startTime
        let minutes = Int(elapsedTime) / 60
        let seconds = Int(elapsedTime) % 60
        timerLabel.text = String(format: "Time: %02d:%02d", minutes, seconds)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let nodes = self.nodes(at: location)
        
        for node in nodes {
            if node.name == "settingsButton" {
                AudioManager.shared.playEffect(.buttonClick)
                VibrationManager.shared.vibrate()
                
                let settingsScene = SettingsScene(size: size)
                settingsScene.scaleMode = scaleMode
                settingsScene.backToMenu = false
                pauseGame()
                view?.presentScene(settingsScene, transition: SKTransition.push(with: .left, duration: 0.3))
                return
                // новые кнопки
            } else if node.name == "back" {
                transitionToMainMenu()
            }else if node.name == "reloadButton"{
                restartGame()
            }else if node.name == "pause"{
                isGamePaused ? resumeGame() : pauseGame()
                AudioManager.shared.playEffect(.buttonClick)
                VibrationManager.shared.vibrate()
                return
            } else if node.name == "continueButton" {
                resumeGame()
                AudioManager.shared.playEffect(.buttonClick)
                VibrationManager.shared.vibrate()
                return
            }
            
            // Блокируем взаимодействие с карточками при паузе
            guard !isGamePaused else { continue }
            
            guard let card = node as? Card, !card.isFlipped, selectedCards.count < 2 else { continue }
            
            AudioManager.shared.playEffect(.cardFlip)
            VibrationManager.shared.vibrate()
            
            card.flipToFront()
            selectedCards.append(card)
            
            if selectedCards.count == 2 {
                movesCount += 1
                movesLabel.text = "Moves: \(movesCount)"
                
                if selectedCards[0].type == selectedCards[1].type {
                    // Совпадение
                    VibrationManager.shared.vibrate(for: .success)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.selectedCards.removeAll()
                        
                        // Проверка на завершение игры
                        if self.cards.allSatisfy({ $0.isFlipped }) {
                            self.gameWin()
                        }
                    }
                } else {
                    // Не совпали
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.selectedCards.forEach { $0.flipToBack() }
                        self.selectedCards.removeAll()
                    }
                }
            }
        }
    }
    
    private func gameWin() {
        AudioManager.shared.playMusic(.win)
        VibrationManager.shared.vibrate(for: .success)
        
        let winScene = WinScene(size: size)
        winScene.scaleMode = scaleMode
        winScene.moves = movesCount
        winScene.time = elapsedTime
        view?.presentScene(winScene, transition: SKTransition.moveIn(with: .down, duration: 0.5))
    }
    
    private func transitionToMainMenu() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = self.scaleMode
        view?.presentScene(menuScene, transition: SKTransition.doorsCloseVertical(withDuration: 0.5))
    }
    
    private func restartGame() {
        
        cards.forEach { $0.removeFromParent() }
        cards.removeAll()
        selectedCards.removeAll()
        setupCards()
        movesCount = 0
        movesLabel.text = "Moves: \(movesCount)"
        startTime = CACurrentMediaTime()
        elapsedTime = 0
        timerLabel.text = "Time: 00:00"
    }
    
    private func createPauseUI(){
        // Затемнение экрана
        pauseOverlay = SKSpriteNode(color: .black.withAlphaComponent(0.7), size: size)
        pauseOverlay.position = CGPoint(x: size.width/2, y: size.height/2)
        pauseOverlay.zPosition = 10
        pauseOverlay.isHidden = true
        addChild(pauseOverlay)
        
        // Текст "PAUSED"
        let pauseLabel = SKLabelNode(text: "PAUSED")
        pauseLabel.fontName = "Avenir-Black"
        pauseLabel.fontSize = 48
        pauseLabel.fontColor = .white
        pauseLabel.position = CGPoint(x: 0, y: 50)
        pauseLabel.zPosition = 11
        pauseOverlay.addChild(pauseLabel)
        
        // Кнопка продолжения
        continueButton = SKSpriteNode(imageNamed: "play") // Используйте свою текстуру
        continueButton.position = CGPoint(x: 0, y: -50)
        continueButton.zPosition = 11
        continueButton.name = "continueButton"
        pauseOverlay.addChild(continueButton)
    }
    
    private func pauseGame() {
        
        guard !isGamePaused else { return }
        
        isGamePaused = true
        pauseTimeStamp = CACurrentMediaTime()
        
        
        // Сохраняем текущие анимации и останавливаем их
        cards.forEach { card in
            card.flipAnimation = card.action(forKey: "flipAnimation")
            card.removeAllActions()
        }
        // 1. Скрываем все карточки
        cards.forEach { $0.isHidden = true }
        
        // 2. Блокируем взаимодействие с карточками
        cards.forEach { $0.isUserInteractionEnabled = false }
        
        // 3. Показываем оверлей паузы
        pauseOverlay.isHidden = false
        
        // 4. Обновляем кнопку паузы
        pauseButton.texture = SKTexture(imageNamed: "play") // Меняем на "продолжить"
        
        
    }
    
    private func resumeGame() {
        guard isGamePaused else { return }
        
        isGamePaused = false
        
        // 1. Корректируем таймер с учетом паузы
        let pauseDuration = CACurrentMediaTime() - pauseTimeStamp
        startTime += pauseDuration
        
        // 2. Показываем карточки
        cards.forEach { $0.isHidden = false }
        
        // 3. Разблокируем карточки
        cards.forEach { $0.isUserInteractionEnabled = true }
        
        // 4. Скрываем оверлей паузы
        pauseOverlay.isHidden = true
        
        cards.forEach { card in
            if let flipAnimation = card.flipAnimation {
                card.run(flipAnimation, withKey: "flipAnimation")
            } else if let flipSequence = card.currentFlipSequence {
                card.run(flipSequence, withKey: "flipAnimation")
            }
        }
        
        // 5. Возвращаем иконку паузы
        pauseButton.texture = SKTexture(imageNamed: "pause")
    }
    
}

