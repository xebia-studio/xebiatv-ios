//
//  NSMutableURLRequest+Utilities.swift
//  LVLive
//
//  Created by Fabien Mirault on 21/05/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation

extension NSMutableURLRequest {
    
    override open var description: String {
        let HTTPMethod = self.httpMethod
        var s = "\nHTTP Request\nMethod: \(HTTPMethod)\n"
        if let absoluteString = self.url?.absoluteString {
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
                if let httpBody = self.httpBody {
                    if let sBody = String(data: httpBody, encoding: .utf8) {
                        s += "----------\nBody:\n\"\(sBody)\"\n----------\n"
                    }
                }
            }
            
            if let url = self.url {
                if let cookies = HTTPCookieStorage.shared.cookies(for: url) { // or .cookies
                    s += "Cookies:\n\(cookies)\n----------\n"
                }
            }
        #endif
        
        return s
    }
    
}
