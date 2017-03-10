//
//  HomeJSONDeserializer.swift
//  LVLive
//
//  Created by Fabien Mirault on 30/04/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Async
import SwiftTask

public typealias JSONArrayDeserializerTask = Task<Progress, [GenericJSON], NSError>

open class JSONArrayDeserializer: Deserializer {

    static func deserialize(_ data: NSData) -> JSONArrayDeserializerTask {
        return JSONArrayDeserializerTask { fulfill, reject in
            Async.background {
                do {
                    guard let list = try JSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [GenericJSON] else { return }
                    fulfill(list)
                }
                catch let error as NSError {
                    reject(error)
                }
                catch _ {
                    let unknownError = NSError(domain: "JSONArrayDeserializer", code: 0, userInfo: ["errorDescription": "Cannot deserialize JSON"])
                    Async.main {
                        reject(unknownError)
                    }
                }
            }
        }
    }
    
}
