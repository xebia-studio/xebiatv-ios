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
        
        let videosCount = max(self.videosDataSource?.count ?? 0, self.fundationsDataSource?.count ?? 0)
        return self.nextPageToken != nil ? videosCount + 1 : videosCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let videosDataSource = self.videosDataSource, videosDataSource.count > 0 {
            if let _ = self.nextPageToken, indexPath.item == videosDataSource.count - 1 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: LoadingMoreCell.reuseIdentifier(), for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.reuseIdentifier(), for: indexPath)
            }
        } else if let fundationsDataSource = self.fundationsDataSource, fundationsDataSource.count > 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: FundationCell.reuseIdentifier(), for: indexPath)
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: HomeEmptyCell.reuseIdentifier(), for: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VideoCell, let item = self.videosDataSource?[safe: indexPath.row] {
            cell.setup(item)
            
            if let videosDataSource = self.videosDataSource, indexPath.row == videosDataSource.count - 5 {
                self.loadMoreVideos()
            }
            
        } else if let cell = cell as? FundationCell, let item = self.fundationsDataSource?[safe: indexPath.row] as? Fundation {
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
    
    fileprivate func loadMoreVideos() {
        guard self.isLoading == false, self.nextPageToken != nil else { return }
        
        // Playlist request
        var parameters = GenericJSON()
        parameters["part"] = "snippet" as AnyObject?
        parameters["key"] = Constants.Configuration.YoutubeAPIKey as AnyObject?
        parameters["playlistId"] = self.playlistId as AnyObject?
        parameters["pageToken"] = self.nextPageToken as AnyObject?
        parameters["maxResults"] = 50 as AnyObject?
        
        self.isLoading = true
        PlaylistDataAccess.retrieveVideos(parameters)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.nextPageToken = response.nextPageToken
                strongSelf.insertItems(data: response)
            }
            .failure { (error, isCancelled) -> Void in
                print("### Error while loading more items :(")
            }
            .then { Void in
                self.isLoading = false
            }
    }
    
    fileprivate func insertItems(data: PlaylistData) {
        Async.main {
            self.videosDataSource?.append(contentsOf: data.videos)
            self.collectionView.reloadData()
            
//            self.collectionView.performBatchUpdates({
//                let startIndex = self.videosDataSource?.count ?? 0
//                self.videosDataSource?.append(contentsOf: data.videos)
//                
//                var indexPaths = [IndexPath]()
//                for i in (startIndex..<(startIndex + data.videos.count)) {
//                    indexPaths.append(IndexPath(item: i, section: 0))
//                }
//                
//                self.collectionView.insertItems(at: indexPaths)
//            }, completion: nil)
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
                let videos = response.videos
                if videos.count > 0 {
                    let selectedVideo = SelectedVideo(backgroundImage:nil, video:videos.first!, videos)
                    Async.main {
                        strongSelf.onSelectCallback?(selectedVideo)
                    }
                }
            }
            .failure { (error, isCancelled) -> Void in
                print("Error \(error)  \(parameters)")
        }
    }
    
}
