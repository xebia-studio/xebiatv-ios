//
//  WSClient.swift
//  LVLive
//
//  Created by Fabien Mirault on 29/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation
import Alamofire

open class WSClient: WSClientProtocol {
    
    static var authorizationSaved = false
    static var manager: SessionManager? = nil
    
    // MARK: Content
    
    static func requestContent(_ method:Alamofire.Method, urlRequest: NSMutableURLRequest, parameters: [String: AnyObject]? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> WSRequestTask {
        
        // Update Manager
        self.updateManager(urlRequest)
        
        let task = WSRequestTask { fulfill, reject in
            self.manager?.request(urlRequest, method, parameters:parameters?.count > 0 ? parameters : nil, encoding:encoding)
                .validate()
                .response { (request, response, data, error) in
                    if let error = error {
                        reject(error)
                        return
                    }
                    
                    guard let _ = response, let data = data else {
                        let error = NSError(domain: "WSClient", code: 0, userInfo: ["errorDescription": "No data"])
                        reject(error)
                        return
                    }
                    
                    fulfill(data)
            }
        }
        
        return task
    }
    
    // MARK: Configuration
    
    static func updateManager(_ urlRequest:NSMutableURLRequest) {
        if self.manager != nil && self.authorizationSaved == true {
            return
        }
        
        // Create a custom configuration
        let configuration = self.applyHeadersForSession(urlRequest)
        
        // Create your own manager instance that uses your custom configuration
        self.manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    static func resetManager() {
        self.authorizationSaved = false
        self.manager = nil
    }
    
    static func applyHeadersForSession(_ urlRequest:NSMutableURLRequest) -> URLSessionConfiguration {
        var headers = Alamofire.SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        if let allHTTPHeaderFields = urlRequest.allHTTPHeaderFields {
            for (key, value) in allHTTPHeaderFields {
                if (key == "Authorization") {
                    self.authorizationSaved = true
                }
                headers[key] = value
            }
        }
        
        let configuration = URLSessionConfiguration.ephemeral
        configuration.httpAdditionalHeaders = headers
        return configuration
    }
}
