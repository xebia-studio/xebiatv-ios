//
//  AbstractCollectionViewCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class AbstractCollectionViewCell: UICollectionViewCell {
 
    class func reuseIdentifier() -> String {
        return self.nameOfClass
    }
    
    class func nib() -> UINib {
        return UINib(nibName: self.reuseIdentifier(), bundle: nil)
    }
    
}
