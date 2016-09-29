//
//  VideoDataAccess.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import SwiftTask
import Unbox

typealias VideoRetrieveTask = Task<Progress, [VideoResource], ErrorType>

class VideoDataAccess {
    
    // MARK: Get video urls
    
    static func retrieveVideoUrls(videoId:String, client:WSClientProtocol.Type? = WSClient.self) -> VideoRetrieveTask {
        return VideoRequest.listVideoUrls(videoId, client: client!)
            .success { data in
                return JSONDictionaryDeserializer.deserialize(data)
            }
            .success { data in
                return self.buildVideoUrls(data)
            }
            .success { categoriesList in
                return VideoRetrieveTask { fulfill, reject in
                    fulfill(categoriesList)
                }
            }
            .failure { (error, isCancelled) -> VideoRetrieveTask in
                return VideoRetrieveTask { fulfill, reject in
                    guard let error = error else { return }
                    reject(error)
                }
            }
    }
    
    static func buildVideoUrls(playlistData: GenericJSON) -> [VideoResource] {
        var list = [VideoResource]()
        guard let urls = playlistData["urls"] as? Array<AnyObject> else { return list }
        
        for urlData in urls {
            
            let decodedObject:VideoResource? = Unbox(urlData as! UnboxableDictionary)
            guard let url = decodedObject else {
                XBLog("Error with data : \(urlData)")
                continue
            }
            
            list.append(url)
        }
        
        return list
    }
    
}