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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: round(UIScreen.main.bounds.size.height / 2.2))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.menuDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue a cell from the collection view.
        return collectionView.dequeueReusableCell(withReuseIdentifier: HomeCell.reuseIdentifier(), for: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? HomeCell else { fatalError("Expected to display a `HomeCell`.") }
        let category = self.menuDataSource[indexPath.section]
        cell.category = category
        
        // Data still not loaded
        if category.isFundation && self.fundationsDataSource.count <= indexPath.section {
            return
        } else if !category.isFundation && self.videosDataSource.count <= indexPath.section {
            return
        }

        // Configure the cell.
        if category.isFundation {
            cell.fundationsDataSource = self.fundationsDataSource
        } else {
            let sectionDataItems = self.videosDataSource[indexPath.section]
            if let category = category as? Category {
                cell.nextPageToken = category.nextPageToken
            } else {
                cell.nextPageToken = nil
            }
            
            cell.playlistId = category.idString
            cell.videosDataSource = sectionDataItems
        }
        cell.onSelect({ selectedVideo in
            self.selectedIndex = indexPath.section
            self.selectedBackgroundImage = selectedVideo.backgroundImage
            self.selectedVideo = selectedVideo.video
            self.allVideos = selectedVideo.videos
            self.performSegue(withIdentifier: Constants.Segues.ShowDetails, sender: nil)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let reusableview:UICollectionReusableView
        if (kind == UICollectionElementKindSectionHeader && indexPath.section == 0) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeHeaderCollectionReusableView.reuseIdentifier(), for: indexPath)
            reusableview = headerView;
        }  else {
           reusableview = UICollectionReusableView()
        }
        
        return reusableview
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (section == 0) {
            return CGSize(width: collectionView.bounds.size.width, height: HomeHeaderCollectionReusableView.cellHeight())
        } else {
            return CGSize.zero
        }
    }
    
}
