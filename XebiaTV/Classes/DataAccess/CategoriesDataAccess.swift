//
//  CategoriesDataAccess.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import SwiftTask
import Unbox

typealias CategoriesResult = (categories:[CategoryProtocol], fundations:[CategoryProtocol])
typealias CategoriesRetrieveTask = Task<Progress, CategoriesResult, Error>

class CategoriesDataAccess {

    // MARK: Listing
    
    static func retrieveCategories(_ parameters:GenericJSON = GenericJSON(), client:WSClientProtocol.Type? = WSClient.self) -> CategoriesRetrieveTask {
        return CategoriesRequest.listCategories(parameters, client:client!)
            .success { data in
                return JSONDictionaryDeserializer.deserialize(data)
            }
            .success { data in
                return self.buildCategories(data)
            }
            .success { categoriesList in
                return CategoriesRetrieveTask { fulfill, reject in
                    fulfill(categoriesList)
                }
            }
            .failure { (error, isCancelled) -> CategoriesRetrieveTask in
                return CategoriesRetrieveTask { fulfill, reject in
                    guard let error = error else { return }
                    reject(error)
                }
        }
    }

    static func buildCategories(_ categoriesData: GenericJSON) -> CategoriesResult {
        var categories = [CategoryProtocol]()
        var fundations = [CategoryProtocol]()
        
        for categoryData in categoriesData {
            
            switch categoryData.0 {
                case Constants.MenuKeys.CategoriesKey:
                    categories = self.buildFilters(categoryData.0, categoryList: categoryData.1)
                    break
                
                case Constants.MenuKeys.FundationsKey:
                    fundations = self.buildFilters(categoryData.0, categoryList: categoryData.1)
                    break
                
                default:
                    break
                
            }
        }
        
        if fundations.count > 0 {
            if let fundationCategory:Category = try? unbox(dictionary: ["name": "FUNDATIONS".localized]) {
              categories.insert(fundationCategory, at: 0)
            }
        }
        
        return (categories, fundations)
    }
    
    fileprivate static func buildFilters(_ key:String, categoryList: AnyObject?) -> [CategoryProtocol] {
        var list = [CategoryProtocol]()
        
        guard let dataList = categoryList as? Array<AnyObject> else { return list }
        
        for categoryData in dataList {
            if let categoryData = categoryData as? UnboxableDictionary {
                
                switch key {
                    case Constants.MenuKeys.CategoriesKey:
                        if let category:Category = try? unbox(dictionary :categoryData) {
                            list.append(category)
                        } else {
                            XBLog("Error while unboxing category : \(categoryData)");
                        }
                        break
                    
                    case Constants.MenuKeys.FundationsKey:
                        if let fundation:Fundation = try? unbox(dictionary :categoryData) {
                            list.append(fundation)
                        } else {
                            XBLog("Error while unboxing fundation : \(categoryData)");
                        }
                        break
                    
                    default:
                        XBLog("Key type is unknown : \(key)")
                        break
                }
            }
        }
        
        return list
    }
    
}
