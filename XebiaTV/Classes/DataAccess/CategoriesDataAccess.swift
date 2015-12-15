//
//  CategoriesDataAccess.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation

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
        
        return (categories, fundations)
    }
    
    private static func buildFilters(key:String, categoryList: AnyObject?) -> [CategoryProtocol] {
        var list = [CategoryProtocol]()
        
        guard let dataList = categoryList as? Array<AnyObject> else { return list }
        
        for categoryData in dataList {
            if categoryData.isKindOfClass(NSDictionary) {
                var decodedObject:CategoryProtocol? = nil
                
                switch key {
                    case Constants.MenuKeys.CategoriesKey:
                        decodedObject = Category(JSONDecoder(categoryData as! NSDictionary))
                        break
                    
                    case Constants.MenuKeys.FundationsKey:
                        decodedObject = Fundation(JSONDecoder(categoryData as! NSDictionary))
                        break
                    
                    default:
                        break
                }
                
                guard let category: CategoryProtocol = decodedObject else {
                    XBLog("Error with data : \(categoryData)")
                    continue
                }
                
                list.append(category)
            }
        }
        
        return list
    }
    
}