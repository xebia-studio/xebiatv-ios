//
//  VideoCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class VideoCell: AbstractCollectionViewCell {
    
    @IBOutlet weak var videoImageView:UIImageView!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        // Enable parallax effect on the UIImageView when user has the focus on the cell
        self.videoImageView.adjustsImageWhenAncestorFocused = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.videoImageView.image = nil
    }
    
    // MARK: - Data
    
    func setup(video: Video) {
        guard let thumbnail = video.snippet?.bestThumbnail else { return }
        
        // Load Picture
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
            if let data = NSData(contentsOfURL: NSURL(string: thumbnail.urlString)!) {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    UIView.transitionWithView(self.videoImageView, duration: 0.25, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                            self.videoImageView.image = UIImage(data: data)
                        }, completion: nil)
                })
            }
        })
    }
    
}
