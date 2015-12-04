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
    
    internal var collectionViews:[UICollectionView] = []
    internal var menuDataSource:[CategoryProtocol] = []
    internal var selectedIndex:NSInteger = NSIntegerMax
    internal var selectedBackgroundImage:UIImage?
    internal var videosDataSource:[[Video]] = []
    internal var selectedVideo:Video?
    
    let spaceBetweenCells:CGFloat = 100
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            
            let view = self.view as! HomeView
            var refView = view.scrollViewContent
            view.scrollViewContent.translatesAutoresizingMaskIntoConstraints = false
            var index = 0
            for category in categories {
                // Label
                let titleLabel = UILabel()
                titleLabel.backgroundColor = UIColor.clearColor()
                titleLabel.text = category.name
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.font = UIFont.fontLight(50)
                titleLabel.textColor = UIColor.commonPurpleColor()
                view.scrollViewContent.addSubview(titleLabel)
                
                if refView == view.scrollViewContent {
                    constrain(titleLabel, refView) { titleLabel, refView in
                        titleLabel.top == refView.top + 50
                        titleLabel.leading == refView.leading + 50
                    }
                } else {
                    constrain(titleLabel, refView) { titleLabel, refView in
                        titleLabel.top == refView.bottom + 50
                        titleLabel.leading == refView.leading + 50
                    }
                }
                
                let collectionViewFlowLayout = UICollectionViewFlowLayout()
                collectionViewFlowLayout.scrollDirection = .Horizontal
                
                let collectionView = UICollectionView(frame: CGRect.null, collectionViewLayout: collectionViewFlowLayout)
                collectionView.contentInset = UIEdgeInsetsMake(50, self.spaceBetweenCells, self.spaceBetweenCells, self.spaceBetweenCells)
                collectionView.translatesAutoresizingMaskIntoConstraints = false
                collectionView.delegate = self
                collectionView.dataSource = self
                collectionView.clipsToBounds = false // Allows to see cell bottom shadow
                collectionView.registerNib(VideoCell.nib(), forCellWithReuseIdentifier: VideoCell.reuseIdentifier())
                collectionView.backgroundColor = UIColor.clearColor()
                view.scrollViewContent.addSubview(collectionView)
                
                self.collectionViews.append(collectionView)
                
                constrain(collectionView, titleLabel, view) { collectionView, titleLabel, view in
                    collectionView.top == titleLabel.bottom + 20
                    collectionView.leading == titleLabel.leading - 50
                    collectionView.trailing == view.trailing
                    collectionView.height == 350
                }
                
                self.videosDataSource.append([])
                
                if index == 0 {
                    self.loadPlaylistData(index, playlistId: category.idString)
                }
                
                refView = collectionView
                index++
            }
            
            /*let bottomView = UIView()
            bottomView.backgroundColor = UIColor.greenColor()
            view.scrollViewContent.addSubview(bottomView)
            
            constrain(bottomView, refView) { bottomView, refView in
                bottomView.top == refView.bottom + 20
                bottomView.leading == bottomView.superview!.leading
                bottomView.trailing == bottomView.superview!.trailing
                bottomView.bottom == bottomView.superview!.bottom
            }*/
            
            view.layoutIfNeeded()
            
            print("Content Size : \(view.scrollView.contentSize)   \(view.scrollViewContent.bounds)")
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
                
                let nextIndex = index + 1
                if strongSelf.menuDataSource.count > nextIndex {
                    let category = strongSelf.menuDataSource[nextIndex]
                    strongSelf.loadPlaylistData(nextIndex, playlistId: category.idString)
                }
            }
            .failure { /*[weak self]*/ (error, isCancelled) -> Void in
                //guard let strongSelf = self else { return }
                //strongSelf.clearRefresh()
        }
    }
    
    private func populatePlaylistData(index:NSInteger, videos:[Video]) {
        Async.main {
            self.videosDataSource[index] = videos
            self.collectionViews[index].reloadData()
        }
    }
    
    // MARK: - Display
    
    private func clearRefresh() {
        //let view = self.view as! HomeView
        //view.showErrorMessage()
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