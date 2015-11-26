//
//  DetailsView.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit
import Async

class DetailsView: UIView {

    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var backgroundView:UIImageView!
    @IBOutlet weak var transparentFocusView:UIView!
    @IBOutlet weak var detailsImageView:UIImageView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var collectionViewFlowLayout:UICollectionViewFlowLayout!
    
    // MARK: - LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupFocusGuide()
        
        // Labels
        self.titleLabel.font = UIFont.fontLight(70)
        self.titleLabel.textColor = UIColor.commonPurpleColor()
        self.descriptionLabel.font = UIFont.fontRegular(30)
        
        //self.playButton.setTitle("PLAY_TITLE".localized, forState: UIControlState.Normal)
    }
    
    // MARK: - Focus
    
    private func setupFocusGuide() {
        let topButtonFocusGuide = UIFocusGuide()
        topButtonFocusGuide.preferredFocusedView = self.playButton
        self.addLayoutGuide(topButtonFocusGuide)
        self.addConstraints([
            topButtonFocusGuide.topAnchor.constraintEqualToAnchor(self.transparentFocusView.topAnchor),
            topButtonFocusGuide.bottomAnchor.constraintEqualToAnchor(self.transparentFocusView.bottomAnchor),
            topButtonFocusGuide.leadingAnchor.constraintEqualToAnchor(self.transparentFocusView.leadingAnchor),
            topButtonFocusGuide.widthAnchor.constraintEqualToAnchor(self.transparentFocusView.widthAnchor),
        ])
    }
    
    // MARK: - Display
    
    func updateDisplay(video:Video?) {
        guard let video = video else { return }
        
        self.titleLabel.text = video.snippet?.title
        self.descriptionLabel.text = video.snippet?.description
    }
    
    func setImage(image:UIImage?) {
        guard let image = image else { return }
        
        UIView.transitionWithView(self.backgroundView, duration: 0.25, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
                self.backgroundView.image = image
            }, completion: nil)
        
        UIView.transitionWithView(self.detailsImageView, duration: 0.25, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.detailsImageView.image = image
            }, completion: nil)
    }
    
}
