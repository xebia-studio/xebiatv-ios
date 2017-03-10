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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height - collectionView.contentInset.top - collectionView.contentInset.bottom
        return CGSize(width: height * 16 / 9, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        // Reload data with this video
        let video = self.filteredDataSource[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! VideoCell
        self.selectedVideo = video
        self.selectedVideoImage = cell.videoImageView.image
        self.filterDataSource()
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 100
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(indexPath)
    }
    
    // MARK: - Cell
    
    fileprivate func videoCellAtIndexPath(_ indexPath:IndexPath) -> VideoCell {
        let view = self.view as! DetailsView
        let cell = view.collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier(), for: indexPath) as! VideoCell
        let video = self.filteredDataSource[indexPath.item]
        cell.setup(video)
        
        return cell
    }
    
}
