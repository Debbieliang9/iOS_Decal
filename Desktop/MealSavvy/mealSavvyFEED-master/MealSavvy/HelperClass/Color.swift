//
//  Color.swift
//  Storefront
//
//  Created by Shopify.
//  Copyright (c) 2017 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit

extension UIColor {
    
    private convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(
            red:   r/255.0,
            green: g/255.0,
            blue:  b/255.0,
            alpha: 1.0
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
    
    class func toolowGreen() -> UIColor {
        return UIColor.init(rgb: 0x00A652, a: 1.0)
    }
    
    class func secondary1() -> UIColor {
        return UIColor.init(rgb: 0xd0d0d0, a: 1.0)
    }
    
    //key theme color
    class func primary1() -> UIColor {
        return UIColor.init(rgb: 0xed2247, a: 1.0)
    }
    //background
    class func smokeColor() -> UIColor {
        return UIColor.init(rgb: 0xf1f1f1, a: 1.0)
    }
    
    class func toolowLightGray() -> UIColor {
        return UIColor.init(rgb: 0x4a4a4a, a: 1.0)
    }
    
    //text
    class func secondary3() -> UIColor {
        return UIColor.init(rgb: 0x4c4c4c, a: 1.0)
    }
    
    class func backgroundGray() -> UIColor {
        return UIColor.init(rgb: 0xECECEC, a: 1.0)
    }
    
    class func sparkingRed() -> UIColor{
        return UIColor.init(rgb: 0xFF518B, a: 1.0)
    }
    
    //Checkout Confirmation Page
    class func blackTitleColor() -> UIColor{
        return UIColor.init(rgb: 0x292929, a: 1.0)
    }
    
    class func statucActiveText() -> UIColor {
        return UIColor.init(rgb: 0x333333, a: 1.0)
    }
    
    class func statucInactiveText() -> UIColor {
        return UIColor.init(rgb: 0x999999, a: 1.0)
    }
    
    class func toolowDarkText() -> UIColor {
        return UIColor.init(rgb: 0x444444, a: 1.0)
    }
    
    class func toolowSmokeBG() -> UIColor {
        return UIColor.init(rgb: 0xf5f5f5, a: 1.0)
    }
    
    class func toolowOrange() -> UIColor {
        return UIColor.init(rgb: 0xdf9116, a: 1.0)
    }
    
    class func toolowTitleText() -> UIColor {
        return UIColor.init(rgb: 0x666666, a: 1.0)
    }
    
    class func toolowGray()-> UIColor {
        return UIColor.init(rgb: 0x6A6A6A, a: 1.0)
    }

    static let applicationGreen = UIColor(r: 100.0, g: 183.0, b: 56.0)
}
