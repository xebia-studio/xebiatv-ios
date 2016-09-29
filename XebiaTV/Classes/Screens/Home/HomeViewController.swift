//
//  HomeViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async
import ReachabilitySwift

class HomeViewController: UIViewController {

    // MARK: - Variables
    
    internal var menuDataSource:[CategoryProtocol] = []
    internal var selectedIndex:NSInteger = NSIntegerMax
    internal var selectedBackgroundImage:UIImage?
    internal var videosDataSource:[[Video]] = []
    internal var selectedVideo:Video?
    
    let spaceBetweenCells:CGFloat = 100
    let minimumEdgePadding = CGFloat(90.0)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! HomeView
        guard let collectionView = view.collectionView, layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.registerNib(HomeCell.nib(), forCellWithReuseIdentifier: HomeCell.reuseIdentifier())
        collectionView.registerNib(HomeHeaderCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.reuseIdentifier())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = self.minimumEdgePadding - layout.sectionInset.bottom
        
        self.checkReachability()
    }
    
    // MARK: - Reachability
    
    private func checkReachability() {
        // Reachability
        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
            if reachability.isReachable() {
                self.loadData()
            } else {
                self.clearRefresh(true)
            }
        } catch {
            self.clearRefresh(true)
            return
        }
    }
    
    // MARK: - Categories Data
    
    private func loadData() {
        // Categories request
        CategoriesDataAccess.retrieveCategories()
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.populateData(response.categories)
                strongSelf.showContent()
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.clearRefresh()
            }
    }
    
    private func populateData(categories:[CategoryProtocol]) {
        Async.main {
            self.menuDataSource = categories
            let view = self.view as! HomeView
            view.collectionView.reloadData()

            var index = 0
            for category in categories {
                if index == 0 {
                    self.loadPlaylistData(index, playlistId: category.idString)
                }

                index += 1
            }            
        }
    }
    
    // MARK: - Playlist Data
    
    internal func loadPlaylistData(index:NSInteger, playlistId:String) {
        // Playlist request
        var parameters = GenericJSON()
        parameters["part"] = "snippet"
        parameters["key"] = Constants.Configuration.YoutubeAPIKey
        parameters["playlistId"] = playlistId
        parameters["maxResults"] = 50
        
        PlaylistDataAccess.retrieveVideos(parameters)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.populatePlaylistData(index, videos: response)
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.populatePlaylistData(index, videos: [])
            }
            .then { [weak self] _ in
                guard let strongSelf = self else { return }
                let nextIndex = index + 1
                if strongSelf.menuDataSource.count > nextIndex {
                    let category = strongSelf.menuDataSource[nextIndex]
                    strongSelf.loadPlaylistData(nextIndex, playlistId: category.idString)
                }
            }
    }
    
    private func populatePlaylistData(index:NSInteger, videos:[Video]) {
        Async.main {
            self.videosDataSource.insert(videos, atIndex: index)
            
            let view = self.view as! HomeView
            view.collectionView.reloadSections(NSIndexSet(index: index))
        }
    }
    
    // MARK: - Display
    
    private func showContent() {
        Async.main {
            let view = self.view as! HomeView
            view.showContent()
        }
    }
    
    private func clearRefresh(noInternetConnection:Bool = false) {
        Async.main {
            let view = self.view as! HomeView
            view.showErrorMessage(noInternetConnection)
        }
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let viewController = segue.destinationViewController as? DetailsViewController where segue.identifier == Constants.Segues.ShowDetails else { return }
        
        viewController.selectedVideo = self.selectedVideo
        viewController.selectedVideoImage = self.selectedBackgroundImage
        
        if self.menuDataSource.count > self.selectedIndex {
            viewController.dataSource = self.videosDataSource[self.selectedIndex]
            viewController.selectedCategory = self.menuDataSource[self.selectedIndex]
        }
    }
    
}