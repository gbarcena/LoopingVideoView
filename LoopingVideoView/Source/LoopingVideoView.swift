//
//  LoopingVideoView2.swift
//  LoopingVideoView
//
//  Created by Gustavo Barcena on 4/12/15.
//
//

import UIKit
import AVFoundation

@IBDesignable class LoopingVideoView: UIView {
    @IBInspectable var mainBundleFileName : NSString?
    var playCount: Int = 100
    var playerLayer = AVPlayerLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let fileName = mainBundleFileName {
            let url = NSBundle.mainBundle().URLForResource(fileName as String, withExtension: nil)
            if let url = url {
                play(url, count: playCount)
            }
            else {
                print("LoopingVideoView: Cannot find video \(fileName)")
            }
        }
    }
    
    func play(url:NSURL, count:Int) {
        guard let asset = try? self.dynamicType.composedAsset(url, count: count) else {
            print("LoopingVideoView: Error loading video from url: \(url)")
            return
        }
        let playerLayer = self.dynamicType.createPlayerLayer(asset)
        playerLayer.frame = layer.bounds
        layer.addSublayer(playerLayer)
        playerLayer.player?.play()
        self.playerLayer = playerLayer
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
        notificationCenter.addObserver(self,
            selector: "videoDidFinish",
            name: AVPlayerItemDidPlayToEndTimeNotification,
            object: self.playerLayer.player?.currentItem)
    }
    
    func videoDidFinish() {
        playerLayer.player?.seekToTime(CMTimeMake(0, 600))
        playerLayer.player?.play()
    }
    
    class func composedAsset(url:NSURL, count:Int) throws -> AVAsset {
        let videoAsset = AVURLAsset(URL: url, options: nil)
        let videoRange = CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale)
        let range = CMTimeRangeMake(CMTimeMake(0, 600), videoRange)
        let finalAsset = AVMutableComposition()
        
        for _ in 0..<count {
            try finalAsset.insertTimeRange(range,
                ofAsset: videoAsset,
                atTime: finalAsset.duration)
        }
        
        return finalAsset;
    }
    
    class func createPlayerLayer(asset:AVAsset) -> AVPlayerLayer {
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerLayer;
    }
    
}

