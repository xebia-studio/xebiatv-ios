//
//  Category.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

struct Category: CategoryProtocol {
    
    var id:String?
    var name:String?
    
    internal init() {
        
    }
    
    internal init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        name = decoder["name"].string
    }
    
}