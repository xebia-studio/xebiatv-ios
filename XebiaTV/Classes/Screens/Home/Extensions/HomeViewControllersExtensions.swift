//
//  HomeViewControllersExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - (CGFloat(Constants.Configuration.NumCellsPerLine - 1) * self.spaceBetweenCells)
        let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsPerLine)
        return CGSizeMake(width, width * 9 / 16)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VideoCell
        self.selectedBackgroundImage = cell.videoImageView.image
        
        guard let index = self.collectionViews.indexOf(collectionView) else { return }
        self.selectedIndex = index
        self.selectedVideo = self.videosDataSource[index][indexPath.item]
        self.performSegueWithIdentifier(Constants.Segues.ShowDetails, sender: nil)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.spaceBetweenCells
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.spaceBetweenCells
    }

    // MARK: - UICollectionView DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let index = self.collectionViews.indexOf(collectionView) else { return 0 }
        return max(self.videosDataSource[index].count, 1)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(collectionView, indexPath: indexPath)
    }
    
    // MARK: - Cell
    
    private func videoCellAtIndexPath(collectionView:UICollectionView, indexPath:NSIndexPath) -> VideoCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath) as! VideoCell
        if let index = self.collectionViews.indexOf(collectionView) where self.videosDataSource[index].count > indexPath.item {
            let video = self.videosDataSource[index][indexPath.item]
            cell.setup(video)
        }
        
        return cell
    }
    
}