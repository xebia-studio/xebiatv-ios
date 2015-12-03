//
//  HomeView.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeView: UIView {

    @IBOutlet weak var scrollView:UIScrollView!
    @IBOutlet weak var scrollViewContent:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.scrollView.panGestureRecognizer.allowedTouchTypes = [NSNumber(integer: UITouchType.Indirect.rawValue)]
    }
    
}