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
    
    internal var fundationsDataSource:[CategoryProtocol] = []
    internal var menuDataSource:[CategoryProtocol] = []
    internal var selectedIndex:NSInteger = NSIntegerMax
    internal var selectedBackgroundImage:UIImage?
    internal var videosDataSource:[[Video]] = []
    internal var selectedVideo:Video?
    internal var allVideos:[Video]?
    
    fileprivate var currentLoadingIndex:Int = 0
    
    let spaceBetweenCells:CGFloat = 100
    let minimumEdgePadding = CGFloat(90.0)
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = self.view as! HomeView
        guard let collectionView = view.collectionView, let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        collectionView.register(HomeCell.nib(), forCellWithReuseIdentifier: HomeCell.reuseIdentifier())
        collectionView.register(HomeHeaderCollectionReusableView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HomeHeaderCollectionReusableView.reuseIdentifier())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset.bottom = self.minimumEdgePadding - layout.sectionInset.bottom
        
        self.checkReachability()
    }
    
    // MARK: - Reachability
    
    fileprivate func checkReachability() {
        // Reachability
        let reachability = Reachability.init()
        if let reachability = reachability, reachability.isReachable {
            self.loadData()
        } else {
            self.clearRefresh(true)
        }
    }
    
    // MARK: - Categories Data
    
    fileprivate func loadData() {
        // Categories request
        CategoriesDataAccess.retrieveCategories()
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.populateData(response.fundations, categories: response.categories)
                strongSelf.showContent()
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.clearRefresh()
            }
    }
    
    fileprivate func populateData(_ fundations:[CategoryProtocol], categories:[CategoryProtocol]) {
        Async.main {
            self.fundationsDataSource = fundations
            self.menuDataSource = categories
            let view = self.view as! HomeView
            view.collectionView.reloadData()
            
            if categories.count > 0 {
                self.currentLoadingIndex = 0
                let category = categories[0]
                if category.isFundation {
                    self.populatePlaylistData([], addAnyway: true)
                } else {
                    self.loadPlaylistData(category.idString)
                }
            }
        }
    }
    
    // MARK: - Playlist Data
    
    internal func loadPlaylistData(_ playlistId:String) {
        // Playlist request
        var parameters = GenericJSON()
        parameters["part"] = "snippet" as AnyObject?
        parameters["key"] = Constants.Configuration.YoutubeAPIKey as AnyObject?
        parameters["playlistId"] = playlistId as AnyObject?
        parameters["maxResults"] = 50 as AnyObject?
        
        PlaylistDataAccess.retrieveVideos(parameters)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.populatePlaylistData(response)
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.populatePlaylistData([])
            }
    }
    
    fileprivate func populatePlaylistData(_ videos:[Video], addAnyway:Bool = false) {
        Async.main {
            let view = self.view as! HomeView
            if videos.count == 0 && !addAnyway {
                self.menuDataSource.remove(at: self.currentLoadingIndex)
                view.collectionView.deleteSections(IndexSet(integer: self.currentLoadingIndex))
            } else {
                self.videosDataSource.insert(videos, at: self.currentLoadingIndex)
                view.collectionView.reloadSections(IndexSet(integer: self.currentLoadingIndex))
                self.currentLoadingIndex += 1
            }
            
            if self.menuDataSource.count > self.currentLoadingIndex {
                let category = self.menuDataSource[self.currentLoadingIndex]
                self.loadPlaylistData(category.idString)
            }
        }
    }
    
    // MARK: - Display
    
    fileprivate func showContent() {
        Async.main {
            let view = self.view as! HomeView
            view.showContent()
        }
    }
    
    fileprivate func clearRefresh(_ noInternetConnection:Bool = false) {
        Async.main {
            let view = self.view as! HomeView
            view.showErrorMessage(noInternetConnection)
        }
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let viewController = segue.destination as? DetailsViewController, segue.identifier == Constants.Segues.ShowDetails else { return }
        
        viewController.selectedVideo = self.selectedVideo
        viewController.selectedVideoImage = self.selectedBackgroundImage
        
        if self.menuDataSource.count > self.selectedIndex {
            let category = self.menuDataSource[self.selectedIndex]
            viewController.dataSource = self.allVideos ?? []
            viewController.selectedCategory = category
        }
    }
    
}
