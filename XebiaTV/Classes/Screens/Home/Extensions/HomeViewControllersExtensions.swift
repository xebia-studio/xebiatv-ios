//
//  HomeViewControllersExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UITableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.homeCellAtIndexPath(indexPath)
    }
    
    // MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HomeCell.cellHeight()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let category = self.menuDataSource[indexPath.row]
        self.selectedCategory = category
        self.loadPlaylistData(category.idString)
    }
    
    // MARK: - Cell
    
    private func homeCellAtIndexPath(indexPath:NSIndexPath) -> HomeCell {
        let view = self.view as! HomeView
        let cell = view.tableView.dequeueReusableCellWithIdentifier(HomeCell.reuseIdentifier(), forIndexPath: indexPath) as! HomeCell
        cell.category = self.menuDataSource[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - (CGFloat(Constants.Configuration.NumCellsPerLine - 1) * SpaceBetweenCells)
        let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsPerLine)
        return CGSizeMake(width, width * 9 / 16)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VideoCell
        self.selectedBackgroundImage = cell.videoImageView.image
        self.selectedVideo = self.videosDataSource[indexPath.item]
        self.performSegueWithIdentifier(Constants.Segues.ShowDetails, sender: nil)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return SpaceBetweenCells
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return SpaceBetweenLines
    }

    // MARK: - UICollectionView DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(indexPath)
    }
    
    // MARK: - Cell
    
    private func videoCellAtIndexPath(indexPath:NSIndexPath) -> VideoCell {
        let view = self.view as! HomeView
        let cell = view.collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath) as! VideoCell
        let video = self.videosDataSource[indexPath.item]
        cell.setup(video)
        
        return cell
    }
    
}