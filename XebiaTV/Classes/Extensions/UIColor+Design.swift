//
//  UIColor+Design.swift
//  XebiaTV
//
//  Created by Fabien Mirault on 20/11/2015.
//  Copyright © 2015 Xebia. All rights reserved.
//

import UIKit

public extension UIColor {
    
    convenience init(fullRed: UInt, fullGreen: UInt, fullBlue: UInt, alpha: Float) {
        let red:   CGFloat = CGFloat(fullRed) / 255.0
        let green: CGFloat = CGFloat(fullGreen) / 255.0
        let blue:  CGFloat = CGFloat(fullBlue) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.startIndex.advancedBy(1)
            let hex     = rgba.substringFromIndex(index)
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix")
        }
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    class func commonPurpleColor(alpha:CGFloat = 1.0) -> UIColor {
        let redColor:CGFloat = 108.0
        let greenColor:CGFloat = 30.0
        let blueColor:CGFloat = 97.0
        return UIColor(red: (redColor / 255.0), green: (greenColor / 255.0), blue: (blueColor / 255.0), alpha: alpha)
    }
    
    class func commonOrangeColor(alpha:CGFloat = 1.0) -> UIColor {
        let redColor:CGFloat = 248.0
        let greenColor:CGFloat = 150.0
        let blueColor:CGFloat = 65.0
        return UIColor(red: (redColor / 255.0), green: (greenColor / 255.0), blue: (blueColor / 255.0), alpha: alpha)
    }
    
    class func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    static private func randomCGFloat() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
}