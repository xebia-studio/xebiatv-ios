//
//  HomeView.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeView: UIView {

    @IBOutlet weak var errorView:UIView!
    @IBOutlet weak var errorLabel:UILabel!
    @IBOutlet weak var errorIcon:UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var loaderView:NVActivityIndicatorView!
    
    // MARk: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Loader
        self.loaderView.hidesWhenStopped = true
        self.loaderView.type = .lineScaleParty
        self.loaderView.color = UIColor.commonPurpleColor()
        self.loaderView.size = CGSize(width: 80, height: 80)
        self.loaderView.startAnimation()        
        
        // Error
        self.errorLabel.font = UIFont.fontLight(40)
        self.errorLabel.textColor = UIColor.commonPurpleColor()
        self.errorIcon.image = UIImage(named: "IconError")
        self.errorView.alpha = 0
        
        // Collection View
        self.collectionView.alpha = 0
    }
    
    // MARK: - Display
    
    func showContent() {
        self.loaderView.stopAnimation()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.collectionView.alpha = 1.0
        })
    }
    
    func showErrorMessage(_ noInternetConnection:Bool) {
        self.errorLabel.text = noInternetConnection ? "NO_INTERNET_CONNECTION".localized : "NO_DATA_ERROR".localized
        
        self.loaderView.stopAnimation()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.errorView.alpha = 1.0
        })
    }
    
}
