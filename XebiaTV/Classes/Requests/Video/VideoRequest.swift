//
//  VideoRequest.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

class VideoRequest: AbstractRequest {
    
    // MARK: Get Video urls
    
    static private func buildVideoRequest(videoId:String) -> NSMutableURLRequest {
        let urlString = Constants.Endpoints.BaseURL + Constants.Endpoints.VideoEndpoint + videoId
        return super.buildRequest(urlString)
    }
    
    static private func buildVideoRequest(videoId:String) -> RequestBuildTask {
        return RequestBuildTask { (progress, fulfill, reject, configure) in
            fulfill(self.buildVideoRequest(videoId))
        }
    }
    
    static func listVideoUrls(videoId:String, client:WSClientProtocol.Type) -> WSRequestTask {
        return self.buildVideoRequest(videoId)
            .success { mutableRequest in
                return client.requestContent(.GET, urlRequest: mutableRequest, parameters:GenericJSON(), encoding:.URL)
            }
            .failure { (error, isCancelled) -> WSRequestTask in
                return client.forwardContentErrorTask(error, isCancelled: isCancelled)
        }
    }
    
}