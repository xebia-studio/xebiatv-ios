//
//  VideoInformations.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

struct Video {

    var thumbnailUrl:String?
    var videoMedium:String?
    var videoHD720:String?
    var videoSmall:String?
    var length:NSInteger?
    var title:String?
    
}

extension Video:ArrowParsable {
    
    init(json: JSON) {
        length <-- json.valueForKeyPath("moreInfo.length_seconds")
        thumbnailUrl <-- json.valueForKeyPath("moreInfo.iurl")
        title <-- json.valueForKeyPath("moreInfo.title")
        videoMedium <-- json["medium"]
        videoHD720 <-- json["hd720"]
        videoSmall <-- json["small"]
    }
    
}
