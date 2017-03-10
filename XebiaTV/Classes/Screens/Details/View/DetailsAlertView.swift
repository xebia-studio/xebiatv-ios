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
        self.titleLabel.textColor = UIColor.white
        self.contentView.isSelectable = true
        self.contentView.isScrollEnabled = true
        self.contentView.font = UIFont.fontRegular(30)
        self.contentView.textColor = UIColor.white
        self.contentView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouchType.indirect.rawValue as Int)]
    }
    
    // MARK: - Setters
    
    func setVideo(_ video:Video?) {
        self.titleLabel.text = video?.snippet?.title
        self.contentView.text = video?.snippet?.description
    }
    
}
