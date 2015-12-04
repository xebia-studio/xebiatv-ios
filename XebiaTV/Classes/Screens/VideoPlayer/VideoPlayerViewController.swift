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

    // MARK: - Constants
    
    let watermarkOffset:CGFloat = 50.0
    
    // MARK: - Variables
    
    private var watermarkView:UIImageView?
    var selectedVideo:Video? {
        didSet {
            if selectedVideo?.urls.count == 0 {
                self.loadData()
            }
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Watermark
        /*self.watermarkView = UIImageView(image: UIImage(named: "logo_xebia"))
        self.watermarkView?.alpha = 0
        
        guard let watermarkView = self.watermarkView, contentOverlayView = self.contentOverlayView else { return }
        self.contentOverlayView?.addSubview(watermarkView)
        watermarkView.frame = CGRectMake(self.watermarkOffset, contentOverlayView.frame.height - watermarkView.bounds.height - self.watermarkOffset, watermarkView.bounds.width, watermarkView.bounds.height)
        UIView.animateWithDuration(0.25, animations: {
            watermarkView.alpha = 0.75
        })*/
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
            .failure { /*[weak self]*/ (error, isCancelled) -> Void in
                //guard let strongSelf = self else { return }
                //strongSelf.clearRefresh()
        }
    }
    
    // MARK: - Video Player
    
    private func playVideo() {
        Async.main {
            guard let url = self.selectedVideo?.bestUrl?.url else { return }

            let titleMetadataItem = AVMutableMetadataItem()
            titleMetadataItem.locale = NSLocale.currentLocale()
            titleMetadataItem.key = AVMetadataCommonKeyTitle
            titleMetadataItem.keySpace = AVMetadataKeySpaceCommon
            titleMetadataItem.value = self.selectedVideo?.snippet?.title
            
            let descriptionMetadataItem = AVMutableMetadataItem()
            descriptionMetadataItem.locale = NSLocale.currentLocale()
            descriptionMetadataItem.key = AVMetadataCommonKeyDescription
            descriptionMetadataItem.keySpace = AVMetadataKeySpaceCommon
            descriptionMetadataItem.value = self.selectedVideo?.snippet?.description
            
            let mediaItem = AVPlayerItem(URL: NSURL(string: url)!)
            mediaItem.externalMetadata.append(titleMetadataItem)
            mediaItem.externalMetadata.append(descriptionMetadataItem)
            
            self.player = AVPlayer(playerItem: mediaItem)
            self.player?.play()
        }
    }

}