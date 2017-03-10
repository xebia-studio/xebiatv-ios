//
//  VideoInformations.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import Unbox
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum ThumbnailType: String {
    case Default = "default"
    case High = "high"
    case MaxRes = "maxres"
    case Medium = "medium"
    case Standard = "standard"
}

enum QualityType: String {
    case Best = "best"
    case HD720 = "720p"
    case Medium = "360p"
    case Small = "240p"
    case Low = "144p"
    case Worst = "worst"
}

struct Thumbnail: Unboxable {
    
    var url:String?
    var width:NSInteger?
    var height:NSInteger?
    var type:ThumbnailType?
    
    var urlString:String {
        return (url != nil) ? String(url!) : ""
    }
    
    internal init(unboxer: Unboxer) {
        
        url = unboxer.unbox(key: "url")
        width = unboxer.unbox(key: "width")
        height = unboxer.unbox(key: "height")
        
    }
}

struct VideoResource: Unboxable {
    
    var url:String?
    var type:String?
    var quality:String?
    
    var urlString:String {
        return (url != nil) ? String(url!) : ""
    }
    
    internal init(unboxer: Unboxer) {
        
        url = unboxer.unbox(key: "url")
        type = unboxer.unbox(key: "type")
        quality = unboxer.unbox(key: "quality")
        
    }
}

struct Resource: Unboxable {
    
    var kind:String?
    var videoId:String?
   
    internal init(unboxer: Unboxer) {
        self.kind = unboxer.unbox(key: "kind")
        self.videoId = unboxer.unbox(key: "videoId")
    }
}

struct Snippet: Unboxable {

    var title:String?
    var channelId:String?
    var playlistId:String?
    var position:NSInteger?
    var publishedAt:String?
    var description:String?
    var channelTitle:String?
    var resource:Resource?
    var thumbnails:Array<Thumbnail> = []
    
    var bestThumbnail:Thumbnail? {
        
        if thumbnails.count == 0 {
            return nil
        }
        
        var selectedThumbnail = thumbnails[0]
        let thumbnailsOrder:Array<ThumbnailType> = [.Default, .Medium, .High, .Standard, .MaxRes]
        
        for thumbnail in thumbnails {
            guard let thumbType = thumbnail.type, let currentThumbType = selectedThumbnail.type else { continue }
            if thumbnailsOrder.index(of: thumbType) > thumbnailsOrder.index(of: currentThumbType) {
                selectedThumbnail = thumbnail
            }
        }
        
        return selectedThumbnail
    }
    
    internal init(unboxer: Unboxer) {
        self.title = unboxer.unbox(key: "title")
        self.position = unboxer.unbox(key: "position")
        self.channelId = unboxer.unbox(key: "channelId")
        self.playlistId = unboxer.unbox(key: "playlistId")
        self.publishedAt = unboxer.unbox(key: "publishedAt")
        self.description = unboxer.unbox(key: "description")
        self.channelTitle = unboxer.unbox(key: "channelTitle")
        self.channelId = unboxer.unbox(key: "channelId")
        self.resource = unboxer.unbox(key: "resourceId")
        
        // Thumbnails
        guard let thumbs:UnboxableDictionary = unboxer.unbox(key: "thumbnails") else {
            return
        }
        
        thumbnails = Array<Thumbnail>()
        for thumbnailDecoder in thumbs {
            var thumbnail:Thumbnail = unboxer.unbox(keyPath: "thumbnails.\(thumbnailDecoder.0)")
            thumbnail.type = ThumbnailType(rawValue: thumbnailDecoder.0)
            thumbnails.append(thumbnail)
        }
    }
    
}

extension Video: Equatable { }
func ==(lhs: Video, rhs: Video) -> Bool {
    return lhs.id == rhs.id
}

struct Video: Unboxable {

    var id:String?
    var etag:String?
    var snippet:Snippet?
    var urls:Array<VideoResource> = []
    
    var bestUrl:VideoResource? {
        if urls.count == 0 {
            return nil
        }
        
        var selectedUrl = urls[0]
        let urlsOrder:Array<QualityType> = [.Worst, .Low, .Small, .Medium, .HD720, .Best]
        
        for url in urls {
            guard let urlType = QualityType(rawValue: url.quality!), let currentUrlType = QualityType(rawValue: selectedUrl.quality!) else { continue }
            if urlsOrder.index(of: urlType) > urlsOrder.index(of: currentUrlType) {
                selectedUrl = url
            }
        }
        
        return selectedUrl
    }

    internal init(unboxer: Unboxer) {
        self.id = unboxer.unbox(key: "id")
        self.etag = unboxer.unbox(key: "etag")
        self.snippet = unboxer.unbox(key: "snippet")
    }
    
}
