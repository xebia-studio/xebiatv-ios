//
//  HomeView.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeView: UIView {

    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var collectionViewContainer:GradientView!
    @IBOutlet weak var collectionViewFlowLayout:UICollectionViewFlowLayout!
 
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Add Mask to collection view container
        let maskLayer = CAGradientLayer()
        maskLayer.anchorPoint = CGPointZero
        maskLayer.startPoint = CGPointMake(0, 0)
        maskLayer.endPoint = CGPointMake(0, 1)
        
        let outerColor = UIColor(white: 1.0, alpha: 0.0)
        let innerColor = UIColor(white: 1.0, alpha: 1.0)
        maskLayer.colors = [outerColor.CGColor, innerColor.CGColor, innerColor.CGColor, outerColor.CGColor]
        maskLayer.locations = [0, 0.15, 1 - 0.15, 1]
        maskLayer.frame = self.bounds
        self.layer.masksToBounds = true
        self.collectionViewContainer.layer.mask = maskLayer
    }
    
}