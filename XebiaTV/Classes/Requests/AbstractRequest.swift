//
//  AbstractRequest.swift
//  LVLive
//
//  Created by Fabien Mirault on 29/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation
import SwiftTask

public typealias Progress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
public typealias RequestBuildTask = Task<Progress, NSMutableURLRequest, NSError>

open class AbstractRequest {
    
    open static func buildRequest(_ urlString: String) -> NSMutableURLRequest {
        let mutableURLRequest = NSMutableURLRequest(url: URL(string: urlString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        mutableURLRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json,text/plain,*/*", forHTTPHeaderField: "Accept")
        mutableURLRequest.setValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
        mutableURLRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        return mutableURLRequest
    }

}
