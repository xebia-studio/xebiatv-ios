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
    
    fileprivate var watermarkView: UIImageView?
    var selectedVideo: Video? {
        didSet {
            if selectedVideo?.urls.count == 0 {
                self.loadData()
            }
        }
    }
    
    var posterImage: UIImage?
    
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
            titleMetadataItem.identifier = AVMetadataCommonKeyTitle
            titleMetadataItem.keySpace = AVMetadataKeySpaceCommon
            titleMetadataItem.value = self.selectedVideo?.snippet?.title as? (NSCopying & NSObjectProtocol)
            
            let descriptionMetadataItem = AVMutableMetadataItem()
            descriptionMetadataItem.locale = NSLocale.current
            descriptionMetadataItem.identifier = AVMetadataCommonKeyDescription
            descriptionMetadataItem.keySpace = AVMetadataKeySpaceCommon
            descriptionMetadataItem.value = self.selectedVideo?.snippet?.description as? (NSCopying & NSObjectProtocol)
            
            let mediaItem = AVPlayerItem(url: URL(string: url)!)
            mediaItem.externalMetadata.append(titleMetadataItem)
            mediaItem.externalMetadata.append(descriptionMetadataItem)
            
            if let posterImage = self.posterImage {
                let pictureMetadataItem = AVMutableMetadataItem()
                pictureMetadataItem.locale = NSLocale.current
                pictureMetadataItem.value = UIImageJPEGRepresentation(posterImage, 0.85) as? (NSCopying & NSObjectProtocol)
                pictureMetadataItem.dataType = kCMMetadataBaseDataType_PNG as String
                pictureMetadataItem.identifier = AVMetadataCommonIdentifierArtwork
                mediaItem.externalMetadata.append(pictureMetadataItem)
            }
            
            // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
            NotificationCenter.default.addObserver(self, selector: #selector(self.notificationEndPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: mediaItem)
            
            self.player = AVPlayer(playerItem: mediaItem)
            self.player?.play()
        }
    }

}
