//
//  PlayerView.swift
//  DemoScrollView
//
//  Created by AyunaLabs on 16/11/21.
//

import AVFoundation
import UIKit

class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var currentTime: String {
        if let duration = player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            
            let secondsText = Int(seconds) % 60
            let minutesText = String(format: "%02d", Int(seconds) / 60)
            return "\(minutesText):\(secondsText)"
        }
        return "00:00"
    }

    // Override UIView property
    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }    
}
