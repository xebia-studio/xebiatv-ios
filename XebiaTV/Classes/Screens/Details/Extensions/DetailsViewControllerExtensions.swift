//
//  DetailsViewControllerExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // MARK: - UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let height = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        return CGSizeMake(height * 16 / 9, height)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        // Reload data with this video
        let video = self.dataSource[indexPath.item]
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VideoCell
        self.selectedVideoImage = cell.videoImageView.image
        self.selectedVideo = video
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 100
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(indexPath)
    }
    
    // MARK: - Cell
    
    private func videoCellAtIndexPath(indexPath:NSIndexPath) -> VideoCell {
        let view = self.view as! DetailsView
        let cell = view.collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath) as! VideoCell
        let video = self.dataSource[indexPath.item]
        cell.setup(video)
        
        return cell
    }
    
}
