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
typealias CategoriesRetrieveTask = Task<Progress, CategoriesResult, ErrorType>

class CategoriesDataAccess {

    // MARK: Listing
    
    static func retrieveCategories(parameters:GenericJSON = GenericJSON(), client:WSClientProtocol.Type? = WSClient.self) -> CategoriesRetrieveTask {
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

    static func buildCategories(categoriesData: GenericJSON) -> CategoriesResult {
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
            let fundationCategory:Category = Unbox(["name": "FUNDATIONS".localized])!
            categories.insert(fundationCategory, atIndex: 0)
        }
        
        return (categories, fundations)
    }
    
    private static func buildFilters(key:String, categoryList: AnyObject?) -> [CategoryProtocol] {
        var list = [CategoryProtocol]()
        
        guard let dataList = categoryList as? Array<AnyObject> else { return list }
        
        for categoryData in dataList {
            if categoryData.isKindOfClass(NSDictionary) {
                
                switch key {
                    case Constants.MenuKeys.CategoriesKey:
                        if let category:Category = Unbox(categoryData as! UnboxableDictionary) {
                            list.append(category)
                        } else {
                            XBLog("Error while unboxing category : \(categoryData)");
                        }
                        break
                    
                    case Constants.MenuKeys.FundationsKey:
                        if let fundation:Fundation = Unbox(categoryData as! UnboxableDictionary) {
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