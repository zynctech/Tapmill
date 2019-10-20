//
//  GameScene.swift
//  Tapmill
//
//  Created by Zoom Nattapol on 25/5/19.
//  Copyright © 2019 ZyncTech. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

var seconds   = 0
var lifePoint = 0
var gameScore = 0
var activeTimer : String = ""
var deviceTime  : Int    = 0

extension Float {
    func rounded(digits: Int) -> Float {
        let multiplier = pow(10.0, Float(digits))
        return (self * multiplier).rounded() / multiplier
    }
}

class GameScene: SKScene {
    
    let impact = UIImpactFeedbackGenerator()
    
    var treadmillEngineSound : AVAudioPlayer!
    
    let buttonPressedSound   = SKAction.playSoundFileNamed("buttonPressSound.wav", waitForCompletion: false)
    let errorSound           = SKAction.playSoundFileNamed("errorSound.wav", waitForCompletion: false)
    let explosionSound       = SKAction.playSoundFileNamed("explosionSound.wav", waitForCompletion: false)
    let footstepSound        = SKAction.playSoundFileNamed("footstepSound.wav", waitForCompletion: false)
    let gameOverSound        = SKAction.playSoundFileNamed("gameOverSound.wav", waitForCompletion: false)
    
    let startButton      = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let backButton       = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let runningLabel     = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let stepLabel        = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let gameScoreLabel   = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let activeTimerLabel = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    
    let treadmill        = SKSpriteNode(imageNamed: "treadmill")
    let sunriseView      = SKSpriteNode(imageNamed: "viewSunrise")
    let daytimeView      = SKSpriteNode(imageNamed: "viewDaytime")
    let sunsetView       = SKSpriteNode(imageNamed: "viewSunset")
    let nighttimeView    = SKSpriteNode(imageNamed: "viewNighttime")
    let mirror           = SKSpriteNode(imageNamed: "mirror")
    let explosion        = SKSpriteNode(imageNamed: "explosion")
    
    let scoreButton      = SKSpriteNode()
    
    enum gameState {
        case beforeGame
        case duringGame
        case afterGame
    }
    
    var currentGameState = gameState.beforeGame
    
    var randomColor = Int()
    var tabSpeed    = Float()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.init(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
        deviceTime = Calendar.current.component(.hour, from: Date())
        currentGameState = gameState.beforeGame
        
        seconds   = 0
        lifePoint = 1
        gameScore = 0
        
        let treadmillSoundFilePath = Bundle.main.path(forResource: "treadmillEngineSound", ofType: "mp3")!
        let treadmillAudioURL = URL(fileURLWithPath: treadmillSoundFilePath)
        do { treadmillEngineSound = try AVAudioPlayer(contentsOf: treadmillAudioURL) }
        catch { return print("Cannot find the audio file!") }
        self.treadmillEngineSound.numberOfLoops = -1
        self.treadmillEngineSound.volume = 1
        
        treadmill.name = "Treadmill"
        treadmill.size = self.size
        treadmill.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.25)
        treadmill.zPosition = 9
        treadmill.setScale(1.5)
        self.addChild(treadmill)
        
        mirror.size = CGSize(width: self.size.width, height: self.size.width * 0.67)
        mirror.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        mirror.zPosition = 8
        mirror.setScale(1.5)
        self.addChild(mirror)
        
        sunriseView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        sunriseView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        sunriseView.zPosition = 7
        sunriseView.setScale(1.5)
        
        daytimeView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        daytimeView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        daytimeView.zPosition = 7
        daytimeView.setScale(1.5)
        
        sunsetView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        sunsetView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        sunsetView.zPosition = 7
        sunsetView.setScale(1.5)
        
