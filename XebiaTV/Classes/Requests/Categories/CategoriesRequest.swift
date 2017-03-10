//
//  CategoriesRequest.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

class CategoriesRequest: AbstractRequest {

    // MARK: Listing
    
    static fileprivate func buildListRequest() -> NSMutableURLRequest {
        let urlString = Constants.Endpoints.BaseURL + Constants.Endpoints.CategoriesListEndpoint
        return super.buildRequest(urlString)
    }
    
    static fileprivate func buildListRequest() -> RequestBuildTask {
        return RequestBuildTask { (progress, fulfill, reject, configure) in
            fulfill(self.buildListRequest())
        }
    }
    
    static func listCategories(_ parameters:GenericJSON, client:WSClientProtocol.Type) -> WSRequestTask {
        return self.buildListRequest()
            .success { mutableRequest in
                return client.requestContent(.GET, urlRequest: mutableRequest, parameters:parameters, encoding:.URL)
            }
            .failure { (error, isCancelled) -> WSRequestTask in
                return client.forwardContentErrorTask(error, isCancelled: isCancelled)
        }
    }
    
}
