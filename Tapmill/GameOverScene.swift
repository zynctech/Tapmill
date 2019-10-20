//
//  GameOverScene.swift
//  Tapmill
//
//  Created by Zoom Nattapol on 25/5/19.
//  Copyright © 2019 ZyncTech. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

let highScoreDefaults = UserDefaults()
var highScoreNumber = highScoreDefaults.integer(forKey: "HighScoreSaved")

class GameOverScene: SKScene {
    
    var gameOverAmbienceSound : AVAudioPlayer!
    
    let buttonPressSound   = SKAction.playSoundFileNamed("buttonPressSound.wav", waitForCompletion: false)
    let gameOverSound      = SKAction.playSoundFileNamed("gameOverSound.wav", waitForCompletion: false)
    let labelPopUpSound    = SKAction.playSoundFileNamed("popUpSound.m4a", waitForCompletion: false)
    let newHighScoreSound  = SKAction.playSoundFileNamed("successSound.wav", waitForCompletion: false)
    
    let gameOverLabel      = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let newHighScoreLabel  = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let currentScoereLabel = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let highScoreText      = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let highScoreLabel     = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let activeTimerLabel   = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let restartLabel       = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    
    let treadmill          = SKSpriteNode(imageNamed: "treadmill")
    let sunriseView        = SKSpriteNode(imageNamed: "viewSunrise")
    let daytimeView        = SKSpriteNode(imageNamed: "viewDaytime")
    let sunsetView         = SKSpriteNode(imageNamed: "viewSunset")
    let nighttimeView      = SKSpriteNode(imageNamed: "viewNighttime")
    let mirror             = SKSpriteNode(imageNamed: "mirror")
    
    let adsScene           = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.init(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
        deviceTime = Calendar.current.component(.hour, from: Date())
        
        let gameOverSoundFilePath = Bundle.main.path(forResource: "GameOverAmbience", ofType: "wav")!
        let gameOverAudioURL = URL(fileURLWithPath: gameOverSoundFilePath)
        do { gameOverAmbienceSound = try AVAudioPlayer(contentsOf: gameOverAudioURL) }
        catch { return print("Cannot find the audio file!") }
        self.gameOverAmbienceSound.numberOfLoops = -1
        self.gameOverAmbienceSound.volume = 0.5
        self.run(gameOverSound)
        
        treadmill.name = "Treadmill"
        treadmill.size = self.size
        treadmill.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        treadmill.zPosition = 9
        treadmill.setScale(1)
        self.addChild(treadmill)
        
        mirror.size = CGSize(width: self.size.width, height: self.size.width * 0.67)
        mirror.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
        mirror.zPosition = 8
        mirror.setScale(1)
        self.addChild(mirror)
        
        sunriseView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        sunriseView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
        sunriseView.zPosition = 7
        sunriseView.setScale(1)
        
        daytimeView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        daytimeView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
        daytimeView.zPosition = 7
        daytimeView.setScale(1)
        
        sunsetView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        sunsetView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
        sunsetView.zPosition = 7
        sunsetView.setScale(1)
        
        nighttimeView.size = CGSize(width: self.size.width, height: self.size.width * 0.6)
        nighttimeView.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.85)
        nighttimeView.zPosition = 7
        nighttimeView.setScale(1)
        
        if deviceTime >= 0 && deviceTime < 5 { self.addChild(self.nighttimeView) }
        else if deviceTime >= 5 && deviceTime < 6 { self.addChild(self.sunriseView) }
        else if deviceTime >= 6 && deviceTime < 17 { self.addChild(self.daytimeView) }
        else if deviceTime >= 17 && deviceTime < 19 { self.addChild(self.sunsetView) }
        else if deviceTime >= 19 && deviceTime <= 23 { self.addChild(self.nighttimeView) }
        
