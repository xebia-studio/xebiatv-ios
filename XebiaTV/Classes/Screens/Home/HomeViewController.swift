//
//  HomeViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    let numCellsPerLine = 2.0
    let numVideos = 10
    let titles = ["XebiCon '15", "Agilité", "Craft", "Mobile"]
    
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
    
}