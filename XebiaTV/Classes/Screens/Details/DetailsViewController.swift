//
//  DetailsViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    // MARK: - Variables
    
    var selectedCategory:CategoryProtocol? {
        didSet {
            let view = self.view as! DetailsView
            view.setCategory(selectedCategory?.name)
        }
    }
    var dataSource:[Video] = [] {
        didSet {
            self.filterDataSource()
        }
    }
    internal var filteredDataSource:[Video] = []
    var selectedVideoImage:UIImage? {
        didSet {
            let view = self.view as! DetailsView
            view.setImage(selectedVideoImage)
        }
    }
    var selectedVideo:Video? {
        didSet {
            let view = self.view as! DetailsView
            view.updateDisplay(selectedVideo)
        }
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UICollectionView
        let view = self.view as! DetailsView
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.contentInset = UIEdgeInsetsMake(100, 50, 50, 50)
        view.collectionView.registerNib(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
    }
    
    // MARK: - Data
    
    internal func filterDataSource() {
        guard let selectedVideo = self.selectedVideo else { return }
        self.filteredDataSource = self.dataSource.arrayRemovingObject(selectedVideo)
        
        let view = self.view as! DetailsView
        UIView.performWithoutAnimation {
            view.collectionView.reloadSections(NSIndexSet(index: 0))
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let viewController = segue.destinationViewController as? VideoPlayerViewController else { return }
        viewController.selectedVideo = self.selectedVideo
    }
    
}