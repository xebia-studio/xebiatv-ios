//
//  HomeEmptyCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeEmptyCell: AbstractCollectionViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.titleLabel.backgroundColor = UIColor.commonPurpleColor(0.75)
        self.titleLabel.font = UIFont.fontLight(38)
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        let scale:CGFloat = 1.2
        
        if context.nextFocusedView == self {
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                self.transform = CGAffineTransformMakeScale(scale, scale)
                
                }, completion: nil)
        }
        else {
            coordinator.addCoordinatedAnimations({ () -> Void in
                
                self.transform = CGAffineTransformIdentity
                
                }, completion: nil)
        }
    }

    // MARK: - Setters
    
    var category:String? {
        didSet {
            guard let category = category else { return }
            self.titleLabel.text = String(format: "EMPTY_CATEGORY".localized, category)
        }
    }
    
}