        nighttimeView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        nighttimeView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.75)
        nighttimeView.zPosition = 7
        nighttimeView.setScale(1.5)
        
        if deviceTime >= 0 && deviceTime < 5 { self.addChild(self.nighttimeView) }
        else if deviceTime >= 5 && deviceTime < 6 { self.addChild(self.sunriseView) }
        else if deviceTime >= 6 && deviceTime < 17 { self.addChild(self.daytimeView) }
        else if deviceTime >= 17 && deviceTime < 19 { self.addChild(self.sunsetView) }
        else if deviceTime >= 19 && deviceTime <= 23 { self.addChild(self.nighttimeView) }
        
        scoreButton.name = "ScoreTab"
        scoreButton.color = SKColor.white
        scoreButton.alpha = 0.25
        scoreButton.size = CGSize(width: self.size.width, height: self.size.height * 0.055)
        scoreButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.085)
        scoreButton.zPosition = 8
        
        let fadeInButton = SKAction.fadeIn(withDuration: 0.75)
        let fadeOutButton = SKAction.fadeOut(withDuration: 0.75)
        let buttonSequence = SKAction.sequence([fadeInButton, fadeOutButton])
        let blinkButton = SKAction.repeatForever(buttonSequence)
        
        startButton.text = "TAP TO START"
        startButton.fontSize = self.size.height * 0.025
        startButton.fontColor = SKColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 1)
        startButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.748)
        startButton.zPosition = 10
        startButton.isHidden = true
        startButton.run(blinkButton)
        
        backButton.text = "<< BACK"
        backButton.fontSize = self.size.height * 0.018
        backButton.fontColor = SKColor.darkGray
        backButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        backButton.position = CGPoint(x: self.size.width * 0.67, y: self.size.height * 0.717)
        backButton.zPosition = 10
        backButton.isHidden = true
        
        let waitToChangeLabel = SKAction.wait(forDuration: 0.5)
        let label1  = SKAction.run { self.runningLabel.text = ">>....................." }
        let label2  = SKAction.run { self.runningLabel.text = ".>>...................." }
        let label3  = SKAction.run { self.runningLabel.text = "..>>..................." }
        let label4  = SKAction.run { self.runningLabel.text = "...>>.................." }
        let label5  = SKAction.run { self.runningLabel.text = "....>>................." }
        let label6  = SKAction.run { self.runningLabel.text = ".....>>................" }
        let label7  = SKAction.run { self.runningLabel.text = "......>>..............." }
        let label8  = SKAction.run { self.runningLabel.text = ".......>>.............." }
        let label9  = SKAction.run { self.runningLabel.text = "........>>............." }
        let label10 = SKAction.run { self.runningLabel.text = ".........>>............" }
        let label11 = SKAction.run { self.runningLabel.text = "..........>>..........." }
        let label12 = SKAction.run { self.runningLabel.text = "...........>>.........." }
        let label13 = SKAction.run { self.runningLabel.text = "............>>........." }
        let label14 = SKAction.run { self.runningLabel.text = ".............>>........" }
        let label15 = SKAction.run { self.runningLabel.text = "..............>>......." }
        let label16 = SKAction.run { self.runningLabel.text = "...............>>......" }
        let label17 = SKAction.run { self.runningLabel.text = "................>>....." }
        let label18 = SKAction.run { self.runningLabel.text = ".................>>...." }
        let label19 = SKAction.run { self.runningLabel.text = "..................>>..." }
        let label20 = SKAction.run { self.runningLabel.text = "...................>>.." }
        let label21 = SKAction.run { self.runningLabel.text = "....................>>." }
        let label22 = SKAction.run { self.runningLabel.text = ".....................>>" }
        let changeLabelSequence = SKAction.sequence([label1, waitToChangeLabel, label2, waitToChangeLabel, label3, waitToChangeLabel, label4, waitToChangeLabel, label5, waitToChangeLabel, label6, waitToChangeLabel, label7, waitToChangeLabel, label8, waitToChangeLabel, label9, waitToChangeLabel, label10, waitToChangeLabel, label11, waitToChangeLabel, label12, waitToChangeLabel, label13, waitToChangeLabel, label14, waitToChangeLabel, label15, waitToChangeLabel, label16, waitToChangeLabel, label17, waitToChangeLabel, label18, waitToChangeLabel, label19, waitToChangeLabel, label20, waitToChangeLabel, label21, waitToChangeLabel, label22, waitToChangeLabel])
        let changeLabelForever = SKAction.repeatForever(changeLabelSequence)
        
        runningLabel.fontSize = self.size.height * 0.025
        runningLabel.fontColor = SKColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 1)
        runningLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        runningLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.773)
        runningLabel.zPosition = 10
        runningLabel.run(changeLabelForever)
        
        stepLabel.text = "STEP:"
        stepLabel.fontSize = self.size.height * 0.02
        stepLabel.fontColor = SKColor.white
        stepLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        stepLabel.position = CGPoint(x: self.size.width * 0.343, y: self.size.height * 0.745)
        stepLabel.zPosition = 10
        
        gameScoreLabel.text = "\(gameScore)"
        gameScoreLabel.fontSize = self.size.height * 0.02
        gameScoreLabel.fontColor = SKColor.white
        gameScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        gameScoreLabel.position = CGPoint(x: self.size.width * 0.433, y: self.size.height * 0.745)
        gameScoreLabel.zPosition = 10
        
        activeTimerLabel.text = "TIME: 00:00:00"
        activeTimerLabel.fontSize = self.size.height * 0.02
        activeTimerLabel.fontColor = SKColor.white
        activeTimerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        activeTimerLabel.position = CGPoint(x: self.size.width * 0.335, y: self.size.height * 0.720)
        activeTimerLabel.zPosition = 10
        
        let explosionEffect = SKAction.scale(to: 10, duration: 0.4)
        let waitToRemove = SKAction.fadeOut(withDuration: 0.5)
        let removeExplosion = SKAction.run { self.explosion.removeFromParent() }
        let explosionSequence = SKAction.sequence([explosionSound, explosionEffect, waitToRemove, removeExplosion])
        
        explosion.size = self.size
        explosion.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        explosion.zPosition = 11
        explosion.setScale(0)
        explosion.run(explosionSequence)
        
        prepareGameScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchedLocation    = touch.location(in: self)
            let midScreen          = self.size.width / 2
            let scoreTabNodeTop    = self.size.height * (0.085 + 0.025)
            let scoreTabNodeBottom = self.size.height * (0.085 - 0.025)
            
            if currentGameState == gameState.beforeGame {
                if startButton.isHidden == false && self.contains(touchedLocation) && !backButton.contains(touchedLocation) {
                    currentGameState = gameState.duringGame
                    self.run(buttonPressedSound)
                    self.startButton.removeFromParent()
                    self.backButton.removeFromParent()
                    startGame()
                }
                if backButton.isHidden == false && self.contains(touchedLocation) && backButton.contains(touchedLocation) {
                    self.run(buttonPressedSound)
                    changeToMainMenuScene()
                }
            } else if currentGameState == gameState.duringGame {
                if self.contains(touchedLocation) && touchedLocation.x < midScreen {
                    if let blueNode = self.childNode(withName: "BlueTab") as? SKSpriteNode {
                        if blueNode.position.y <= scoreTabNodeTop && blueNode.position.y >= scoreTabNodeBottom {
                            blueNode.removeFromParent()
                            addScore()
                        } else {
                            loseLife()
                        }
                    } else {
                        loseLife()
                    }
                }
                if self.contains(touchedLocation) && touchedLocation.x > midScreen {
                    if let redNode = self.childNode(withName: "RedTab") as? SKSpriteNode {
                        if redNode.position.y <= scoreTabNodeTop && redNode.position.y >= scoreTabNodeBottom {
                            redNode.removeFromParent()
                            addScore()
                        } else {
                            loseLife()
                        }
                    } else {
                        loseLife()
                    }
                }
            }
        }
        
    }
    
    var timer = Timer()
    var timerStart = Bool()
    
    func startTimer() {
        
        timerStart = true
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(self.updateTimer),
            userInfo: nil,
            repeats: true
        )
        
    }
    
    @objc func updateTimer() {
        
        seconds += 1
        activeTimerLabel.text = "TIME: \(timeString(time: TimeInterval(seconds)))"
        
    }
    
    func timeString(time: TimeInterval) -> String {
        
        let hours   = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        
    }
    
    func prepareGameScene() {
        
        let scaleDuration = TimeInterval(0.25)
        
        let treadmillPosition = SKAction.moveTo(y: self.size.height * 0.5, duration: scaleDuration)
        let treadmillScaleDown = SKAction.scale(to: 1, duration: scaleDuration)
        treadmill.run(treadmillPosition)
        treadmill.run(treadmillScaleDown)
        
        let mirrorPosition = SKAction.moveTo(y: self.size.height * 0.85, duration: scaleDuration)
        let mirrorScaleDown = SKAction.scale(to: 1, duration: scaleDuration)
        mirror.run(mirrorPosition)
        mirror.run(mirrorScaleDown)
        
        let viewRePosition = SKAction.moveTo(y: self.size.height * 0.85, duration: scaleDuration)
        let viewReScale = SKAction.scale(to: 1, duration: scaleDuration)
        sunriseView.run(viewRePosition) ; sunriseView.run(viewReScale)
        daytimeView.run(viewRePosition) ; daytimeView.run(viewReScale)
        sunsetView.run(viewRePosition) ; sunsetView.run(viewReScale)
        nighttimeView.run(viewRePosition) ; nighttimeView.run(viewReScale)
        
        let waitToAddButton = SKAction.wait(forDuration: 0.5)
        let addButton = SKAction.run {
            self.startButton.isHidden = false
            self.backButton.isHidden = false
            self.addChild(self.startButton)
            self.addChild(self.backButton)
            self.addChild(self.scoreButton)
        }
        let addButtonSequence = SKAction.sequence([waitToAddButton, addButton])
        self.run(addButtonSequence)
        
    }
    
    func startGame() {
        
        self.addChild(runningLabel)
        self.addChild(stepLabel)
        self.addChild(gameScoreLabel)
        self.addChild(activeTimerLabel)
        self.treadmillEngineSound.play()
        randomColor = 2
        startTimer()
        startNextLevel()
        
    }
    
    func addScore() {
        
        gameScore += 1
        gameScoreLabel.text = "\(gameScore)"
        impact.impactOccurred()
        self.run(footstepSound)
        
        let scaleUp = SKAction.scale(to: 1.4, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        gameScoreLabel.run(scaleSequence)
        scoreButton.run(scaleSequence)
        
        let sceneUp = SKAction.scale(to: 1.005, duration: 0.02)
        let sceneDown = SKAction.scale(to: 1, duration: 0.02)
        let sceneSequence = SKAction.sequence([sceneUp, sceneDown])
        treadmill.run(sceneSequence)
        
        if gameScore % 2 == 0 { startNextLevel() }
        
    }
    
    func startNextLevel() {
        
        if self.action(forKey: "GenerateColorTab") != nil { self.removeAction(forKey: "GenerateColorTab") }
        
        var nextLevelDuration = Float().rounded(digits: 3)
        if gameScore % 10 == 0 { nextLevelDuration = 0.40 }
        else if gameScore >= 0   && gameScore < 10  { nextLevelDuration = 0.30 }
        else if gameScore >= 10  && gameScore < 50  { nextLevelDuration = 0.25 }
        else if gameScore >= 50  && gameScore < 100 { nextLevelDuration = 0.20 }
        else if gameScore >= 100 && gameScore < 200 { nextLevelDuration = 0.15 }
        else if gameScore >= 200 && gameScore < 500 { nextLevelDuration = 0.10 }
        else if gameScore >= 500 { nextLevelDuration = 0.05 }
        
        var tabDelay = Float().rounded(digits: 3)
        switch gameScore {
        case    0...4       : tabDelay = Float.random(in: 0.55...0.75).rounded(digits: 3)
        case    5...9       : tabDelay = Float.random(in: 0.50...0.70).rounded(digits: 3)
        case   10...14      : tabDelay = Float.random(in: 0.45...0.65).rounded(digits: 3)
        case   15...19      : tabDelay = Float.random(in: 0.40...0.60).rounded(digits: 3)
        case   20...24      : tabDelay = Float.random(in: 0.35...0.55).rounded(digits: 3)
        case   25...49      : tabDelay = Float.random(in: 0.30...0.50).rounded(digits: 3)
        case   50...99      : tabDelay = Float.random(in: 0.25...0.45).rounded(digits: 3)
        case  100...199     : tabDelay = Float.random(in: 0.20...0.40).rounded(digits: 3)
        case  200...499     : tabDelay = Float.random(in: 0.15...0.35).rounded(digits: 3)
        case  500...999     : tabDelay = Float.random(in: 0.10...0.30).rounded(digits: 3)
        case 1000...Int.max : tabDelay = Float.random(in: 0.05...0.25).rounded(digits: 3)
        default: tabDelay = 1.00 ; print("Delay System Error!") }
        
        let runNextLevel = SKAction.wait(forDuration: TimeInterval(nextLevelDuration))
        let waitForNextTab = SKAction.wait(forDuration: TimeInterval(tabDelay))
        let addColorTab = SKAction.run {
            if self.randomColor % 2 == 0 { self.generateBlueTab()
            } else { self.generateRedTab() }
            self.randomColor = Int.random(in: 1...2)
        }
        let tabSequence = SKAction.sequence([runNextLevel, addColorTab, waitForNextTab])
        let generateForever = SKAction.repeatForever(tabSequence)
        
        self.run(generateForever, withKey: "GenerateColorTab")
        
    }
    
    func generateBlueTab() {
        
        let startPoint = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        let endPoint   = CGPoint(x: self.size.width * 0.5, y: 0 + (self.size.height * 0.02))
        
        let blueTab = SKSpriteNode()
        blueTab.name = "BlueTab"
        blueTab.color = SKColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
        blueTab.size = CGSize(width: self.size.width * 0.45, height: self.size.height * 0.05)
        blueTab.position = startPoint
        blueTab.zPosition = 5
        self.addChild(blueTab)
        
        switch gameScore {
        case    0...4   : tabSpeed = 2.00
        case    5...9   : tabSpeed = 1.80
        case   10...14  : tabSpeed = 1.60
        case   15...19  : tabSpeed = 1.40
        case   20...24  : tabSpeed = 1.20
        case   25...49  : tabSpeed = 1.00
        case   50...99  : tabSpeed = 0.90
        case  100...199 : tabSpeed = 0.80
        case  200...499 : tabSpeed = 0.70
        case  500...999 : tabSpeed = 0.60
        case 1000...Int.max : tabSpeed = 0.50
        default: tabSpeed = 2.00 ; print("Speed System Error!") }
        
        let moveTab = SKAction.move(to: endPoint, duration: TimeInterval(tabSpeed))
        let deleteTab = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let blueTabSequence = SKAction.sequence([moveTab, deleteTab, loseLifeAction])
        
        if currentGameState == gameState.duringGame {
            blueTab.run(blueTabSequence)
        }
        
    }
    
    func generateRedTab() {
        
        let startPoint = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        let endPoint   = CGPoint(x: self.size.width * 0.5, y: 0 + (self.size.height * 0.025))
        
        let redTab = SKSpriteNode()
        redTab.name = "RedTab"
        redTab.color = SKColor.red
        redTab.size = CGSize(width: self.size.width * 0.45, height: self.size.height * 0.05)
        redTab.position = startPoint
        redTab.zPosition = 6
        self.addChild(redTab)
        
        switch gameScore {
        case    0...4   : tabSpeed = 2.00
        case    5...9   : tabSpeed = 1.80
        case   10...14  : tabSpeed = 1.60
        case   15...19  : tabSpeed = 1.40
        case   20...24  : tabSpeed = 1.20
        case   25...49  : tabSpeed = 1.00
        case   50...99  : tabSpeed = 0.90
        case  100...199 : tabSpeed = 0.80
        case  200...499 : tabSpeed = 0.70
        case  500...999 : tabSpeed = 0.60
        case 1000...Int.max : tabSpeed = 0.50
        default: tabSpeed = 2.00 ; print("Speed System Error!") }
        
        let moveTab = SKAction.move(to: endPoint, duration: TimeInterval(tabSpeed))
        let deleteTab = SKAction.removeFromParent()
        let loseLifeAction = SKAction.run(loseLife)
        let redTabSequence = SKAction.sequence([moveTab, deleteTab, loseLifeAction])
        
        if currentGameState == gameState.duringGame {
            redTab.run(redTabSequence)
        }
        
    }
    
    func loseLife() {
        
        self.run(errorSound)
        lifePoint -= 1
        if lifePoint <= 0 { self.addChild(self.explosion) ; runGameOver() }
        
    }
    
    func runGameOver() {
        
        currentGameState = gameState.afterGame
        timer.invalidate()
        self.treadmillEngineSound.stop()
        self.runningLabel.removeAllActions()
        self.removeAction(forKey: "GenerateColorTab")
        self.isUserInteractionEnabled = false
        self.enumerateChildNodes(withName: "BlueTab", using: {
            blueTab, stop in blueTab.removeAllActions()
            blueTab.run(SKAction.fadeOut(withDuration: 0.25))
        })
        self.enumerateChildNodes(withName: "RedTab", using: {
            redTab, stop in redTab.removeAllActions()
            redTab.run(SKAction.fadeOut(withDuration: 0.25))
        })
        
        let vibration = SKAction.run { AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) }
        let delayToChange = SKAction.wait(forDuration: 1)
        let changeSceneAction = SKAction.run(changeToGameOverScene)
        let changeSceneSequence = SKAction.sequence([vibration, delayToChange, changeSceneAction])
        
        activeTimer = activeTimerLabel.text!
        self.run(changeSceneSequence)
        
    }
    
    func changeToMainMenuScene() {
        
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
    func changeToTutorialScene() {
        
        let sceneToMoveTo = GameTutorialScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
    func changeToGameOverScene() {
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
}
