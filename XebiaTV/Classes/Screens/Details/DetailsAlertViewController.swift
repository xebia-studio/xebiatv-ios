//
//  DetailsAlertViewController.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 03/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class DetailsAlertViewController: UIViewController {

    // MARK: - Variables
    
    var video:Video? {
        didSet {
            let view = self.view as! DetailsAlertView
            view.setVideo(video)
        }
    }

}
