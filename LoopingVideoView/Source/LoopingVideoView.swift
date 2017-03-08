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
            let url = Bundle.main.url(forResource: fileName as String, withExtension: nil)
            if let url = url {
                play(url, count: playCount)
            }
            else {
                print("LoopingVideoView: Cannot find video \(fileName)")
            }
        }
    }
    
    func play(_ url:URL, count:Int) {
        guard let asset = try? type(of: self).composedAsset(url, count: count) else {
            print("LoopingVideoView: Error loading video from url: \(url)")
            return
        }
        let playerLayer = type(of: self).createPlayerLayer(asset)
        playerLayer.frame = layer.bounds
        layer.addSublayer(playerLayer)
        playerLayer.player?.play()
        self.playerLayer = playerLayer
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        notificationCenter.addObserver(self,
            selector: #selector(LoopingVideoView.videoDidFinish),
            name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
            object: self.playerLayer.player?.currentItem)
    }
    
    func videoDidFinish() {
        playerLayer.player?.seek(to: CMTimeMake(0, 600))
        playerLayer.player?.play()
    }
    
    class func composedAsset(_ url:URL, count:Int) throws -> AVAsset {
        let videoAsset = AVURLAsset(url: url, options: nil)
        let videoRange = CMTimeMake(videoAsset.duration.value, videoAsset.duration.timescale)
        let range = CMTimeRangeMake(CMTimeMake(0, 600), videoRange)
        let finalAsset = AVMutableComposition()
        
        for _ in 0..<count {
            try finalAsset.insertTimeRange(range,
                of: videoAsset,
                at: finalAsset.duration)
        }
        
        return finalAsset;
    }
    
    class func createPlayerLayer(_ asset:AVAsset) -> AVPlayerLayer {
        let playerItem = AVPlayerItem(asset: asset)
        let player = AVPlayer(playerItem: playerItem)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        return playerLayer;
    }
    
}

