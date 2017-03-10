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
    
    fileprivate var watermarkView:UIImageView?
    var selectedVideo:Video? {
        didSet {
            if selectedVideo?.urls.count == 0 {
                self.loadData()
            }
        }
    }
    
    // MARK: - Data
    
    fileprivate func loadData() {
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
    
    func notificationEndPlaying(_ notification: Notification) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Video Player
    
    fileprivate func playVideo() {
        Async.main {
            guard let url = self.selectedVideo?.bestUrl?.url else { return }

            let titleMetadataItem = AVMutableMetadataItem()
            titleMetadataItem.locale = NSLocale.current
            titleMetadataItem.key = AVMetadataCommonKeyTitle
            titleMetadataItem.keySpace = AVMetadataKeySpaceCommon
            titleMetadataItem.value = self.selectedVideo?.snippet?.title
            
            let descriptionMetadataItem = AVMutableMetadataItem()
            descriptionMetadataItem.locale = NSLocale.current
            descriptionMetadataItem.key = AVMetadataCommonKeyDescription
            descriptionMetadataItem.keySpace = AVMetadataKeySpaceCommon
            descriptionMetadataItem.value = self.selectedVideo?.snippet?.description
            
            let mediaItem = AVPlayerItem(url: URL(string: url)!)
            mediaItem.externalMetadata.append(titleMetadataItem)
            mediaItem.externalMetadata.append(descriptionMetadataItem)
            
            // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationEndPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: mediaItem)
            
            self.player = AVPlayer(playerItem: mediaItem)
            self.player?.play()
        }
    }

}
