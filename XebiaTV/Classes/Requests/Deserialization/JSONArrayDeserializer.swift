//
//  HomeJSONDeserializer.swift
//  LVLive
//
//  Created by Fabien Mirault on 30/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Async
import SwiftTask

public typealias JSONArrayDeserializerTask = Task<Progress, [GenericJSON], Error>

open class JSONArrayDeserializer: Deserializer {

    static func deserialize(_ data: Data) -> JSONArrayDeserializerTask {
        return JSONArrayDeserializerTask { fulfill, reject in
            Async.background {
                do {
                    guard let list = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [GenericJSON] else { return }
                    fulfill(list)
                }
                catch let error{
                    reject(error)
                }
            }
        }
    }
    
}