        let waitToChangeLabel = SKAction.wait(forDuration: 0.75)
        let label1 = SKAction.run { self.gameOverLabel.text = "GAMEOVER." }
        let label2 = SKAction.run { self.gameOverLabel.text = "GAMEOVER.." }
        let label3 = SKAction.run { self.gameOverLabel.text = "GAMEOVER..." }
        let label4 = SKAction.run { self.gameOverLabel.text = "GAMEOVER...." }
        let changeLabelSequence = SKAction.sequence([label1, waitToChangeLabel, label2, waitToChangeLabel, label3, waitToChangeLabel, label4, waitToChangeLabel])
        let changeLabelForever = SKAction.repeatForever(changeLabelSequence)
        
        gameOverLabel.text = "GAMEOVER"
        gameOverLabel.fontSize = self.size.height * 0.035
        gameOverLabel.fontColor = SKColor.orange
        gameOverLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        gameOverLabel.position = CGPoint(x: self.size.width * 0.265, y: self.size.height * 0.668)
        gameOverLabel.zPosition = 10
        gameOverLabel.isHidden = false
        gameOverLabel.run(changeLabelForever)
        
        let fadeInLabel = SKAction.fadeIn(withDuration: 0.1)
        let fadeOutLabel = SKAction.fadeOut(withDuration: 0.1)
        let labelSequence = SKAction.sequence([fadeOutLabel, fadeInLabel])
        let blinkLabel = SKAction.repeat(labelSequence, count: 3)
        
        newHighScoreLabel.text = "NEW HIGH SCORE !!"
        newHighScoreLabel.fontSize = self.size.height * 0.035
        newHighScoreLabel.fontColor = SKColor.orange
        newHighScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        newHighScoreLabel.position = CGPoint(x: self.size.width * 0.265, y: self.size.height * 0.668)
        newHighScoreLabel.zPosition = 10
        newHighScoreLabel.isHidden = true
        
        currentScoereLabel.text = "SCORE: \(gameScore)"
        currentScoereLabel.fontSize = self.size.height * 0.025
        currentScoereLabel.fontColor = SKColor.white
        currentScoereLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        currentScoereLabel.position = CGPoint(x: self.size.width * 0.260, y: self.size.height * 0.635)
        currentScoereLabel.zPosition = 10
        
        highScoreText.text = "HIGH SCORE:"
        highScoreText.fontSize = self.size.height * 0.025
        highScoreText.fontColor = SKColor.white
        highScoreText.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highScoreText.position = CGPoint(x: self.size.width * 0.255, y: self.size.height * 0.605)
        highScoreText.zPosition = 10
        
        let fadeInScore = SKAction.fadeIn(withDuration: 0.1)
        let fadeOutScore = SKAction.fadeOut(withDuration: 0.1)
        let fadeScoreSequence = SKAction.sequence([fadeOutScore, fadeInScore])
        let blinkScore = SKAction.repeat(fadeScoreSequence, count: 2)
        let scaleUpScore = SKAction.scale(to: 1.3, duration: 0.1)
        let scaleDownScore = SKAction.scale(to: 1, duration: 0.1)
        let hilightScore = SKAction.sequence([scaleUpScore, blinkScore, scaleDownScore])
        
        if gameScore > highScoreNumber {
            
            highScoreNumber = gameScore
            highScoreDefaults.set(highScoreNumber, forKey: "HighScoreSaved")
            
            self.run(newHighScoreSound)
            gameOverLabel.isHidden = true
            newHighScoreLabel.isHidden = false
            newHighScoreLabel.run(blinkLabel)
            
            highScoreLabel.fontColor = SKColor.red
            highScoreLabel.run(hilightScore)
            
        } else {
            
            highScoreLabel.fontColor = SKColor.white
            
        }
        
        highScoreLabel.text = "\(highScoreNumber)"
        highScoreLabel.fontSize = self.size.height * 0.025
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        highScoreLabel.position = CGPoint(x: self.size.width * 0.495, y: self.size.height * 0.605)
        highScoreLabel.zPosition = 10
        
        activeTimerLabel.text = activeTimer
        activeTimerLabel.fontSize = self.size.height * 0.025
        activeTimerLabel.fontColor = SKColor.white
        activeTimerLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        activeTimerLabel.position = CGPoint(x: self.size.width * 0.245, y: self.size.height * 0.575)
        activeTimerLabel.zPosition = 10
        
