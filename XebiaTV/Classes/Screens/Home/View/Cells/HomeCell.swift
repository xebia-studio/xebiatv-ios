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
    
    typealias SelectedVideo = (backgroundImage: UIImage?, video: Video, videos: [Video]?)
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var loaderView:NVActivityIndicatorView!
 
    var playlistId: String?
    var nextPageToken: String?
    
    var videosDataSource:[Video]? = nil {
        didSet {
            self.refreshCollectionView()
        }
    }
    
    var fundationsDataSource:[CategoryProtocol]? = nil {
        didSet {
            self.refreshCollectionView()
        }
    }
    
    internal var onSelectCallback: ((SelectedVideo) -> Void)?
    internal var isLoading: Bool = false
    
    let spaceBetweenCells:CGFloat = 100
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Label
        self.titleLabel.font = UIFont.fontLight(60)
        self.titleLabel.textColor = UIColor.commonPurpleColor()
        
        // Loader
        self.loaderView.type = .lineScaleParty
        self.loaderView.color = UIColor.commonPurpleColor()
        self.loaderView.size = CGSize(width: 80, height: 80)
        self.loaderView.startAnimation()
        
        // Collection View
        guard let collectionView = self.collectionView, let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
        collectionView.register(HomeEmptyCell.nib(), forCellWithReuseIdentifier: HomeEmptyCell.reuseIdentifier())
        collectionView.register(FundationCell.nib(), forCellWithReuseIdentifier: FundationCell.reuseIdentifier())
        collectionView.clipsToBounds = false
        layout.sectionInset = UIEdgeInsetsMake(0, self.spaceBetweenCells, 0, self.spaceBetweenCells)
        layout.minimumLineSpacing = self.spaceBetweenCells
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.loaderView.startAnimation()
        self.videosDataSource?.removeAll()
        self.collectionView.reloadData()
    }
    
    // MARK: - Display
    
    func refreshCollectionView() {
        self.loaderView.stopAnimation()
        self.collectionView.reloadData()
    }
    
    // MARK: - Callbacks
    
    func onSelect(_ onSelectCallback: @escaping (SelectedVideo) -> Void) {
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
