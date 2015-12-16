//
//  HomeCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeCell: AbstractCollectionViewCell {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
 
    var videosDataSource:[Video] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    let spaceBetweenCells:CGFloat = 100
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Label
        self.titleLabel.font = UIFont.fontLight(60)
        self.titleLabel.textColor = UIColor.commonPurpleColor()
        
        // Collection View
        guard let collectionView = self.collectionView, layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.registerNib(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
        collectionView.clipsToBounds = false
        layout.sectionInset = UIEdgeInsetsMake(0, self.spaceBetweenCells, 0, self.spaceBetweenCells)
        layout.minimumLineSpacing = self.spaceBetweenCells
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.videosDataSource.removeAll()
        self.collectionView.reloadData()
    }
    
    var category:CategoryProtocol? = nil {
        didSet {
            guard let category = category else { return }
            self.titleLabel.text = category.name
        }
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        
    }
    
}