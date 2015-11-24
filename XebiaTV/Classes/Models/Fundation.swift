//
//  Fundation.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

struct Fundation: CategoryProtocol {
    
    var id:String?
    var name:String?
    var color:String?
    
    internal init() {
        
    }
    
    internal init(parameters: NSDictionary) {
        id = parameters["id"] as? String
        name = parameters["name"] as? String
        color = parameters["color"] as? String
    }
    
    internal init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        name = decoder["name"].string
        color = decoder["color"].string
    }
    
}