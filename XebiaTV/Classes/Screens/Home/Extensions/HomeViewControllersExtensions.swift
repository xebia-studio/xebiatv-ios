//
//  HomeViewControllersExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import HCYoutubeParser

extension HomeViewController: UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UITableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.homeCellAtIndexPath(indexPath)
    }
    
    // MARK: UITableView Delegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return HomeCell.cellHeight()
    }
    
    // MARK: - Cell
    
    private func homeCellAtIndexPath(indexPath:NSIndexPath) -> HomeCell {
        let view = self.view as! HomeView
        let cell = view.tableView.dequeueReusableCellWithIdentifier(HomeCell.reuseIdentifier(), forIndexPath: indexPath) as! HomeCell
        cell.titleLabel.text = self.titles[indexPath.row]
        return cell
    }
    
    // MARK: - UICollectionView Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let view = self.view as! HomeView
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - view.collectionViewFlowLayout.minimumInteritemSpacing
        let width = effectiveWidth / CGFloat(self.numCellsPerLine)
        return CGSizeMake(width, width * 9 / 16)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        self.performSegueWithIdentifier(Constants.Segues.ShowVideoPlayer, sender: nil)
    }
    
    // MARK: - UICollectionView DataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(indexPath)
    }
    
    // MARK: - Cell
    
    private func videoCellAtIndexPath(indexPath:NSIndexPath) -> VideoCell {
        let view = self.view as! HomeView
        let cell = view.collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath) as! VideoCell
        
        let videos = HCYoutubeParser.h264videosWithYoutubeURL(NSURL(string:"https://www.youtube.com/watch?v=kX9Xf0a5QiY")!)
        let video = Video(json: videos)
        cell.setup(video)
        
        return cell
    }
    
}