//
//  DetailsAlertView.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 03/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class DetailsAlertView: UIView {

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var contentView:UITextView!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Labels
        self.titleLabel.font = UIFont.fontLight(70)
        self.titleLabel.textColor = UIColor.whiteColor()
        self.contentView.selectable = true
        self.contentView.scrollEnabled = true
        self.contentView.font = UIFont.fontRegular(30)
        self.contentView.textColor = UIColor.whiteColor()
        self.contentView.panGestureRecognizer.allowedTouchTypes = [NSNumber(integer: UITouchType.Indirect.rawValue)]
    }
    
    // MARK: - Setters
    
    func setVideo(video:Video?) {
        self.titleLabel.text = video?.snippet?.title
        self.contentView.text = video?.snippet?.description
    }
    
}
