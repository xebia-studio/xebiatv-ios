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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - (CGFloat(Constants.Configuration.NumCellsVisible - 1) * self.spaceBetweenCells)
        let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsVisible)
        
        if self.videosDataSource?.count == 0 && self.fundationsDataSource?.count == 0 {
            return CGSize(width: effectiveWidth, height: width * 9 / 16)
        }
        
        return CGSize(width: width, height: width * 9 / 16)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.videosDataSource?.count == 0 && self.fundationsDataSource?.count == 0 {
            return 1
        }
        
        return max(self.videosDataSource?.count ?? 0, self.fundationsDataSource?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let videosDataSource = self.videosDataSource, videosDataSource.count > 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier(), for: indexPath)
        } else if let fundationsDataSource = self.fundationsDataSource, fundationsDataSource.count > 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: FundationCell.reuseIdentifier(), for: indexPath)
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: HomeEmptyCell.reuseIdentifier(), for: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoCell, let item = self.videosDataSource?[indexPath.row] {
            cell.setup(item)
        } else if let cell = cell as? FundationCell, let item = self.fundationsDataSource?[indexPath.row] as? Fundation {
            cell.setup(item)
        } else if let cell = cell as? HomeEmptyCell {
            cell.category = self.category?.name
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        
        if let category = self.category, category.isFundation {
            if let fundation = self.fundationsDataSource?[indexPath.item], let playlistId = fundation.id {
                self.loadPlaylistData(playlistId)
                return
            }
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? VideoCell else { return }
        let image = cell.videoImageView.image
        if let video = self.videosDataSource?[indexPath.item] {
            let selectedVideo = SelectedVideo(backgroundImage:image, video:video, self.videosDataSource)
            self.onSelectCallback?(selectedVideo)
        }
    }
    
    fileprivate func loadPlaylistData(_ playlistId:String) {
        // Playlist request
        var parameters = GenericJSON()
        parameters["part"] = "snippet" as AnyObject?
        parameters["key"] = Constants.Configuration.YoutubeAPIKey as AnyObject?
        parameters["playlistId"] = playlistId as AnyObject?
        parameters["maxResults"] = 50 as AnyObject?
        
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
