//
//  MainMenuScene.swift
//  Tapmill
//
//  Created by Zoom Nattapol on 25/5/19.
//  Copyright © 2019 ZyncTech. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class MainMenuScene: SKScene {
    
    var mainMenuAmbienceSound : AVAudioPlayer!
    
    let buttonPressedSound = SKAction.playSoundFileNamed("buttonPressSound.wav", waitForCompletion: false)
    let labelPopUpSound    = SKAction.playSoundFileNamed("popUpSound.m4a", waitForCompletion: false)
    let swooshLabelSound   = SKAction.playSoundFileNamed("swoosh.wav", waitForCompletion: false)
    
    let startGameButton = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tutorialLabel   = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tutorialButton  = SKSpriteNode(imageNamed: "infoButton")
    let gameTitle1      = SKSpriteNode(imageNamed: "gameTitle1")
    let gameTitle2      = SKSpriteNode(imageNamed: "gameTitle2")
    let treadmill       = SKSpriteNode(imageNamed: "treadmill")
    let sunriseView     = SKSpriteNode(imageNamed: "viewSunrise")
    let daytimeView     = SKSpriteNode(imageNamed: "viewDaytime")
    let sunsetView      = SKSpriteNode(imageNamed: "viewSunset")
    let nighttimeView   = SKSpriteNode(imageNamed: "viewNighttime")
    let mirror          = SKSpriteNode(imageNamed: "mirror")
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.init(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
        deviceTime = Calendar.current.component(.hour, from: Date())
        
        let mainMenuSoundFilePath = Bundle.main.path(forResource: "MainMenuAmbience", ofType: "wav")!
        let mainMenuAudioURL = URL(fileURLWithPath: mainMenuSoundFilePath)
        do { mainMenuAmbienceSound = try AVAudioPlayer(contentsOf: mainMenuAudioURL) }
        catch { return print("Cannot find the audio file!") }
        self.mainMenuAmbienceSound.numberOfLoops = -1
        self.mainMenuAmbienceSound.volume = 0.25
        
        treadmill.name = "Treadmill"
        treadmill.size = self.size
        treadmill.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.25)
        treadmill.zPosition = 9
        treadmill.setScale(1.5)
        
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
        
        let titleScaleIn = SKAction.scale(to: 0.75, duration: 0.2)
        let titleScaleSet = SKAction.scale(to: 0.55, duration: 0.1)
        let titleSequence = SKAction.sequence([titleScaleIn, titleScaleSet])
        
        gameTitle1.size = gameTitle1.self.size
        gameTitle1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.828)
        gameTitle1.zPosition = 10
        gameTitle1.setScale(0)
        gameTitle1.run(SKAction.sequence([labelPopUpSound, titleSequence]))
        
        gameTitle2.size = gameTitle2.self.size
        gameTitle2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.830)
        gameTitle2.zPosition = 10
        gameTitle2.setScale(0)
        gameTitle2.run(SKAction.sequence([labelPopUpSound, titleSequence]))
        
        tutorialLabel.text = "HOW TO PLAY"
        tutorialLabel.fontSize = self.size.height * 0.019
        tutorialLabel.fontColor = SKColor.darkGray
        tutorialLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        tutorialLabel.position = CGPoint(x: self.size.width * 0.73, y: self.size.height * 0.571)
        tutorialLabel.zPosition = 10
        
        tutorialButton.size = tutorialButton.self.size
        tutorialButton.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.579)
        tutorialButton.zPosition = 10
        tutorialButton.alpha = 0.3
        tutorialButton.setScale(0.013)
        
        let buttonScaleIn = SKAction.scale(to: 1.2, duration: 0.2)
        let buttonScaleSet = SKAction.scale(to: 1, duration: 0.1)
        
        startGameButton.text = "START GAME"
        startGameButton.fontSize = self.size.height * 0.04
        startGameButton.fontColor = SKColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 1)
        startGameButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startGameButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.623)
        startGameButton.zPosition = 10
        startGameButton.alpha = 1
        startGameButton.setScale(0)
        startGameButton.isHidden = true
        startGameButton.run(SKAction.sequence([buttonScaleIn, buttonScaleSet]))
        
        let wait04sec = SKAction.wait(forDuration: 0.4)
        let wait15sec = SKAction.wait(forDuration: 1.5)
        let addTitle1 = SKAction.run { self.addChild(self.gameTitle1) }
        let addTitle2 = SKAction.run { self.addChild(self.gameTitle2) }
        let addTitleSequence = SKAction.sequence([wait04sec, addTitle1, wait04sec, addTitle2])
        let addStartButton = SKAction.run {
            self.startGameButton.isHidden = false
            self.addChild(self.startGameButton)
            self.addChild(self.tutorialLabel)
            self.addChild(self.tutorialButton)
            self.mainMenuAmbienceSound.play()
        }
        let addGameScene = SKAction.run {
            self.addChild(self.treadmill)
            if deviceTime >= 0 && deviceTime < 5 { self.addChild(self.nighttimeView) }
            else if deviceTime >= 5 && deviceTime < 6 { self.addChild(self.sunriseView) }
            else if deviceTime >= 6 && deviceTime < 17 { self.addChild(self.daytimeView) }
            else if deviceTime >= 17 && deviceTime < 19 { self.addChild(self.sunsetView) }
            else if deviceTime >= 19 && deviceTime <= 23 { self.addChild(self.nighttimeView) }
            self.run(addTitleSequence)
        }
        let startAppSequence = SKAction.sequence([addGameScene, wait15sec, addStartButton])
        
        let fadeInButton = SKAction.fadeIn(withDuration: 0.75)
        let fadeOutButton = SKAction.fadeOut(withDuration: 0.75)
        let buttonSequence = SKAction.sequence([fadeInButton, fadeOutButton])
        let blinkButton = SKAction.repeatForever(buttonSequence)
        
        self.run(startAppSequence)
        self.startGameButton.run(blinkButton)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let moveLeft = SKAction.moveTo(x: self.size.width * -2, duration: 1)
        let moveRight = SKAction.moveTo(x: self.size.width * 2, duration: 1)
        
        let waitToChangeScene = SKAction.wait(forDuration: 0.5)
        let toGameScene = SKAction.run(changeToGameScene)
        let toTutorialScene = SKAction.run(changeToGameTutorialScene)
        
        for touch: AnyObject in touches {
            
            let touchedLocation = touch.location(in: self)
            
            if startGameButton.isHidden == false && self.contains(touchedLocation) {
                
                self.isUserInteractionEnabled = false
                self.startGameButton.removeFromParent()
                self.tutorialLabel.removeFromParent()
                self.tutorialButton.removeFromParent()
                self.run(buttonPressedSound)
                gameTitle1.setScale(0.52)
                gameTitle2.setScale(0.52)
                gameTitle1.run(moveLeft)
                gameTitle2.run(moveRight)
                self.run(swooshLabelSound)
                
                if highScoreNumber == 0 { self.run(SKAction.sequence([waitToChangeScene, toTutorialScene])) }
                else { self.run(SKAction.sequence([waitToChangeScene, toGameScene])) }
                
            }
            
            if tutorialLabel.contains(touchedLocation) || tutorialButton.contains(touchedLocation) {
                
                self.mainMenuAmbienceSound.stop()
                self.isUserInteractionEnabled = false
                self.startGameButton.removeFromParent()
                self.tutorialLabel.removeFromParent()
                self.tutorialButton.removeFromParent()
                self.run(buttonPressedSound)
                gameTitle1.setScale(0.52)
                gameTitle2.setScale(0.52)
                gameTitle1.run(moveLeft)
                gameTitle2.run(moveRight)
                self.run(swooshLabelSound)
                
                self.run(SKAction.sequence([waitToChangeScene, toTutorialScene]))
                
            }
            
        }
        
    }
    
    func changeToGameTutorialScene() {
        
        self.mainMenuAmbienceSound.stop()
        
        let sceneToMoveTo = GameTutorialScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
    func changeToGameScene() {
        
        self.mainMenuAmbienceSound.stop()
        
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
}
