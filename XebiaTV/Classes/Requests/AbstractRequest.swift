//
//  AbstractRequest.swift
//  LVLive
//
//  Created by Fabien Mirault on 29/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation

public typealias Progress = (bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64)
public typealias RequestBuildTask = Task<Progress, NSMutableURLRequest, NSError>

public class AbstractRequest {
    
    public static func buildRequest(urlString: String) -> NSMutableURLRequest {
        let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 30.0)
        mutableURLRequest.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        mutableURLRequest.setValue("application/json,text/plain,*/*", forHTTPHeaderField: "Accept")
        mutableURLRequest.setValue("gzip,deflate", forHTTPHeaderField: "Accept-Encoding")
        mutableURLRequest.setValue("keep-alive", forHTTPHeaderField: "Connection")
        
        return mutableURLRequest
    }

}