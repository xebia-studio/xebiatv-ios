//
//  CategoryProtocol.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 24/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import Foundation
import Unbox

protocol CategoryProtocol: Unboxable {
    
    var id:String?  { get set }
    var name:String?  { get set }
    
}

extension CategoryProtocol {
    
    var idString:String {
        return (id != nil) ? String(id!) : ""
    }
    
    var isFundation:Bool {
        return self.name == "FUNDATIONS".localized
    }
    
}