//
//  JSONDictionnaryDeserializer.swift
//  LVLive
//
//  Created by Fabien Mirault on 01/05/2015.
//  Copyright (c) 2015 Xebia. All rights reserved.
//

import Async

public typealias JSONDictionaryDeserializerTask = Task<Progress, GenericJSON, NSError>

public class JSONDictionaryDeserializer: Deserializer {
    
    static func deserialize(data: NSData) -> JSONDictionaryDeserializerTask {
        return JSONDictionaryDeserializerTask { fulfill, reject in
            Async.background {
                do {
                    guard let object = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? GenericJSON else { return }
                    fulfill(object)
                }
                catch let error as NSError {
                    reject(error)
                }
                catch _ {
                    let unknownError = NSError(domain: "JSONDictionnaryDeserializer", code: 0, userInfo: ["errorDescription": "Cannot deserialize JSON"])
                    Async.main {
                        reject(unknownError)
                    }
                }
            }
        }
    }
    
}