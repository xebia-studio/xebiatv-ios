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
    
    var dataSource:[Video] = []
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
        
        let view = self.view as! DetailsView
        
        // UICollectionView
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.contentInset = UIEdgeInsetsMake(10, 50, 10, 50)
        view.collectionView.registerNib(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
        
        // UICollectionViewFlowLayout

        //let effectiveWidth = view.collectionView.frame.width - view.collectionView.contentInset.left - view.collectionView.contentInset.right - view.collectionViewFlowLayout.minimumInteritemSpacing
        //let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsPerLine)
        //view.collectionViewFlowLayout.itemSize = CGSizeMake(width, width * 9 / 16)
        //view.collectionViewFlowLayout.minimumInteritemSpacing = 100
    }
    
    // MARK: - Actions
    
    @IBAction func handlePlay(sender:UIButton) {
        self.performSegueWithIdentifier(Constants.Segues.ShowVideoPlayer, sender: nil)
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let viewController = segue.destinationViewController as? VideoPlayerViewController else { return }
        viewController.selectedVideo = self.selectedVideo
    }
    
}