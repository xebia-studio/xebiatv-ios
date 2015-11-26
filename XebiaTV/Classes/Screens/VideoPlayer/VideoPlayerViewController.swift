//
//  ViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import AVKit
import Async

class VideoPlayerViewController: AVPlayerViewController {

    // MARK: - Variables
    
    var selectedVideo:Video? {
        didSet {
            if selectedVideo?.urls.count == 0 {
                self.loadData()
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let watermark = UIImageView(image: UIImage(named: "logo_xebia"))
        self.contentOverlayView?.addSubview(watermark)
    }
    
    // MARK: - Data
    
    private func loadData() {
        guard let videoId = self.selectedVideo?.snippet?.resourceId?.videoId else { return }
        
        // Categories request
        VideoDataAccess.retrieveVideoUrls(videoId)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.selectedVideo?.urls = response
                strongSelf.playVideo()
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                //strongSelf.clearRefresh()
        }
    }
    
    // MARK: - Video Player
    
    private func playVideo() {
        Async.main {
            guard let url = self.selectedVideo?.bestUrl?.url else { return }
            self.player = AVPlayer(URL: NSURL(string: url)!)
            self.player?.play()
        }
    }

}