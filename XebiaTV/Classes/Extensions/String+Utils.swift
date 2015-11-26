//
//  LVString.swift
//  LVLive
//
//  Created by Fabien Mirault on 27/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation

public extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

}