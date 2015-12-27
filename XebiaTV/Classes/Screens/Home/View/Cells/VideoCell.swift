//
//  VideoCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async

class VideoCell: AbstractCollectionViewCell {
    
    // MARK: - Variables
    
    private var video:Video?
    private var fetcher:NetworkFetcher<UIImage>?
    
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
        self.videoTitle.font = UIFont.fontRegular(26)
        
        // Loader
        self.videoLoader.size = CGSizeMake(100, 100)
        self.videoLoader.type = NVActivityIndicatorType.BallScaleMultiple
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
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        if self.video == nil && self.focused {
            return
        }
        
        self.updateDisplay()
    }
    
    // MARK: - Display
    
    private func updateDisplay() {
        if self.focused && self.videoContainer.alpha != 0 {
            return
        }
        
        UIView.animateWithDuration(0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 14.0, options: .CurveEaseInOut, animations: {
            self.videoContainer.alpha = self.focused ? 1 : 0
            self.videoVisualEffectView.alpha = self.focused ? 1 : 0
            self.videoContainerBottomConstraint.constant = self.focused ? 0 : -self.videoContainer.frame.height
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: - Data
    
    func setup(video: Video) {
        self.video = video
        guard let thumbnail = video.snippet?.bestThumbnail else { return }
        
        if self.focused {
            self.updateDisplay()
        }
        
        // Title
        self.videoTitle.text = video.snippet?.title
        
        // Container
        self.videoContainerBottomConstraint.constant = -self.videoContainer.frame.height
        self.layoutIfNeeded()
        
        // Load Picture
        let cache = Shared.imageCache
        let URL = NSURL(string: thumbnail.urlString)!
        self.fetcher = NetworkFetcher<UIImage>(URL: URL)
        self.videoLoader.startAnimation()
        
        guard let fetcher = self.fetcher else { return }
        cache.fetch(fetcher: fetcher)
             .onSuccess { [weak self] image in
                Async.main {
                    guard let strongSelf = self where fetcher.URL.absoluteString == thumbnail.urlString  else { return }
                    strongSelf.videoLoader.stopAnimation()
                    UIView.transitionWithView(strongSelf.videoImageView, duration: 0.25, options: [.TransitionCrossDissolve], animations: {
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
