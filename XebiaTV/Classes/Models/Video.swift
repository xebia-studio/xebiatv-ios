//
//  VideoInformations.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 18/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

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

struct Thumbnail: JSONJoy {
    
    var url:String?
    var width:NSInteger?
    var height:NSInteger?
    var type:ThumbnailType?
    
    var urlString:String {
        return (url != nil) ? String(url!) : ""
    }
    
    internal init(_ decoder: JSONDecoder) {
        
        url = decoder["url"].string
        width = decoder["width"].integer
        height = decoder["height"].integer
        
    }
}

struct VideoResource: JSONJoy {
    
    var url:String?
    var type:String?
    var quality:String?
    
    var urlString:String {
        return (url != nil) ? String(url!) : ""
    }
    
    internal init(_ decoder: JSONDecoder) {
        
        url = decoder["url"].string
        type = decoder["type"].string
        quality = decoder["quality"].string
        
    }
}

struct Resource: JSONJoy {
    
    var kind:String?
    var videoId:String?
   
    internal init(_ decoder: JSONDecoder) {
        
        kind = decoder["kind"].string
        videoId = decoder["videoId"].string
        
    }
}

struct Snippet: JSONJoy {

    var title:String?
    var channelId:String?
    var playlistId:String?
    var position:NSInteger?
    var publishedAt:String?
    var description:String?
    var channelTitle:String?
    var resourceId:Resource?
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
    
    internal init(_ decoder: JSONDecoder) {
        title = decoder["title"].string
        position = decoder["position"].integer
        channelId = decoder["channelId"].string
        playlistId = decoder["playlistId"].string
        publishedAt = decoder["publishedAt"].string
        description = decoder["description"].string
        channelTitle = decoder["channelTitle"].string
        channelId = decoder["channelId"].string
        resourceId = Resource(decoder["resourceId"])
        
        // Thumbnails
        guard let thumbs = decoder["thumbnails"].dictionary else {
            return
        }
        
        thumbnails = Array<Thumbnail>()
        for thumbnailDecoder in thumbs {
            var thumbnail = Thumbnail(thumbnailDecoder.1)
            thumbnail.type = ThumbnailType(rawValue: thumbnailDecoder.0)
            thumbnails.append(thumbnail)
        }
    }
    
}

extension Video: Equatable { }
func ==(lhs: Video, rhs: Video) -> Bool {
    return lhs.id == rhs.id
}

struct Video: JSONJoy {

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

    internal init(_ decoder: JSONDecoder) {
        id = decoder["id"].string
        etag = decoder["etag"].string
        snippet = Snippet(decoder["snippet"])
    }
    
}