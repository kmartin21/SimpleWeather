//
//  UIColor.swift
//  WeatherApp
//
//  Created by keith martin on 6/8/17.
//  Copyright © 2017 keithmartin. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(r: Int, g:Int , b:Int) {
        self.init(red: CGFloat(r)/255, green: CGFloat(g)/255, blue: CGFloat(b)/255, alpha: 1.0)
    }
    
    class func turquoiseColor()->UIColor {
        return UIColor(r: 26, g: 188, b: 156)
    }
    
    class func flatRed() -> UIColor {
        return UIColor(red:0.93, green:0.37, blue:0.36, alpha:1.0)
    }
    
    class func flatOrange() -> UIColor {
        return UIColor(red:0.97, green:0.58, blue:0.02, alpha:1.0)
    }
    
    class func flatGreen() -> UIColor {
        return UIColor(red:0.38, green:0.77, blue:0.38, alpha:1.0)
    }
    
    class func flatBlue() -> UIColor {
        return UIColor(red:0.36, green:0.75, blue:0.87, alpha:1.0)
    }
    
    class func titleColor() -> UIColor {
        return UIColor(r: 102, g: 102, b: 102)
    }

}
