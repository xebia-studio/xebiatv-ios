//
//  HomeHeaderCollectionReusableView.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 16/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeHeaderCollectionReusableView: UICollectionReusableView {

    class func reuseIdentifier() -> String {
        return self.nameOfClass
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier(), bundle: nil)
    }
    
}