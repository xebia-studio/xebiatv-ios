//
//  JSONDictionnaryDeserializer.swift
//  LVLive
//
//  Created by Fabien Mirault on 01/05/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Async
import SwiftTask

public typealias JSONDictionaryDeserializerTask = Task<Progress, GenericJSON, Error>

open class JSONDictionaryDeserializer: Deserializer {
    
    static func deserialize(_ data: Data) -> JSONDictionaryDeserializerTask {
        return JSONDictionaryDeserializerTask { fulfill, reject in
            Async.background {
                do {
                    guard let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? GenericJSON else { return }
                    fulfill(object)
                }
                catch let error {
                    reject(error)
                }
            }
        }
    }
    
}
