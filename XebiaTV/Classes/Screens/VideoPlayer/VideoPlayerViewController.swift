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
    
    // MARK: - Data
    
    private func loadData() {
        guard let videoId = self.selectedVideo?.snippet?.resource?.videoId else { return }
        
        // Categories request
        VideoDataAccess.retrieveVideoUrls(videoId)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.selectedVideo?.urls = response
                strongSelf.playVideo()
            }
            .failure { (error, isCancelled) -> Void in }
    }
    
    // MARK: - Notifications
    
    func notificationEndPlaying(notification: NSNotification) {
        self.navigationController?.popViewControllerAnimated(true)
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
            
            // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.notificationEndPlaying), name: AVPlayerItemDidPlayToEndTimeNotification, object: mediaItem)
            
            self.player = AVPlayer(playerItem: mediaItem)
            self.player?.play()
        }
    }

}