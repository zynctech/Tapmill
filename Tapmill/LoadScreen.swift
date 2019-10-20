//
//  LoadScreen.swift
//  Tapmill
//
//  Created by Zoom Nattapol on 25/5/19.
//  Copyright © 2019 ZyncTech. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

class LoadScreen: SKScene {
    
    let companyLogo  = SKSpriteNode(imageNamed: "zynctech")
    var openingSound : AVAudioPlayer!
    
    override func didMove(to view: SKView) {
        
        self.backgroundColor = SKColor.black
        deviceTime = Calendar.current.component(.hour, from: Date())
        
        let soundFilePath = Bundle.main.path(forResource: "thunderShortIntro", ofType: "mp3")!
        let audioURL = URL(fileURLWithPath: soundFilePath)
        do { openingSound = try AVAudioPlayer(contentsOf: audioURL) }
        catch { return print("Cannot find the audio file!") }
        
        let playOpeningSound = SKAction.run { self.openingSound.play() }
        let showLogo = SKAction.wait(forDuration: 4)
        let hideLogo = SKAction.fadeOut(withDuration: 1)
        let removeLogo = SKAction.removeFromParent()
        let moveToMainMenuScene = SKAction.run(changeToMainMenuScene)
        
        companyLogo.size = CGSize(width: self.size.width * 0.55, height: (self.size.width * 0.75) * 0.55)
        companyLogo.position = CGPoint(x: self.size.width * 0.5, y: self.size.height / 2)
        companyLogo.zPosition = 100
        companyLogo.run(SKAction.sequence([playOpeningSound, showLogo, hideLogo, removeLogo, moveToMainMenuScene]))
        
        self.addChild(companyLogo)
        
    }
    
    func changeToMainMenuScene() {
        
        let sceneToMoveTo = MainMenuScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        
        let sceneTransition = SKTransition.fade(withDuration: 0.25)
        self.view!.presentScene(sceneToMoveTo, transition: sceneTransition)
        
    }
    
}