        let fadeInButton = SKAction.fadeIn(withDuration: 0.75)
        let fadeOutButton = SKAction.fadeOut(withDuration: 0.75)
        let buttonSequence = SKAction.sequence([fadeInButton, fadeOutButton])
        let blinkButton = SKAction.repeatForever(buttonSequence)
        
        restartLabel.text = "RESTART"
        restartLabel.fontSize = self.size.height * 0.03
        restartLabel.fontColor = SKColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 1)
        restartLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        restartLabel.position = CGPoint(x: self.size.width * 0.750, y: self.size.height * 0.575)
        restartLabel.zPosition = 10
        restartLabel.isHidden = true
        restartLabel.run(blinkButton)
        self.addChild(restartLabel)
        
        let prepareScene = SKAction.run(prepareGameOverScene)
        let waitAction = SKAction.wait(forDuration: 0.4)
        let addGameOverLabel  = SKAction.run { self.addChild(self.gameOverLabel) ; self.addChild(self.newHighScoreLabel) }
        let addScoreLabel     = SKAction.run { self.addChild(self.currentScoereLabel) ; self.gameOverAmbienceSound.play() }
        let addHighScoreLabel = SKAction.run { self.addChild(self.highScoreText) ; self.addChild(self.highScoreLabel) }
        let addTimerLabel     = SKAction.run { self.addChild(self.activeTimerLabel) }
        let addRestartButton  = SKAction.run { self.restartLabel.isHidden = false }
        let gameOverSceneSequence = SKAction.sequence([prepareScene, waitAction, addGameOverLabel, waitAction, addScoreLabel, waitAction, addHighScoreLabel, waitAction, addTimerLabel, waitAction, addRestartButton])
        
        self.run(gameOverSceneSequence)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let runInterstitialAds = SKAction.run {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "runInterstitialAds"), object: nil)
        }
        let waitToChangeScene = SKAction.wait(forDuration: 0.5)
        let changeScene = SKAction.run(changeToGameScene)
        
        for touch: AnyObject in touches {
            let touchedLocation = touch.location(in: self)
            if restartLabel.isHidden == false && self.contains(touchedLocation) {
                self.isUserInteractionEnabled = false
                self.run(buttonPressSound)
                self.gameOverAmbienceSound.stop()
                if seconds >= 30 { self.run(SKAction.sequence([runInterstitialAds, waitToChangeScene, changeScene])) }
                else { self.run(SKAction.sequence([waitToChangeScene,changeScene])) }
            }
        }
        
    }
    
    func prepareGameOverScene() {
        
        let scaleDuration = TimeInterval(0.25)
        
        let treadmillPosition = SKAction.moveTo(y: self.size.height * 0.25, duration: scaleDuration)
        let treadmillScaleDown = SKAction.scale(to: 1.5, duration: scaleDuration)
        treadmill.run(treadmillPosition)
        treadmill.run(treadmillScaleDown)
        
        let mirrorPosition = SKAction.moveTo(y: self.size.height * 0.75, duration: scaleDuration)
        let mirrorScaleDown = SKAction.scale(to: 1.5, duration: scaleDuration)
        mirror.run(mirrorPosition)
        mirror.run(mirrorScaleDown)
        
        let viewRePosition = SKAction.moveTo(y: self.size.height * 0.75, duration: scaleDuration)
        let viewReScale = SKAction.scale(to: 1.5, duration: scaleDuration)
        sunriseView.run(viewRePosition) ; sunriseView.run(viewReScale)
        daytimeView.run(viewRePosition) ; daytimeView.run(viewReScale)
        sunsetView.run(viewRePosition) ; sunsetView.run(viewReScale)
        nighttimeView.run(viewRePosition) ; nighttimeView.run(viewReScale)
        
    }
    
    //////////////////////////////////////////////////
    
    func changeToGameScene() {
        
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
}
