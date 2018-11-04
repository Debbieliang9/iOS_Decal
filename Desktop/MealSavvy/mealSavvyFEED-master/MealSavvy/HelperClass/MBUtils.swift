//
//  MBUtils.swift
//  MealSavvy
//

import UIKit

class MBUtils: NSObject {
    
    static func getCommonFont() -> UIFont {
        return UIFont(name: "SF UI Display", size: 12.0)!
    }
    
    static func getUITextFontSize(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "SFUIText-Regular", size: fontSize)!
    }
    
    static func getToolowFontSize(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "SF UI Display", size: fontSize)!
    }
    
    static func getToolowPriceFontSize(_ fontSize:CGFloat) -> UIFont {
        return UIFont(name: "Roboto", size: fontSize)!
    }
    
    static func isShouldChangeHumanId (_ textField: UITextField, range: NSRange, replacementString: String) -> Bool {
        
        var opRange = range
        
        // All digits entered
        if opRange.location == 15 {
            return false
        }

        // Reject appending non-digit characters
        if opRange.length == 0, !(CharacterSet.decimalDigits.contains(replacementString[replacementString.index(replacementString.startIndex, offsetBy: 0)].unicodeScalars.first!)) {
            return false
        }
        
        // Auto-add hyphen and parentheses
        if opRange.length == 0, (opRange.location == 3 || opRange.location == 7 || opRange.location == 11) {
            textField.text = "\(textField.text!)-\(replacementString)"
            return false
        }
        
        // Delete hyphen and parentheses when deleting its trailing digit
        if opRange.length == 1, (opRange.location == 10 || opRange.location == 1) {
            
            opRange.location -= 1
            opRange.length = 2
            
            let nsString = textField.text as NSString?
            let newString = nsString?.replacingCharacters(in: opRange, with: "")
            textField.text = newString
            return false
        }
        
        if opRange.length == 1, opRange.location == 6 {
            opRange.location = opRange.location - 2
            opRange.length = 3

            let nsString = textField.text as NSString?
            let newString = nsString?.replacingCharacters(in: opRange, with: "")
            textField.text = newString
            return false
        }
        
        return true
    }
}
