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
    @IBOutlet weak var contentLabel:UILabel!
    @IBOutlet weak var scrollView:UIScrollView!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Labels
        self.titleLabel.font = UIFont.fontLight(70)
        self.titleLabel.textColor = UIColor.commonPurpleColor()
        self.contentLabel.font = UIFont.fontRegular(30)
        self.contentLabel.textColor = UIColor.commonPurpleColor()
    }
    
    // MARK: - Setters
    
    func setVideo(video:Video?) {
        self.titleLabel.text = video?.snippet?.title
        self.contentLabel.text = video?.snippet?.description
    }
    
}
