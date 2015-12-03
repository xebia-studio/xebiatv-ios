//
//  Array+Utilities.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 03/12/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    
    func arrayRemovingObject(object: Element) -> [Element] {
        return filter { $0 != object }
    }
    
}