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

    //MARK: - Variables
    
    internal var dataSource:[CategoryProtocol] = []
    let numCellsPerLine = 2.0
    let numVideos = 10
    
    //MARK: - LifeCycle
    
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
        view.collectionView.contentInset = UIEdgeInsetsMake(30, 100, 100, 100)
        view.collectionView.registerNib(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
        
        //UICollectionViewFlowLayout
        view.collectionViewFlowLayout.minimumInteritemSpacing = 100
        view.collectionViewFlowLayout.minimumLineSpacing = 50
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadData()
    }
    
    //MARK: - Categories Data
    
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
            self.dataSource = categories
            self.refreshTableView()
        }
    }
    
    //MARK: - Playlist Data
    
    private func loadPlaylistData() {
        // Playlist request
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
    
    private func populatePlaylistData(categories:[CategoryProtocol]) {
        Async.main {
            self.dataSource = categories
            self.refreshTableView()
        }
    }
    
    // MARK: - Display
    
    private func refreshTableView() {
        let view = self.view as! HomeView
        view.tableView.reloadData()
        //view.showTableView()
    }
    
    private func clearRefresh() {
        //let view = self.view as! HomeView
        //view.showErrorMessage()
    }
    
}