//
//  GameTutorialScene.swift
//  Tapmill
//
//  Created by Zoom Nattapol on 27/5/19.
//  Copyright © 2019 ZyncTech. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class GameTutorialScene: SKScene {
    
    
    let impact = UIImpactFeedbackGenerator()
    
    var treadmillEngineSound : AVAudioPlayer!
    
    let buttonPressedSound = SKAction.playSoundFileNamed("buttonPressSound.wav", waitForCompletion: false)
    let footstepSound      = SKAction.playSoundFileNamed("footstepSound.wav", waitForCompletion: false)
    let labelPopUpSound    = SKAction.playSoundFileNamed("popUpSound.m4a", waitForCompletion: false)
    let talkingSound       = SKAction.playSoundFileNamed("talkingBlaBla.wav", waitForCompletion: false)
    
    let startButton     = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let backToGameLabel = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let yesButton       = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let noButton        = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tappyLabel      = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tapScreenLabel1 = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tapScreenLabel2 = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tapScreenLabel3 = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    let tapScreenLabel4 = SKLabelNode(fontNamed: "PixelSplitter-Bold")
    
    let treadmill       = SKSpriteNode(imageNamed: "treadmill")
    let sunriseView     = SKSpriteNode(imageNamed: "viewSunrise")
    let daytimeView     = SKSpriteNode(imageNamed: "viewDaytime")
    let sunsetView      = SKSpriteNode(imageNamed: "viewSunset")
    let nighttimeView   = SKSpriteNode(imageNamed: "viewNighttime")
    let mirror          = SKSpriteNode(imageNamed: "mirror")
    let tappy           = SKSpriteNode(imageNamed: "tappyTalk")
    let leftHand        = SKSpriteNode(imageNamed: "hand-LeftHand")
    let rightHand       = SKSpriteNode(imageNamed: "hand-RightHand")
    let tabMarker       = SKSpriteNode(imageNamed: "tabMarker")
    
    let blink           = SKSpriteNode()
    let blueTab         = SKSpriteNode()
    let redTab          = SKSpriteNode()
    let scoreButton     = SKSpriteNode()
    
    enum gameState {
        case beforeTutorial
        case duringTutorial
        case waitToTapLeftScreen
        case waitToTapRightScreen
        case afterTutorial
    }
    
    var currentGameState = gameState.beforeTutorial
    var tabSpeed : Float = 3.5
    
    var tutorialScore    = 0
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.init(red: 0.12, green: 0.12, blue: 0.12, alpha: 1)
        deviceTime = Calendar.current.component(.hour, from: Date())
        
        let treadmillSoundFilePath = Bundle.main.path(forResource: "treadmillEngineSound", ofType: "mp3")!
        let treadmillAudioURL = URL(fileURLWithPath: treadmillSoundFilePath)
        do { treadmillEngineSound = try AVAudioPlayer(contentsOf: treadmillAudioURL) }
        catch { return print("Cannot find the audio file!") }
        self.treadmillEngineSound.numberOfLoops = -1
        self.treadmillEngineSound.volume = 1
        
        currentGameState = gameState.beforeTutorial
        tutorialScore = 0
        
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
        scoreButton.alpha = 0.2
        scoreButton.size = CGSize(width: self.size.width, height: self.size.height * 0.055)
        scoreButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.085)
        scoreButton.zPosition = 8
        
        let fadeInButton = SKAction.fadeIn(withDuration: 0.75)
        let fadeOutButton = SKAction.fadeOut(withDuration: 0.75)
        let buttonSequence = SKAction.sequence([fadeInButton, fadeOutButton])
        let blinkButton = SKAction.repeatForever(buttonSequence)
        
        startButton.text = "START TUTORIAL"
        startButton.fontSize = self.size.height * 0.025
        startButton.fontColor = SKColor.orange
        startButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startButton.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.748)
        startButton.zPosition = 10
        startButton.isHidden = true
        startButton.run(blinkButton)
        if currentGameState == gameState.beforeTutorial { self.addChild(startButton) }
        
        tapScreenLabel1.text = ""
        tapScreenLabel1.fontSize = self.size.height * 0.018
        tapScreenLabel1.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapScreenLabel1.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.763)
        tapScreenLabel1.zPosition = 12
        tapScreenLabel1.isHidden = true
        self.addChild(tapScreenLabel1)
        
        tapScreenLabel2.text = "SLIDE DOWN TO THE EDGE"
        tapScreenLabel2.fontSize = self.size.height * 0.018
        tapScreenLabel2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapScreenLabel2.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.738)
        tapScreenLabel2.zPosition = 12
        tapScreenLabel2.isHidden = true
        self.addChild(tapScreenLabel2)
        
        backToGameLabel.text = "BACK TO GAME?"
        backToGameLabel.fontSize = self.size.height * 0.025
        backToGameLabel.fontColor = SKColor.white
        backToGameLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        backToGameLabel.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.762)
        backToGameLabel.zPosition = 10
        
        yesButton.text = ">>YES!"
        yesButton.fontSize = self.size.height * 0.022
        yesButton.fontColor = SKColor.init(red: 0.0, green: 1.0, blue: 0.5, alpha: 1)
        yesButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        yesButton.position = CGPoint(x: self.size.width * 0.343, y: self.size.height * 0.732)
        yesButton.zPosition = 10
        
        noButton.text = ">>TRY AGAIN"
        noButton.fontSize = self.size.height * 0.022
        noButton.fontColor = SKColor.red
        noButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        noButton.position = CGPoint(x: self.size.width * 0.657, y: self.size.height * 0.732)
        noButton.zPosition = 10
        
        tappy.size = self.size
        tappy.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.5)
        tappy.zPosition = 15
        tappy.setScale(1)
        
        let waitToChangeLabel = SKAction.wait(forDuration: 2)
        let label1 = SKAction.run { self.run(self.talkingSound) ; self.tappyLabel.text = "HELLO!" }
        let label2 = SKAction.run { self.run(self.talkingSound) ; self.tappyLabel.text = "WELCOME TO TAPMILL" }
        let label3 = SKAction.run { self.run(self.talkingSound) ; self.tappyLabel.text = "LET`S GET STARTED" }
        let labelSequence = SKAction.sequence([label1, waitToChangeLabel, label2, waitToChangeLabel, label3])
        let waitToShowStartButton = SKAction.wait(forDuration: 2)
        let showStartButton = SKAction.run { self.run(self.buttonPressedSound) ; self.startButton.isHidden = false }
        let welcomeSequence = SKAction.sequence([labelSequence, waitToShowStartButton, showStartButton])
        
        tappyLabel.fontSize = self.size.height * 0.023
        tappyLabel.fontColor = SKColor.yellow
        tappyLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tappyLabel.position = CGPoint(x: self.size.width * 0.399, y: self.size.height * 0.44)
        tappyLabel.zPosition = 16
        tappyLabel.run(welcomeSequence)
        
        let upScale = SKAction.scale(to: 1.2, duration: 0)
        let downScale = SKAction.scale(to: 1, duration: 0)
        let setScaleDelay = SKAction.wait(forDuration: 0.15)
        let scaleSequence = SKAction.sequence([setScaleDelay, upScale, setScaleDelay, downScale])
        let arrowMarkerSequence = SKAction.repeatForever(scaleSequence)
        
        tabMarker.size = self.size
        tabMarker.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.085)
        tabMarker.zPosition = 14
        tabMarker.setScale(1)
        tabMarker.run(arrowMarkerSequence)
        
        leftHand.size = leftHand.self.size
        leftHand.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.07)
        leftHand.zPosition = 13
        leftHand.setScale(0.4)
        
        rightHand.size = rightHand.self.size
        rightHand.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.07)
        rightHand.zPosition = 13
        rightHand.setScale(0.4)
        
        prepareGameTutorialScene()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let touchedLocation = touch.location(in: self)
            
            if currentGameState == gameState.beforeTutorial {
                if startButton.isHidden == false && self.contains(touchedLocation) {
                    currentGameState = gameState.duringTutorial
                    self.run(buttonPressedSound)
                    self.tappy.removeFromParent()
                    self.tappyLabel.removeFromParent()
                    self.startButton.removeFromParent()
                    self.addChild(tabMarker)
                    generateBlueTab()
                }
            } else if currentGameState == gameState.waitToTapLeftScreen {
                if blink.contains(touchedLocation) {
                    tapScreen()
                    if tutorialScore < 2 { currentGameState = gameState.duringTutorial ; generateBlueTab() }
                    else { currentGameState = gameState.duringTutorial ; generateRedTab() }
                }
            } else if currentGameState == gameState.waitToTapRightScreen {
                if blink.contains(touchedLocation) {
                    tapScreen()
                    if tutorialScore < 4 { currentGameState = gameState.duringTutorial ; generateRedTab() }
                    else if tutorialScore == 4 {
                        currentGameState = gameState.afterTutorial
                        self.tabMarker.removeFromParent()
                        self.run(self.buttonPressedSound)
                        self.addChild(backToGameLabel)
                        self.addChild(yesButton)
                        self.addChild(noButton)
                    }
                }
            } else if currentGameState == gameState.afterTutorial {
                if yesButton.contains(touchedLocation) {
                    self.run(buttonPressedSound)
                    changeToGameScene()
                } else if noButton.contains(touchedLocation) {
                    currentGameState = gameState.duringTutorial
                    tutorialScore = 0
                    self.run(buttonPressedSound)
                    self.backToGameLabel.removeFromParent()
                    self.yesButton.removeFromParent()
                    self.noButton.removeFromParent()
                    self.addChild(tabMarker)
                    generateBlueTab()
                }
            }
            
        }
        
    }
    
    //////////////////////////////////////////////////
    
    func prepareGameTutorialScene() {
        
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
            self.addChild(self.tappy)
            self.addChild(self.tappyLabel)
            self.addChild(self.scoreButton)
        }
        let addButtonSequence = SKAction.sequence([waitToAddButton, addButton])
        self.run(addButtonSequence)
        
    }
    
    func tapScreen() {
        
        let hapticScreen = SKAction.run { self.impact.impactOccurred() }
        
        let scaleUp = SKAction.scale(to: 1.4, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1, duration: 0.1)
        let upScaleSequence = SKAction.sequence([hapticScreen, footstepSound, scaleUp, scaleDown])
        scoreButton.run(upScaleSequence)
        
        let waitToScaleBack = SKAction.wait(forDuration: 0.10)
        let waitToRemove = SKAction.wait(forDuration: 0.05)
        
        let leftHandScaleDown = SKAction.run { self.leftHand.setScale(0.3) }
        let leftHandScaleUp = SKAction.run { self.leftHand.setScale(0.4) }
        let removeLeftHand = SKAction.run { self.leftHand.removeFromParent() }
        let leftHandSequence = SKAction.sequence([leftHandScaleDown, waitToScaleBack, leftHandScaleUp, waitToRemove, removeLeftHand])
        
        let rightHandScaleDown = SKAction.run { self.rightHand.setScale(0.3) }
        let rightHandScaleUp = SKAction.run { self.rightHand.setScale(0.4) }
        let removerightHand = SKAction.run { self.rightHand.removeFromParent() }
        let rightHandSequence = SKAction.sequence([rightHandScaleDown, waitToScaleBack, rightHandScaleUp, waitToRemove, removerightHand])
        
        blink.removeFromParent()
        tutorialScore += 1
        if currentGameState == gameState.waitToTapLeftScreen {
            blueTab.removeFromParent()
            tapScreenLabel3.removeAllActions()
            tapScreenLabel4.removeAllActions()
            tapScreenLabel3.removeFromParent()
            tapScreenLabel4.removeFromParent()
            leftHand.run(leftHandSequence)
        } else if currentGameState == gameState.waitToTapRightScreen {
            redTab.removeFromParent()
            tapScreenLabel3.removeAllActions()
            tapScreenLabel4.removeAllActions()
            tapScreenLabel3.removeFromParent()
            tapScreenLabel4.removeFromParent()
            rightHand.run(rightHandSequence)
        }
        
    }
    
    func blinkScreen() {
        
        let blinkIn = SKAction.fadeAlpha(to: 0.2, duration: 0.4)
        let blinkOut = SKAction.fadeAlpha(to: 0, duration: 0.4)
        let blinkSequence = SKAction.sequence([blinkIn, blinkOut])
        let blinkAction = SKAction.repeatForever(blinkSequence)
        
        blink.name = "Blink"
        blink.color = SKColor.white
        blink.alpha = 0
        blink.size = CGSize(width: self.size.width * 0.5, height: self.size.height)
        blink.zPosition = 11
        blink.run(blinkAction)
        
        tapScreenLabel3.text = ""
        tapScreenLabel3.fontSize = self.size.height * 0.018
        tapScreenLabel3.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapScreenLabel3.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.763)
        tapScreenLabel3.zPosition = 12
        
        tapScreenLabel4.text = ""
        tapScreenLabel4.fontSize = self.size.height * 0.018
        tapScreenLabel4.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        tapScreenLabel4.position = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.738)
        tapScreenLabel4.zPosition = 12
        
        let waitToChangeColor = SKAction.wait(forDuration: 0.3)
        let yellowLabel = SKAction.run {
            self.tapScreenLabel3.fontColor = SKColor.black
            self.tapScreenLabel4.fontColor = SKColor.black
        }
        let blueLabel = SKAction.run {
            self.tapScreenLabel3.fontColor = SKColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
            self.tapScreenLabel4.fontColor = SKColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
        }
        let redLabel = SKAction.run {
            self.tapScreenLabel3.fontColor = SKColor.red
            self.tapScreenLabel4.fontColor = SKColor.red
        }
        let blinkToBlue = SKAction.sequence([yellowLabel, waitToChangeColor, blueLabel, waitToChangeColor])
        let highlightBlueLabel = SKAction.repeatForever(blinkToBlue)
        let blinkToRed = SKAction.sequence([yellowLabel, waitToChangeColor, redLabel, waitToChangeColor])
        let highlightRedLabel = SKAction.repeatForever(blinkToRed)
        
        if currentGameState == gameState.waitToTapLeftScreen {
            tapScreenLabel1.removeAllActions()
            tapScreenLabel2.removeAllActions()
            tapScreenLabel1.isHidden = true
            tapScreenLabel2.isHidden = true
            blink.position = CGPoint(x: self.size.width * 0.25, y: self.size.height * 0.5)
            self.addChild(blink)
            self.run(buttonPressedSound)
            tapScreenLabel3.text = "THEN.. TAP ON"
            tapScreenLabel4.text = "LEFT SIDE OF SCREEN"
            tapScreenLabel3.fontColor = SKColor.clear
            tapScreenLabel4.fontColor = SKColor.clear
            tapScreenLabel3.run(highlightBlueLabel)
            tapScreenLabel4.run(highlightBlueLabel)
            self.addChild(tapScreenLabel3)
            self.addChild(tapScreenLabel4)
            self.addChild(leftHand)
        } else if currentGameState == gameState.waitToTapRightScreen {
            tapScreenLabel1.removeAllActions()
            tapScreenLabel2.removeAllActions()
            tapScreenLabel1.isHidden = true
            tapScreenLabel2.isHidden = true
            blink.position = CGPoint(x: self.size.width * 0.75, y: self.size.height * 0.5)
            self.addChild(blink)
            self.run(buttonPressedSound)
            tapScreenLabel3.text = "THEN.. TAP ON"
            tapScreenLabel4.text = "RIGHT SIDE OF SCREEN"
            tapScreenLabel3.fontColor = SKColor.clear
            tapScreenLabel4.fontColor = SKColor.clear
            tapScreenLabel3.run(highlightRedLabel)
            tapScreenLabel4.run(highlightRedLabel)
            self.addChild(tapScreenLabel3)
            self.addChild(tapScreenLabel4)
            self.addChild(rightHand)
        }
        
    }
    
    func generateBlueTab() {
        
        let startPoint      = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        let endPoint        = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.085)
        
        let playEngineSound = SKAction.run { self.treadmillEngineSound.play() }
        let stopEngineSound = SKAction.run { self.treadmillEngineSound.stop() }
        let moveTab         = SKAction.move(to: endPoint, duration: TimeInterval(tabSpeed))
        let blinkLeft       = SKAction.run { self.currentGameState = gameState.waitToTapLeftScreen ; self.blinkScreen() }
        let blueTabSequence = SKAction.sequence([playEngineSound, moveTab, stopEngineSound, blinkLeft])
        
        blueTab.name = "BlueTab"
        blueTab.color = SKColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
        blueTab.size = CGSize(width: self.size.width * 0.45, height: self.size.height * 0.05)
        blueTab.position = startPoint
        blueTab.zPosition = 5
        blueTab.run(blueTabSequence)
        
        let waitToChangeColor = SKAction.wait(forDuration: 0.3)
        let yellowLabel = SKAction.run {
            self.tapScreenLabel1.fontColor = SKColor.black
            self.tapScreenLabel2.fontColor = SKColor.black
        }
        let blueLabel = SKAction.run {
            self.tapScreenLabel1.fontColor = SKColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
            self.tapScreenLabel2.fontColor = SKColor.init(red: 0.0, green: 0.5, blue: 1.0, alpha: 1)
        }
        let blinkToBlue = SKAction.sequence([blueLabel, waitToChangeColor, yellowLabel, waitToChangeColor])
        let highlightBlueLabel = SKAction.repeatForever(blinkToBlue)
        
        tapScreenLabel1.text = "WAIT FOR BLUE TAB"
        tapScreenLabel1.fontColor = SKColor.clear
        tapScreenLabel2.fontColor = SKColor.clear
        tapScreenLabel1.run(highlightBlueLabel)
        tapScreenLabel2.run(highlightBlueLabel)
        tapScreenLabel1.isHidden = false
        tapScreenLabel2.isHidden = false
        self.addChild(blueTab)
        
    }
    
    func generateRedTab() {
        
        let startPoint      = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.6)
        let endPoint        = CGPoint(x: self.size.width * 0.5, y: self.size.height * 0.085)
        
        let playEngineSound = SKAction.run { self.treadmillEngineSound.play() }
        let stopEngineSound = SKAction.run { self.treadmillEngineSound.stop() }
        let moveTab         = SKAction.move(to: endPoint, duration: TimeInterval(tabSpeed))
        let blinkRight      = SKAction.run { self.currentGameState = gameState.waitToTapRightScreen ; self.blinkScreen() }
        let redTabSequence  = SKAction.sequence([playEngineSound, moveTab, stopEngineSound, blinkRight])
        
        redTab.name = "RedTab"
        redTab.color = SKColor.red
        redTab.size = CGSize(width: self.size.width * 0.45, height: self.size.height * 0.05)
        redTab.position = startPoint
        redTab.zPosition = 6
        redTab.run(redTabSequence)
        
        let waitToChangeColor = SKAction.wait(forDuration: 0.3)
        let yellowLabel = SKAction.run {
            self.tapScreenLabel1.fontColor = SKColor.black
            self.tapScreenLabel2.fontColor = SKColor.black
        }
        let redLabel = SKAction.run {
            self.tapScreenLabel1.fontColor = SKColor.red
            self.tapScreenLabel2.fontColor = SKColor.red
        }
        let blinkToRed = SKAction.sequence([redLabel, waitToChangeColor, yellowLabel, waitToChangeColor])
        let highlightRedLabel = SKAction.repeatForever(blinkToRed)
        
        tapScreenLabel1.text = "WAIT FOR RED TAB"
        tapScreenLabel1.fontColor = SKColor.clear
        tapScreenLabel2.fontColor = SKColor.clear
        tapScreenLabel1.run(highlightRedLabel)
        tapScreenLabel2.run(highlightRedLabel)
        tapScreenLabel1.isHidden = false
        tapScreenLabel2.isHidden = false
        self.addChild(redTab)
        
    }
    
    func changeToGameScene() {
        
        let sceneToMoveTo = GameScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
}
