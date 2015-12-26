//
//  HomeViewControllersExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, round(UIScreen.mainScreen().bounds.size.height / 2.2))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.menuDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Dequeue a cell from the collection view.
        return collectionView.dequeueReusableCellWithReuseIdentifier(HomeCell.reuseIdentifier(), forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? HomeCell else { fatalError("Expected to display a `HomeCell`.") }
        cell.category = self.menuDataSource[indexPath.section]
        
        // Data still not loaded
        if self.videosDataSource.count <= indexPath.section {
            return
        }

        // Configure the cell.
        let sectionDataItems = self.videosDataSource[indexPath.section]
        cell.videosDataSource = sectionDataItems
        cell.onSelect({ selectedVideo in
            self.selectedIndex = indexPath.section
            self.selectedBackgroundImage = selectedVideo.backgroundImage
            self.selectedVideo = selectedVideo.video
            self.performSegueWithIdentifier(Constants.Segues.ShowDetails, sender: nil)
        })
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let reusableview:UICollectionReusableView
        if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: HomeHeaderCollectionReusableView.reuseIdentifier(), forIndexPath: indexPath)
            reusableview = headerView;
        }  else {
           reusableview = UICollectionReusableView()
        }
        
        return reusableview
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSizeMake(collectionView.bounds.size.width, HomeHeaderCollectionReusableView.cellHeight())
        } else {
            return CGSizeZero
        }
    }
    
}