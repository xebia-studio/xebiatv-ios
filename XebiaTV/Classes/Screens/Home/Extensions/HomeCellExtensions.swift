//
//  HomeCellExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 15/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async

extension HomeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - (CGFloat(Constants.Configuration.NumCellsVisible - 1) * self.spaceBetweenCells)
        let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsVisible)
        
        if self.videosDataSource?.count == 0 && self.fundationsDataSource?.count == 0 {
            return CGSizeMake(effectiveWidth, width * 9 / 16)
        }
        
        return CGSizeMake(width, width * 9 / 16)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.videosDataSource?.count == 0 && self.fundationsDataSource?.count == 0 {
            return 1
        }
        
        return max(self.videosDataSource?.count ?? 0, self.fundationsDataSource?.count ?? 0)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if let videosDataSource = self.videosDataSource where videosDataSource.count > 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath)
        } else if let fundationsDataSource = self.fundationsDataSource where fundationsDataSource.count > 0 {
            return collectionView.dequeueReusableCellWithReuseIdentifier(FundationCell.reuseIdentifier(), forIndexPath: indexPath)
        }
        
        return collectionView.dequeueReusableCellWithReuseIdentifier(HomeEmptyCell.reuseIdentifier(), forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = cell as? VideoCell, item = self.videosDataSource?[indexPath.row] {
            cell.setup(item)
        } else if let cell = cell as? FundationCell, item = self.fundationsDataSource?[indexPath.row] as? Fundation {
            cell.setup(item)
        } else if let cell = cell as? HomeEmptyCell {
            cell.category = self.category?.name
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        
        if let category = self.category where category.isFundation {
            if let fundation = self.fundationsDataSource?[indexPath.item], playlistId = fundation.id {
                self.loadPlaylistData(playlistId)
                return
            }
        }
        
        guard let cell = collectionView.cellForItemAtIndexPath(indexPath) as? VideoCell else { return }
        let image = cell.videoImageView.image
        if let video = self.videosDataSource?[indexPath.item] {
            let selectedVideo = SelectedVideo(backgroundImage:image, video:video, self.videosDataSource)
            self.onSelectCallback?(selectedVideo)
        }
    }
    
    private func loadPlaylistData(playlistId:String) {
        // Playlist request
        var parameters = GenericJSON()
        parameters["part"] = "snippet"
        parameters["key"] = Constants.Configuration.YoutubeAPIKey
        parameters["playlistId"] = playlistId
        parameters["maxResults"] = 50
        
        PlaylistDataAccess.retrieveVideos(parameters)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                if response.count > 0 {
                    let selectedVideo = SelectedVideo(backgroundImage:nil, video:response.first!, response)
                    Async.main {
                        strongSelf.onSelectCallback?(selectedVideo)
                    }
                }
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                print("Error \(error)  \(parameters)")
        }
    }
    
}