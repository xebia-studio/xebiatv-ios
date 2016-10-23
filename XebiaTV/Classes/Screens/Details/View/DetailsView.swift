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

    // MARK: - IBOutlets
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var categoryLabel:UILabel!
    @IBOutlet weak var playButton:CommonButton!
    @IBOutlet weak var buttonsContainer:UIView!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var relatedVideosLabel:UILabel!
    @IBOutlet weak var backgroundView:UIImageView!
    @IBOutlet weak var moreInfoButton:CommonButton!
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
        self.titleLabel.textColor = UIColor.whiteColor()
        self.descriptionLabel.font = UIFont.fontRegular(30)
        self.categoryLabel.font = UIFont.fontLight(30)
        self.categoryLabel.textColor = UIColor.whiteColor()
        self.relatedVideosLabel.font = UIFont.fontRegular(30)
        self.relatedVideosLabel.text = "RELATED_VIDEOS".localized
        self.relatedVideosLabel.textColor = UIColor.commonPurpleColor()
     
        // Buttons
        self.playButton.setImage(UIImage(named: "IconPlay"), forState: UIControlState.Normal)
        self.playButton.setDescriptiveText("PLAY_BUTTON".localized)
        self.moreInfoButton.setImage(UIImage(named: "IconDots"), forState: UIControlState.Normal)
        self.moreInfoButton.setDescriptiveText("MORE_INFORMATIONS_BUTTON".localized)
    }
    
    // MARK: - Focus
    
    private func setupFocusGuide() {
        let topButtonFocusGuide = UIFocusGuide()
        topButtonFocusGuide.preferredFocusedView = self.buttonsContainer
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
    
    func setCategory(category:String?) {
//        guard let category = category else {
//            self.categoryLabel.text = nil
//            return
//        }
        
        self.categoryLabel.text = nil
        //self.categoryLabel.text = "#\(category.capitalizedString.removeWhitespace())"
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
