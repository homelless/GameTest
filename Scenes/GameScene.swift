import SpriteKit

class GameScene: SKScene {
    private var cards: [Card] = []
    private var selectedCards: [Card] = []
    private var movesCount = 0
    private var startTime: TimeInterval = 0
    private var elapsedTime: TimeInterval = 0
    private var timerLabel: SKLabelNode!
    private var movesLabel: SKLabelNode!
    private var settingsButton: SKSpriteNode!
    
    private let cardTypes = ["card1", "card2", "card3", "card4", "card5", "card6", "card7", "card8"]
    private let rows = 4
    private let cols = 4
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.2, alpha: 1.0)
        startTime = CACurrentMediaTime()
        
        setupUI()
        setupCards()
    }
    
    private func setupUI() {
        // Таймер
        timerLabel = SKLabelNode(text: "Time: 0")
        timerLabel.fontName = "Avenir-Bold"
        timerLabel.fontSize = 20
        timerLabel.fontColor = .white
        timerLabel.position = CGPoint(x: size.width * 0.25, y: size.height - 50)
        addChild(timerLabel)
        
        // Счетчик ходов
        movesLabel = SKLabelNode(text: "Moves: 0")
        movesLabel.fontName = "Avenir-Bold"
        movesLabel.fontSize = 20
        movesLabel.fontColor = .white
        movesLabel.position = CGPoint(x: size.width * 0.75, y: size.height - 50)
        addChild(movesLabel)
        
        // Кнопка настроек
        settingsButton = SKSpriteNode(imageNamed: "settings")
        settingsButton.position = CGPoint(x: size.width - 40, y: size.height - 40)
        settingsButton.name = "settingsButton"
        settingsButton.setScale(0.5)
        addChild(settingsButton)
    }
    
    private func setupCards() {
        // Создаем пары карточек
        var cardPairs = cardTypes + cardTypes
        cardPairs.shuffle()
        
        let cardWidth: CGFloat = size.width * 0.2
        let cardHeight: CGFloat = size.height * 0.2
        let horizontalSpacing: CGFloat = (size.width - (CGFloat(cols) * cardWidth)) / (CGFloat(cols) + 1)
        let verticalSpacing: CGFloat = (size.height - 100 - (CGFloat(rows) * cardHeight)) / (CGFloat(rows) + 1)
        
        for row in 0..<rows {
            for col in 0..<cols {
                let index = row * cols + col
                let cardType = cardPairs[index]
                
                let card = Card(type: cardType)
                card.position = CGPoint(
                    x: horizontalSpacing + CGFloat(col) * (cardWidth + horizontalSpacing) + cardWidth/2,
                    y: 50 + verticalSpacing + CGFloat(row) * (cardHeight + verticalSpacing) + cardHeight/2
                )
                card.size = CGSize(width: cardWidth, height: cardHeight)
                card.name = "card_\(row)_\(col)"
                
                addChild(card)
                cards.append(card)
                
                // Показываем карточки на короткое время в начале игры
                let flipSequence = SKAction.sequence([
                    SKAction.wait(forDuration: Double(index) * 0.1),
                    SKAction.run { card.flipToFront() },
                    SKAction.wait(forDuration: 2.0),
                    SKAction.run { card.flipToBack() }
                ])
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
                view?.presentScene(settingsScene, transition: SKTransition.push(with: .left, duration: 0.3))
                return
            }
            
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
                        self.selectedCards.forEach { $0.removeFromParent() }
                        self.selectedCards.removeAll()
                        
                        // Проверка на завершение игры
                        if self.cards.allSatisfy({ $0.parent == nil }) {
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
        view?.presentScene(winScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}
