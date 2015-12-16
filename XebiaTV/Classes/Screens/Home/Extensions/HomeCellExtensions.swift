//
//  HomeCellExtensions.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 15/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

extension HomeCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let effectiveWidth = collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right - (CGFloat(Constants.Configuration.NumCellsPerLine - 1) * self.spaceBetweenCells)
        let width = effectiveWidth / CGFloat(Constants.Configuration.NumCellsPerLine)
        return CGSizeMake(width, width * 9 / 16)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath)
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        guard let cell = cell as? VideoCell else { fatalError("Expected to display a VideoCell") }
        let item = self.videosDataSource[indexPath.row]
        
        // Configure the cell.
        cell.setup(item)
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

    /*// MARK: - UICollectionView Delegate

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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.videosDataSource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.videoCellAtIndexPath(collectionView, indexPath: indexPath)
    }
    
    // MARK: - Cell
    
    private func videoCellAtIndexPath(collectionView:UICollectionView, indexPath:NSIndexPath) -> VideoCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(VideoCell.reuseIdentifier(), forIndexPath: indexPath) as! VideoCell
        let video = self.videosDataSource[indexPath.item]
        cell.setup(video)
        return cell
    }
    
    /*// Label
    let titleLabel = UILabel()
    titleLabel.backgroundColor = UIColor.clearColor()
    titleLabel.text = category.name
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.font = UIFont.fontLight(50)
    titleLabel.textColor = UIColor.commonPurpleColor()
    view.scrollViewContent.addSubview(titleLabel)
    
    if refView == view.logoImageView {
    constrain(titleLabel, refView, view.scrollViewContent) { titleLabel, refView, scrollViewContent in
    titleLabel.top == refView.bottom + 20
    titleLabel.leading == scrollViewContent.leading + 50
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
    }*/
    
    */
    
}