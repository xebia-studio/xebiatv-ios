//
//  LVString.swift
//  LVLive
//
//  Created by Fabien Mirault on 27/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation

public extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }

    func replace(_ string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(" ", replacement: "")
    }
    
}
