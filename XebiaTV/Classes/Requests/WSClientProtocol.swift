//
//  WSClientProtocol.swift
//  LVLive
//
//  Created by Fabien Mirault on 07/10/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import Alamofire
import SwiftTask

typealias WSRequestTask = Task<Progress, NSData, ErrorType>

protocol WSClientProtocol  {
    
    static func requestContent(method:Alamofire.Method, urlRequest: NSMutableURLRequest, parameters: GenericJSON?, encoding: ParameterEncoding) -> WSRequestTask
    
}

extension WSClientProtocol {
    
    // MARK: Forward Errors
    
    static func forwardContentErrorTask(error: NSError?, isCancelled: Bool?) -> WSRequestTask {
        return WSRequestTask { progress, fulfill, reject, configure in
            guard let error = error else {
                let error = NSError(domain: "WSClient", code: 0, userInfo: ["errorDescription": "Task cancelled"])
                reject(error)
                return
            }
            
            reject(error)
        }
    }
    
}