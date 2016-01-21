//
//  LoopingVideoView.swift
//  LoopingVideoView
//
//  Created by Gustavo Barcena on 4/11/15.
//
//

import UIKit
import AVFoundation

@IBDesignable class LoopingVideoView2: UIView {
    @IBInspectable var mainBundleFileName : NSString?
    
    var player1: AVPlayer = AVPlayer()
    var player2: AVPlayer = AVPlayer()
    var playerLayer : AVPlayerLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let fileName = mainBundleFileName {
            let url = NSBundle.mainBundle().URLForResource(fileName as String, withExtension: nil)
            if let url = url {
                play(url)
            }
            else {
                print("LoopingVideoView: Cannot find video \(fileName)")
            }
        }
    }
    
    func play(url:NSURL) {
        player1.pause()
        player2.pause()
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
        
        let asset = AVURLAsset(URL: url, options: nil)
        let playerLayer = self.dynamicType.createPlayerLayer(asset)
        playerLayer.frame = layer.bounds
        layer.addSublayer(playerLayer)
        playerLayer.player?.play()
        player1 = playerLayer.player!
        registerForFinishedPlayingNotification(player1)
        self.playerLayer = playerLayer
        
        player2 = self.dynamicType.createPlayer(asset)
        registerForFinishedPlayingNotification(player2)
        player2.play()
        player2.pause()
        player2.seekToTime(CMTimeMake(0, 600))
    }
    
    func videoDidFinish() {
        print("Playing Finished  \(playerLayer?.player)")
        let oldPlayer = playerLayer?.player!
        oldPlayer?.pause()
        if oldPlayer == player1 {
            playerLayer?.player = player2
        }
        else {
            playerLayer?.player = player1
        }
        print("About to play with \(playerLayer?.player)")
        playerLayer?.player?.play()
        oldPlayer?.seekToTime(CMTimeMake(0, 600))
    }
    
    class func createPlayer(asset:AVAsset) -> AVPlayer {
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        return player;
    }
    
    class func createPlayerLayer(asset:AVAsset) -> AVPlayerLayer {
        let player = createPlayer(asset)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerLayer;
    }
    
    func registerForFinishedPlayingNotification(player:AVPlayer) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self,
            selector: "videoDidFinish",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: player.currentItem)
    }
    
}
