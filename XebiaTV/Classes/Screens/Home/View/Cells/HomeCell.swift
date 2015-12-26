//
//  HomeCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeCell: AbstractCollectionViewCell {

    // MARK: - Variables
    
    typealias SelectedVideo = (backgroundImage: UIImage?, video: Video)
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
 
    var videosDataSource:[Video] = [] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    internal var onSelectCallback: (SelectedVideo -> Void)?
    
    let spaceBetweenCells:CGFloat = 100
    
    // MARK: - LifeCycle
    
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
        collectionView.registerNib(HomeEmptyCell.nib(), forCellWithReuseIdentifier: HomeEmptyCell.reuseIdentifier())
        collectionView.clipsToBounds = false
        layout.sectionInset = UIEdgeInsetsMake(0, self.spaceBetweenCells, 0, self.spaceBetweenCells)
        layout.minimumLineSpacing = self.spaceBetweenCells
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.videosDataSource.removeAll()
        self.collectionView.reloadData()
    }
    
    // MARK: - Callbacks
    
    func onSelect(onSelectCallback: SelectedVideo -> Void) {
        self.onSelectCallback = onSelectCallback
    }
    
    // MARK: - Setters
    
    var category:CategoryProtocol? = nil {
        didSet {
            guard let category = category else { return }
            self.titleLabel.text = category.name
        }
    }
    
}