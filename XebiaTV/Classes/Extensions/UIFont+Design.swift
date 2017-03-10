//
//  UIFont+Design.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 26/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

public extension UIFont {

    class func fontBoldName() -> String {
        return "Lato-Semibold"
    }
    
    class func fontMediumName() -> String {
        return "Lato-Medium"
    }
    
    class func fontRegularName() -> String {
        return "Lato-Regular"
    }
    
    class func fontLightName() -> String {
        return "Lato-Light"
    }
    
    class func fontThinName() -> String {
        return "Lato-Thin"
    }
    
    class func fontBold(_ size:CGFloat) -> UIFont {
        return UIFont(name: UIFont.fontBoldName(), size: size)!
    }
    
    class func fontMedium(_ size:CGFloat) -> UIFont {
        return UIFont(name: UIFont.fontMediumName(), size: size)!
    }
    
    class func fontRegular(_ size:CGFloat) -> UIFont {
        return UIFont(name: UIFont.fontRegularName(), size: size)!
    }
    
    class func fontLight(_ size:CGFloat) -> UIFont {
        return UIFont(name: UIFont.fontLightName(), size: size)!
    }
    
    class func fontThin(_ size:CGFloat) -> UIFont {
        return UIFont(name: UIFont.fontThinName(), size: size)!
    }
    
    class func listAllAvailableFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName)
            print("Font Names = [\(names)]")
        }
    }
    
}
