//
//  HomeViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async

class HomeViewController: UIViewController {

    // MARK: - Variables
    
    internal var menuDataSource:[CategoryProtocol] = []
    internal var selectedBackgroundImage:UIImage?
    internal var videosDataSource:[Video] = []
    internal var selectedVideo:Video?
    
    let SpaceBetweenCells:CGFloat = 100
    let SpaceBetweenLines:CGFloat = 50
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UITableView
        let view = self.view as! HomeView
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.contentInset = UIEdgeInsetsMake(100, 0, 100, 0)
        view.tableView.registerNib(HomeCell.nib(), forCellReuseIdentifier: HomeCell.reuseIdentifier())

        // UICollectionView
        view.collectionView.delegate = self
        view.collectionView.dataSource = self
        view.collectionView.contentInset = UIEdgeInsetsMake(30, SpaceBetweenCells, SpaceBetweenCells, SpaceBetweenCells)
        view.collectionView.registerNib(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    // MARK: - Categories Data
    
    private func loadData() {
        // Categories request
        CategoriesDataAccess.retrieveCategories()
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.populateData(response.categories)
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.clearRefresh()
        }
    }
    
    private func populateData(categories:[CategoryProtocol]) {
        Async.main {
            self.menuDataSource = categories
            self.refreshTableView()
        }
    }
    
    // MARK: - Playlist Data
    
    internal func loadPlaylistData(playlistId:String) {
        // Playlist request
        var parameters = GenericJSON()
        parameters["part"] = "snippet"
        parameters["key"] = Constants.Configuration.YoutubeAPIKey
        parameters["playlistId"] = playlistId
        parameters["maxResults"] = 50
        
        PlaylistDataAccess.retrieveVideos(parameters)
            .success { [weak self] response -> Void in // Populate
                guard let strongSelf = self else { return }
                strongSelf.populatePlaylistData(response)
            }
            .failure { [weak self] (error, isCancelled) -> Void in
                guard let strongSelf = self else { return }
                strongSelf.clearRefresh()
        }
    }
    
    private func populatePlaylistData(videos:[Video]) {
        Async.main {
            self.videosDataSource = videos
            self.refreshCollectionView()
        }
    }
    
    // MARK: - Display
    
    private func refreshTableView() {
        let view = self.view as! HomeView
        view.tableView.reloadData()
        //view.showTableView()
    }
    
    private func refreshCollectionView() {
        let view = self.view as! HomeView
        view.collectionView.reloadData()
        //view.showCollectionView()
    }
    
    private func clearRefresh() {
        //let view = self.view as! HomeView
        //view.showErrorMessage()
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let viewController = segue.destinationViewController as? DetailsViewController where segue.identifier == Constants.Segues.ShowDetails else { return }
        viewController.dataSource = self.videosDataSource
        viewController.selectedVideo = self.selectedVideo
        viewController.selectedVideoImage = self.selectedBackgroundImage
    }
    
}