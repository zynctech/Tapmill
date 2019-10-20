//
//  GameViewController.swift
//  Tapmill
//
//  Created by Zoom Nattapol on 25/5/19.
//  Copyright © 2019 ZyncTech. All rights reserved.
//
//  App ID : ca-app-pub-6224986438183156~9570429881
//  
//  Ads ID : ca-app-pub-6224986438183156/5603264718
//

import UIKit
import SpriteKit
import GameplayKit
import AVFoundation
import GoogleMobileAds

class GameViewController: UIViewController, GADInterstitialDelegate {
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        interstitial = createAndLoadInterstitial()
        
        if let view = self.view as! SKView? {
            let mainScene = LoadScreen(size: CGSize(width: 1536, height: 2048))
            mainScene.scaleMode = SKSceneScaleMode.aspectFill
            view.presentScene(mainScene)
            view.ignoresSiblingOrder = false
            view.showsFPS = false
            view.showsNodeCount = false
        }
        
    }
    
    override var shouldAutorotate: Bool { return true }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone { return .allButUpsideDown }
        else { return .all }
    }
    
    override var prefersStatusBarHidden: Bool { return true }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-6224986438183156/5603264718")
        interstitial.delegate = self
        
        let request = GADRequest()
        interstitial.load(request)
        
        return interstitial
        
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        
        interstitial = createAndLoadInterstitial()
        
    }
    
//    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
//
//        print("interstitialDidReceiveAd")
//        /// Tells the delegate an ad request succeeded.
//
//    }
//
//    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
//
//        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
//        /// Tells the delegate an ad request failed.
//
//    }
//
//    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
//
//        print("interstitialWillPresentScreen")
//        /// Tells the delegate that an interstitial will be presented.
//
//    }
//
//    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
//
//        print("interstitialWillDismissScreen")
//        /// Tells the delegate the interstitial is to be animated off the screen.
//
//    }
//
//    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
//
//        print("interstitialWillLeaveApplication")
//        /// Tells the delegate that a user click will open another app
//        /// (such as the App Store), backgrounding the current app.
//
//    }
    
    override func viewWillLayoutSubviews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.runInterstitialAds), name: NSNotification.Name(rawValue: "runInterstitialAds"), object: nil)
        
    }
    
    @objc public func runInterstitialAds() {
        
        if interstitial.isReady == true { interstitial.present(fromRootViewController: self) }
        else { print("Interstitial Ad wasn't ready") }
        
    }
    
}
