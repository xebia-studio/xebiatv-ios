//
//  Category.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import Unbox

struct Category: CategoryProtocol {
    
    var id:String?
    var name:String?
    var nextPageToken:String?
    
    internal init() {
        
    }
    
    internal init(unboxer: Unboxer) {
        self.id = unboxer.unbox(key: "id")
        self.name = unboxer.unbox(key: "name")
    }
    
}
