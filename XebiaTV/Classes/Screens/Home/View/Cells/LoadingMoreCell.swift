//
//  LoadingMoreCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 31/03/2017.
//  Copyright © 2017 Xebia. All rights reserved.
//

import UIKit

class LoadingMoreCell: AbstractCollectionViewCell {
    
    @IBOutlet weak var loaderView:NVActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.loaderView.type = .ballPulse
        self.loaderView.color = UIColor.commonPurpleColor()
        self.loaderView.size = CGSize(width: 80, height: 80)
        self.loaderView.startAnimation()
    }
    
}
