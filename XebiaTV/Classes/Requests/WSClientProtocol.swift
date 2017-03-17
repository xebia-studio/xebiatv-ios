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

typealias WSRequestTask = Task<Progress, Data, Error>

protocol WSClientProtocol  {
    
    static func requestContent(_ method:Alamofire.HTTPMethod, urlRequest: NSMutableURLRequest, parameters: Parameters?, encoding: ParameterEncoding) -> WSRequestTask
    
}

extension WSClientProtocol {
    
    // MARK: Forward Errors
    
    static func forwardContentErrorTask(_ error: NSError?, isCancelled: Bool?) -> WSRequestTask {
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
