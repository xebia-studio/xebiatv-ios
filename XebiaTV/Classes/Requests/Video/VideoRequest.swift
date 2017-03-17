//
//  VideoRequest.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import Alamofire

class VideoRequest: AbstractRequest {
    
    // MARK: Get Video urls
    
    static fileprivate func buildVideoRequest(_ videoId:String) -> NSMutableURLRequest {
        let urlString = Constants.Endpoints.BaseURL + Constants.Endpoints.VideoEndpoint + videoId
        return super.buildRequest(urlString)
    }
    
    static fileprivate func buildVideoRequest(_ videoId:String) -> RequestBuildTask {
        return RequestBuildTask { (progress, fulfill, reject, configure) in
            fulfill(self.buildVideoRequest(videoId))
        }
    }
    
    static func listVideoUrls(_ videoId:String, client:WSClientProtocol.Type) -> WSRequestTask {
        return self.buildVideoRequest(videoId)
            .success { mutableRequest in
                return client.requestContent(.get, urlRequest: mutableRequest, parameters:GenericJSON(), encoding: URLEncoding.default)
            }
            .failure { (error, isCancelled) -> WSRequestTask in
                return client.forwardContentErrorTask(error, isCancelled: isCancelled)
        }
    }
    
}
