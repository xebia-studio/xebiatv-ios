//
//  VideoCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async
import Haneke

class VideoCell: AbstractCollectionViewCell {
    
    // MARK: - Variables
    
    fileprivate var video:Video?
    fileprivate var fetcher:NetworkFetcher<UIImage>?
    
    @IBOutlet weak var videoTitle:UILabel!
    @IBOutlet weak var videoContainer:UIView!
    @IBOutlet weak var videoImageView:UIImageView!
    @IBOutlet weak var videoLoader:NVActivityIndicatorView!
    @IBOutlet weak var videoVisualEffectView:UIVisualEffectView!
    @IBOutlet weak var videoContainerBottomConstraint:NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        // Enable parallax effect on the UIImageView when user has the focus on the cell
        self.videoImageView.adjustsImageWhenAncestorFocused = true
        
        // Label
        self.videoTitle.font = UIFont.fontRegular(32)
        
        // Loader
        self.videoLoader.size = CGSize(width: 100, height: 100)
        self.videoLoader.type = NVActivityIndicatorType.ballScaleMultiple
        self.videoLoader.color = UIColor.commonPurpleColor()
        
        // Container
        self.videoContainer.backgroundColor = UIColor.commonPurpleColor(0.75)
        self.videoVisualEffectView.alpha = 0
        self.videoContainer.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.video = nil
        self.videoTitle.text = nil
        self.videoImageView.image = nil
        self.videoImageView.layer.removeAllAnimations()
        self.fetcher?.cancelFetch()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self.video == nil && self.isFocused {
            return
        }
        
        self.updateDisplay()
    }
    
    // MARK: - Display
    
    fileprivate func updateDisplay() {
        if self.isFocused && self.videoContainer.alpha != 0 {
            return
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 14.0, options: UIViewAnimationOptions(), animations: {
            self.videoContainer.alpha = self.isFocused ? 1 : 0
            self.videoVisualEffectView.alpha = self.isFocused ? 1 : 0
            self.videoContainerBottomConstraint.constant = self.isFocused ? 0 : -self.videoContainer.frame.height
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Data
    
    func setup(_ video: Video) {
        self.video = video
        
        if self.isFocused {
            self.updateDisplay()
        }
        
        // Title
        self.videoTitle.text = video.snippet?.title
        
        // Container
        self.videoContainerBottomConstraint.constant = -self.videoContainer.frame.height
        self.layoutIfNeeded()
        
        // Load Picture
        guard let thumbnail = video.snippet?.bestThumbnail else { return }
        let cache = Shared.imageCache
        let URL = Foundation.URL(string: thumbnail.urlString)!
        self.fetcher = NetworkFetcher<UIImage>(URL: URL)
        self.videoLoader.startAnimation()
        
        guard let fetcher = self.fetcher else { return }
        cache.fetch(fetcher: fetcher)
             .onSuccess { [weak self] image in
                Async.main {
                    guard let strongSelf = self /*where fetcher.URL.absoluteString == thumbnail.urlString*/ else { return }
                    strongSelf.videoLoader.stopAnimation()
                    UIView.transition(with: strongSelf.videoImageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        strongSelf.videoImageView.image = image
                        }, completion: nil)
                }
             }
             .onFailure() { [weak self] error in
                guard let strongSelf = self else { return }
                strongSelf.videoImageView.image = nil
             }
    }
    
}
