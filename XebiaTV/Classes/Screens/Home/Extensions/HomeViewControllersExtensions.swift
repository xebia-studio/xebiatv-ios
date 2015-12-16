//
//  HomeViewControllersExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.size.width, round(UIScreen.mainScreen().bounds.size.height / 2.2))
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.menuDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Dequeue a cell from the collection view.
        return collectionView.dequeueReusableCellWithReuseIdentifier(HomeCell.reuseIdentifier(), forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? HomeCell else { fatalError("Expected to display a `HomeCell`.") }
        
        // Configure the cell.
        let sectionDataItems = self.videosDataSource[indexPath.section]
        cell.videosDataSource = sectionDataItems
        cell.category = self.menuDataSource[indexPath.section]
    }
    
    func collectionView(collectionView: UICollectionView, canFocusItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        /*
        Return `false` because we don't want this `collectionView`'s cells to
        become focused. Instead the `UICollectionView` contained in the cell
        should become focused.
        */
        return false
    }
    
    // MARK: - UICollectionView Delegate
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - (CGFloat(Constants.Configuration.NumCellsPerLine - 1) * self.spaceBetweenCells)
        let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsPerLine)
        return CGSizeMake(width, width * 9 / 16)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.remembersLastFocusedIndexPath = true
        
        /*let cell = collectionView.cellForItemAtIndexPath(indexPath) as! VideoCell
        self.selectedBackgroundImage = cell.videoImageView.image
        
        guard let index = self.collectionViews.indexOf(collectionView) else { return }
        self.selectedIndex = index
        self.selectedVideo = self.videosDataSource[index][indexPath.item]
        self.performSegueWithIdentifier(Constants.Segues.ShowDetails, sender: nil)*/
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.spaceBetweenCells
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return self.spaceBetweenCells
    }

    // MARK: - UICollectionView DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.menuDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        /*guard let index = self.collectionViews.indexOf(collectionView) else { return 0 }
        return max(self.videosDataSource[index].count, 1)*/
        if self.videosDataSource.count > section {
            return self.videosDataSource[section].count
        }
        
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(collectionView, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView =
            collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier:HomeCollectionViewHeaderView.reuseIdentifier(), forIndexPath: indexPath) as! HomeCollectionViewHeaderView
            
            headerView.backgroundColor = UIColor.yellowColor()  // ... YELLOW background
            return headerView
        }
        
        return UICollectionReusableView()
    }
    
    // MARK: - Cell
    
    private func videoCellAtIndexPath(collectionView:UICollectionView, indexPath:NSIndexPath) -> VideoCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath) as! VideoCell
        //if let index = self.collectionViews.indexOf(collectionView) where self.videosDataSource[index].count > indexPath.item {
        let video = self.videosDataSource[indexPath.section][indexPath.item]
        cell.setup(video)
        //}
        
        return cell
    }*/
    
    /*// MARK: - UITableView Delegate
    
    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 500
    }
    
    // MARK: - UITableView DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.menuDataSource.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.homeCellAtIndexPath(indexPath)
    }
    
    // MARK: - Cells
    
    func homeCellAtIndexPath(indexPath:NSIndexPath) -> HomeCell {
        let view = self.view as! HomeView
        let cell = view.tableView.dequeueReusableCellWithIdentifier(HomeCell.reuseIdentifier(), forIndexPath: indexPath) as! HomeCell
        cell.category = self.menuDataSource[indexPath.section]
        cell.videosDataSource = self.videosDataSource[indexPath.section]
        return cell
    }*/
    
}