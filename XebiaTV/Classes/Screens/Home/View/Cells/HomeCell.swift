//
//  HomeCell.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

class HomeCell: AbstractTableViewCell {

    @IBOutlet weak var titleLabel:UILabel!
 
    var category:CategoryProtocol? = nil {
        didSet {
            guard let category = category else { return }
            self.titleLabel.text = category.name
        }
    }
    
}