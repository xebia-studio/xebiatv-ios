//
//  VideoInformations.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import Unbox

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
        
        url = unboxer.unbox("url")
        width = unboxer.unbox("width")
        height = unboxer.unbox("height")
        
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
        
        url = unboxer.unbox("url")
        type = unboxer.unbox("type")
        quality = unboxer.unbox("quality")
        
    }
}

struct Resource: Unboxable {
    
    var kind:String?
    var videoId:String?
   
    internal init(unboxer: Unboxer) {
        self.kind = unboxer.unbox("kind")
        self.videoId = unboxer.unbox("videoId")
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
            guard let thumbType = thumbnail.type, currentThumbType = selectedThumbnail.type else { continue }
            if thumbnailsOrder.indexOf(thumbType) > thumbnailsOrder.indexOf(currentThumbType) {
                selectedThumbnail = thumbnail
            }
        }
        
        return selectedThumbnail
    }
    
    internal init(unboxer: Unboxer) {
        self.title = unboxer.unbox("title")
        self.position = unboxer.unbox("position")
        self.channelId = unboxer.unbox("channelId")
        self.playlistId = unboxer.unbox("playlistId")
        self.publishedAt = unboxer.unbox("publishedAt")
        self.description = unboxer.unbox("description")
        self.channelTitle = unboxer.unbox("channelTitle")
        self.channelId = unboxer.unbox("channelId")
        self.resource = unboxer.unbox("resourceId")
        
        // Thumbnails
        guard let thumbs:UnboxableDictionary = unboxer.unbox("thumbnails") else {
            return
        }
        
        thumbnails = Array<Thumbnail>()
        for thumbnailDecoder in thumbs {
            var thumbnail:Thumbnail = unboxer.unbox("thumbnails.\(thumbnailDecoder.0)", isKeyPath: true)
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
            guard let urlType = QualityType(rawValue: url.quality!), currentUrlType = QualityType(rawValue: selectedUrl.quality!) else { continue }
            if urlsOrder.indexOf(urlType) > urlsOrder.indexOf(currentUrlType) {
                selectedUrl = url
            }
        }
        
        return selectedUrl
    }

    internal init(unboxer: Unboxer) {
        self.id = unboxer.unbox("id")
        self.etag = unboxer.unbox("etag")
        self.snippet = unboxer.unbox("snippet")
    }
    
}