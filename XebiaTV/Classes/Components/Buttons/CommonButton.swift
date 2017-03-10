//
//  CommonButton.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 15/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class CommonButton: UIButton {

    fileprivate var bottomTitle:UILabel = UILabel()
    
    // MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    fileprivate func commonInit() {
        self.bottomTitle.backgroundColor = UIColor.clear
        self.bottomTitle.textColor = UIColor.white
        self.bottomTitle.textAlignment = .center
        self.bottomTitle.alpha = 0.6
        self.bottomTitle.font = UIFont.fontRegular(30)
        self.addSubview(self.bottomTitle)
    }

    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomTitle.alpha = self.isFocused ? 1.0 : 0.6
        })
    }
    
    // MARK: - Setters
    
    func setDescriptiveText(_ content:String) {
        self.bottomTitle.text = content
        self.bottomTitle.sizeToFit()
        self.bottomTitle.frame = CGRect(x: 0, y: self.bounds.height + 14, width: self.bounds.width, height: self.bottomTitle.bounds.height)
        
        self.accessibilityLabel = content
    }
    
}
