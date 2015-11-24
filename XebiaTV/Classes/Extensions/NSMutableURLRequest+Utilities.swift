//
//  NSMutableURLRequest+Utilities.swift
//  LVLive
//
//  Created by Fabien Mirault on 21/05/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    
    override public var description: String {
        let HTTPMethod = self.HTTPMethod
        var s = "\nHTTP Request\nMethod: \(HTTPMethod)\n"
        if let absoluteString = self.URL?.absoluteString {
            s += "\"\(absoluteString)\"\n"
        }
        
        #if DEBUG
            s += "----------\nHeaders:\n"
            
            if let allHTTPHeaderFields = self.allHTTPHeaderFields {
                for (key, value) in allHTTPHeaderFields {
                    s += "\"\(key): \(value)\"\n"
                }
            }
            
            if HTTPMethod == "POST" {
                if let HTTPBody = self.HTTPBody {
                    if let sBody = NSString(data: HTTPBody, encoding: NSUTF8StringEncoding) {
                        s += "----------\nBody:\n\"\(sBody)\"\n----------\n"
                    }
                }
            }
            
            if let URL = self.URL {
                if let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookiesForURL(URL) { // or .cookies
                    s += "Cookies:\n\(cookies)\n----------\n"
                }
            }
        #endif
        
        return s
    }
    
}
