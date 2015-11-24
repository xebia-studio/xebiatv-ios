//
//  VideoInformations.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

struct Video: JSONJoy {
    
    var thumbnailUrl:String?
    var videoMedium:String?
    var videoHD720:String?
    var videoSmall:String?
    var length:String?
    var title:String?
    
    internal init() {
        
    }
    
    internal init(parameters: NSDictionary) {
        title = parameters["moreInfo.title"] as? String
        length = parameters["moreInfo.length_seconds"] as? String
        videoSmall = parameters["small"] as? String
        videoHD720 = parameters["hd720"] as? String
        videoMedium = parameters["medium"] as? String
        thumbnailUrl = parameters["moreInfo.iurl"] as? String
    }
    
    internal init(_ decoder: JSONDecoder) {
        title = decoder["moreInfo.title"].string
        length = decoder["moreInfo.length_seconds"].string
        videoSmall = decoder["small"].string
        videoHD720 = decoder["hd720"].string
        videoMedium = decoder["medium"].string
        thumbnailUrl = decoder["moreInfo.iurl"].string
    }
    
}