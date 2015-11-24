//
//  Deserializer.swift
//  LVLive
//
//  Created by Fabien Mirault on 29/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Foundation

protocol Deserializer {
    typealias TransformedData
    static func deserialize(data: NSData) -> TransformedData
}