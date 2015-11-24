//
//  ViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import AVKit
import HCYoutubeParser

class VideoPlayerViewController: AVPlayerViewController {

    // MARK: - Properties
    
    let watermarkView:UIImageView = UIImageView(image: UIImage(named:"logo_xebia"))

    // MARK: - Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setVideoPlayer()
    }
    
    // MARK: - Video Player
    
    func setVideoPlayer() {
        // Overlay
        self.watermarkView.frame = CGRectMake(50, 50, self.watermarkView.bounds.width, self.watermarkView.bounds.height)
        self.watermarkView.alpha = 0.5
        self.contentOverlayView?.addSubview(self.watermarkView)
        
        // AVPlayer Instance with NSURL
        let videos = HCYoutubeParser.h264videosWithYoutubeURL(NSURL(string:"https://www.youtube.com/watch?v=TxfXs7jOYgo")!)
        XBLog("Videos : \(videos)")
        
        guard let url = videos["hd720"] as? String else { return }
        self.player = AVPlayer(URL: NSURL(string: url)!)
        self.player?.play()
    }

}