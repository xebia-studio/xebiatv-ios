//
//  CommonButton.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 15/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class CommonButton: UIButton {

    private var bottomTitle:UILabel = UILabel()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        self.bottomTitle.backgroundColor = UIColor.clearColor()
        self.bottomTitle.textColor = UIColor.whiteColor()
        self.bottomTitle.textAlignment = .Center
        self.bottomTitle.alpha = 0.6
        self.bottomTitle.font = UIFont.fontRegular(30)
        self.addSubview(self.bottomTitle)
    }

    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
        UIView.animateWithDuration(0.25, animations: {
            self.bottomTitle.alpha = self.focused ? 1.0 : 0.6
        })
    }
    
    // MARK: - Setters
    
    func setDescriptiveText(content:String) {
        self.bottomTitle.text = content
        self.bottomTitle.sizeToFit()
        self.bottomTitle.frame = CGRectMake(0, self.bounds.height + 14, self.bounds.width, self.bottomTitle.bounds.height)
        
        self.accessibilityLabel = content
    }
    
}
