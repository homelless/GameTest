//
//  LoadingScene.swift
//  GameTest
//
//  Created by MacBookAir on 21.05.25.
//
import SpriteKit

class LoadingScene: SKScene {
    
    private var backgroundNode: SKSpriteNode!
    private var loadingLabel: SKLabelNode!
    private var loadingLight: SKSpriteNode!
    private var grape: SKSpriteNode!
    private var lemon: SKSpriteNode!
    private var orange: SKSpriteNode!
    private var cherries: SKSpriteNode!
    private var starsOne: SKSpriteNode!
    private var starsTwo: SKSpriteNode!
    private var starsThree: SKSpriteNode!
        
    override func didMove(to view: SKView) {
        UIElement()
        startLoadingAnimation()
        startAnimations()
        startTransitionTimer()
    }
    
    
    private func transitionToMainMenu() {
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = self.scaleMode
        view?.presentScene(menuScene, transition: SKTransition.fade(withDuration: 1.0))
        
    }
    
    private func startLoadingAnimation() {
        // Мигание текста
        let blinkAction = SKAction.sequence([
            SKAction.fadeOut(withDuration: 1),
            SKAction.fadeIn(withDuration: 1)
        ])
        loadingLabel.run(SKAction.repeatForever(blinkAction))
    }
    
    private func startAnimations() {
        // Анимация движения огонька вверх-вниз
        let moveUp = SKAction.moveTo(y: size.height * 0.8, duration: 2.5)
        moveUp.timingMode = .easeInEaseOut
        
        let moveDown = SKAction.moveTo(y: size.height/4, duration: 2.5)
        moveDown.timingMode = .easeInEaseOut
        
        let bounceSequence = SKAction.sequence([moveUp, moveDown])
        
        loadingLight.run(SKAction.repeatForever(bounceSequence))
    }
    
    private func UIElement() {
        backgroundNode = SKSpriteNode(imageNamed: "background")
        backgroundNode.position = CGPoint(x: size.width/2, y: size.height/2)
        backgroundNode.size = self.size
        backgroundNode.zPosition = -1
        addChild(backgroundNode)
        
        
        grape = SKSpriteNode(imageNamed: "grape")
        grape.position = CGPoint(x: size.width/1.3, y: size.height/1.15)
        grape.zPosition = 2
        grape.size = CGSize(width: 70, height: 70)
        addChild(grape)
        
        lemon = SKSpriteNode(imageNamed: "lemon")
        lemon.position = CGPoint(x: size.width/8, y: size.height/3.2)
        lemon.zPosition = 2
        lemon.size = CGSize(width: 45, height: 55)
        addChild(lemon)
        
        orange = SKSpriteNode(imageNamed: "orange")
        orange.position = CGPoint(x: size.width/1.1, y: size.height/7.5)
        orange.zPosition = 2
        orange.size = CGSize(width: 70, height: 80)
        addChild(orange)
        
        cherries = SKSpriteNode(imageNamed: "cherries")
        cherries.position = CGPoint(x: size.width/1.08, y: size.height/2.3)
        cherries.zPosition = 2
        cherries.size = CGSize(width: 110, height: 120)
        addChild(cherries)
        
        starsOne = SKSpriteNode(imageNamed: "starsOne")
        starsOne.position = CGPoint(x: size.width/3.4, y: size.height/1.2)
        starsOne.zPosition = 2
        starsOne.size = CGSize(width: 220, height: 180)
        addChild(starsOne)
        
        starsTwo = SKSpriteNode(imageNamed: "starsTwo")
        starsTwo.position = CGPoint(x: size.width/1.5, y: size.height/1.8)
        starsTwo.zPosition = 2
        starsTwo.size = CGSize(width: 300, height: 222)
        addChild(starsTwo)
        
        starsThree = SKSpriteNode(imageNamed: "starsThree")
        starsThree.position = CGPoint(x: size.width/2.7, y: size.height/4.6)
        starsThree.zPosition = 2
        starsThree.size = CGSize(width: 280, height: 200)
        addChild(starsThree)
        
        
        loadingLight = SKSpriteNode(imageNamed: "light")
        loadingLight.position = CGPoint(x: size.width/2, y: size.height/4)
        loadingLight.zPosition = 10
        loadingLight.size = CGSize(width: 250, height: 300)
        addChild(loadingLight)
        
        loadingLabel = SKLabelNode(text: "Loading...")
        loadingLabel.fontName = "Avenir-Bold"
        loadingLabel.fontSize = 21
        loadingLabel.fontColor = .white
        loadingLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(loadingLabel)
        
        
    }
    
    private func startTransitionTimer() {
        
        let waitAction = SKAction.wait(forDuration: 1.0)
        let transitionAction = SKAction.run { [weak self] in
            self?.transitionToMainMenu()
        }
        
        run(SKAction.sequence([waitAction, transitionAction]))
    }
}
