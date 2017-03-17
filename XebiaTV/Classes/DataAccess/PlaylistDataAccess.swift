//
//  PlaylistDataAccess.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 25/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import SwiftTask
import Unbox

typealias PlaylistRetrieveTask = Task<Progress, [Video], Error>

class PlaylistDataAccess {
    
    // MARK: Listing
    
    static func retrieveVideos(_ parameters:GenericJSON = GenericJSON(), client:WSClientProtocol.Type? = WSClient.self) -> PlaylistRetrieveTask {
        return PlaylistRequest.listVideos(parameters, client:client!)
            .success { data in
                return JSONDictionaryDeserializer.deserialize(data)
            }
            .success { data in
                return self.buildPlaylist(data)
            }
            .success { categoriesList in
                return PlaylistRetrieveTask { fulfill, reject in
                    fulfill(categoriesList)
                }
            }
            .failure { (error, isCancelled) -> PlaylistRetrieveTask in
                return PlaylistRetrieveTask { fulfill, reject in
                    guard let error = error else { return }
                    reject(error)
                }
        }
    }
    
    static func buildPlaylist(_ playlistData: GenericJSON) -> [Video] {
        var list = [Video]()
        guard let videos = playlistData["items"] as? Array<AnyObject> else { return list }
        
        for videoData in videos {
            if let videoData = videoData as? UnboxableDictionary {
                guard let video:Video = try? unbox(dictionary: videoData), let snippet = video.snippet, snippet.title != Constants.Configuration.PrivateVideoKey else {
                    XBLog("Error with data : \(videoData)")
                    continue
                }
                
                list.append(video)
            }
        }
        
        return list
    }

}
