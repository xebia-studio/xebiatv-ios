//
//  FundationCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 17/10/2016.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async
import Haneke

enum FundationType:String {
    case Agile = "IconAgile"
    case Back = "IconBack"
    case Cloud = "IconCloud"
    case Craft = "IconCraft"
    case Data  = "IconData"
    case DevOps = "IconDevOps"
    case Front = "IconFront"
    case IoT = "IconIoT"
    case Mobile = "IconMobile"
    
    static func imageNameForType(_ typeName: String?) -> FundationType? {
        if typeName == "Agile" {
            return .Agile
        } else if typeName == "Back" {
            return .Back
        } else if typeName == "Cloud" {
            return .Cloud
        } else if typeName == "Craft" {
            return .Craft
        } else if typeName == "Data" {
            return .Data
        } else if typeName == "DevOps" {
            return .DevOps
        } else if typeName == "Front" {
            return .Front
        } else if typeName == "IoT" {
            return .IoT
        } else if typeName == "Mobile" {
            return .Mobile
        }
        
        return nil
    }
}

class FundationCell: AbstractCollectionViewCell {
    
    // MARK: - Variables
    
    fileprivate var fundation:Fundation?
    
    @IBOutlet weak var fundationTitle:UILabel!
    @IBOutlet weak var fundationContainer:UIView!
    @IBOutlet weak var fundationIconView:UIImageView!
    @IBOutlet weak var fundationVisualEffectView:UIVisualEffectView!
    @IBOutlet weak var fundationContainerBottomConstraint:NSLayoutConstraint!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        // Enable parallax effect on the UIImageView when user has the focus on the cell
        self.fundationIconView.adjustsImageWhenAncestorFocused = false
        
        // Label
        self.fundationTitle.font = UIFont.fontRegular(32)
        
        // Container
        self.fundationContainer.backgroundColor = UIColor(fullRed: 0, fullGreen: 0, fullBlue: 0, alpha: 0.75)
        self.fundationVisualEffectView.alpha = 0
        self.fundationContainer.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.fundation = nil
        self.fundationTitle.text = nil
        self.fundationIconView.image = nil
        self.fundationIconView.layer.removeAllAnimations()
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if self.fundation == nil && self.isFocused {
            return
        }
        
        self.updateDisplay()
    }
    
    // MARK: - Display
    
    fileprivate func updateDisplay() {
        if self.isFocused && self.fundationContainer.alpha != 0 {
            return
        }
        
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 14.0, options: UIViewAnimationOptions(), animations: {
            self.fundationContainer.alpha = self.isFocused ? 1 : 0
            self.fundationVisualEffectView.alpha = self.isFocused ? 1 : 0
            self.fundationContainerBottomConstraint.constant = self.isFocused ? 0 : -self.fundationContainer.frame.height
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: - Data
    
    func setup(_ fundation: Fundation) {
        self.fundation = fundation
        
        if let backgroundColor = fundation.color {
            self.fundationIconView.backgroundColor = UIColor(rgba: backgroundColor)
        }
        
        if self.isFocused {
            self.updateDisplay()
        }
        
        // Title
        self.fundationTitle.text = fundation.name
        
        // Icon
        if let fundationType = FundationType.imageNameForType(fundation.name) {
            self.fundationIconView.image = UIImage(named: fundationType.rawValue)
        }
        
        // Container
        self.fundationContainerBottomConstraint.constant = -self.fundationContainer.frame.height
        self.layoutIfNeeded()
    }
    
}
