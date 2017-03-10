//
//  PlaylistRequest.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 25/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

class PlaylistRequest: AbstractRequest {

    // MARK: Listing
    
    static fileprivate func buildListRequest() -> NSMutableURLRequest {
        let urlString = Constants.Endpoints.YoutubeBaseURL + Constants.Endpoints.PlaylistItemsEndpoint
        return super.buildRequest(urlString)
    }
    
    static fileprivate func buildListRequest() -> RequestBuildTask {
        return RequestBuildTask { (progress, fulfill, reject, configure) in
            fulfill(self.buildListRequest())
        }
    }
    
    static func listVideos(_ parameters:GenericJSON, client:WSClientProtocol.Type) -> WSRequestTask {
        return self.buildListRequest()
            .success { mutableRequest in
                return client.requestContent(.GET, urlRequest: mutableRequest, parameters:parameters, encoding:.URL)
            }
            .failure { (error, isCancelled) -> WSRequestTask in
                return client.forwardContentErrorTask(error, isCancelled: isCancelled)
        }
    }
    
}
