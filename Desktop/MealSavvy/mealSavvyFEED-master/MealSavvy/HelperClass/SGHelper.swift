//
//  SGHelper.swift
//  SG
//
//  Created by Salman Ghumsani on 6/30/16.
//  Copyright © 2016 Salman Ghumsani. All rights reserved.
//

import UIKit
import CoreLocation

var myBundle:Bundle?
var viewBackground:UIView?
var mainNavigation:UINavigationController?
var APP_DELEDATE = UIApplication.shared.delegate as! AppDelegate


//MARK: *************** Extension UIColor ***************
extension UIColor{
    
    var r: CGFloat{
        return self.cgColor.components![0]
    }
    
    var g: CGFloat{
        return self.cgColor.components![1]
    }
    
    var b: CGFloat{
        return self.cgColor.components![2]
    }
    
    var alpha: CGFloat{
        return self.cgColor.components![3]
    }
    
    class func getRGBColor(_ r:CGFloat,g:CGFloat,b:CGFloat)-> UIColor {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
    }
}

//MARK: *************** Extension UIImage ***************
extension UIImage {
    func imageWithColor(_ color1: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        color1.setFill()
        let context = UIGraphicsGetCurrentContext()
        context!.translateBy(x: 0, y: self.size.height)
        context!.scaleBy(x: 1.0, y: -1.0);
        context!.setBlendMode(CGBlendMode.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        context!.clip(to: rect, mask: self.cgImage!)
        context!.fill(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect  = CGRect(x: 0, y: 0, width: targetSize.width, height: targetSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func blurEffect() -> UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: self)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(7, forKey: kCIInputRadiusKey)
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        return processedImage
    }
}

extension UIImage {
     func fromColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

//MARK: *************** Extension UITabBar ***************
extension UITabBar {
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        if UI_USER_INTERFACE_IDIOM() == .pad{
            sizeThatFits.height = 100
        }
        return sizeThatFits
    }
}

//MARK: *************** Extension UIViewController ***************
extension UIViewController
{
    
    func showDescriptionInAlert(_ desc:String,title:String,animationTime:Double,descFont:UIFont) {
        viewBackground?.removeFromSuperview()
        viewBackground = UIView(frame: UIScreen.main.bounds)
        let viewAlertContainer = UIView()
        let txtViewDesc = UITextView()
        viewAlertContainer.backgroundColor = UIColor.white
        viewBackground!.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        txtViewDesc.backgroundColor = UIColor.white
        viewBackground!.alpha = 0.0
        txtViewDesc.text = desc
        txtViewDesc.isEditable = false
        txtViewDesc.font = descFont
        viewAlertContainer.makeRoundCorner(10)
        txtViewDesc.textAlignment = .center
        var txtViewHeight = CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width-80, height: 100)
        let height = heightForLabel(desc, width: UIScreen.main.bounds.width-80, font: descFont)
        if height > 80 && height < 300 {
            txtViewHeight.size.height = height+20
        }
        let lblTitle = UILabel(frame: CGRect(x: 0, y: 8, width: UIScreen.main.bounds.width-80, height: 20))
        lblTitle.text = title
        lblTitle.textColor = UIColor.black
        lblTitle.font = UIFont.systemFont(ofSize: 18)
        lblTitle.backgroundColor = UIColor.white
        lblTitle.textAlignment = .center
        txtViewDesc.frame = txtViewHeight
        viewAlertContainer.frame = CGRect(x: 40, y: 100, width: UIScreen.main.bounds.width-80, height: txtViewHeight.size.height+30)
        viewAlertContainer.center = viewBackground!.center
        viewAlertContainer.addSubview(lblTitle)
        viewAlertContainer.addSubview(txtViewDesc)
        viewBackground!.addSubview(viewAlertContainer)
        self.view.addSubview(viewBackground!)
        UIView.animate(withDuration: animationTime) {
            viewBackground!.alpha = 1.0
        }
    }
    
    func hideDescriptionAlert(_ animationTime:Double) {
        UIView.animate(withDuration: animationTime, animations: { 
            viewBackground?.alpha = 0.0
        }) { (compelete) in
            if compelete {
                viewBackground?.removeFromSuperview()
            }
        }
    }
    
    func showOkAlert(_ msg: String) {
        let alert = UIAlertController(title:
            Constant.kAPPNAME, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: localized("ok"), style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showOkAlertWithHandler(_ msg: String,handler: @escaping ()->Void){
        let alert = UIAlertController(title: Constant.kAPPNAME, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: localized("ok"), style: .default) { (type) -> Void in
            handler()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithActions(_ msg: String,titles:[String], handler:@escaping (_ clickedIndex: Int) -> Void) {
        let alert = UIAlertController(title: Constant.kAPPNAME, message: msg, preferredStyle: .alert)
        for title in titles {
            let action  = UIAlertAction(title: title, style: .default, handler: { (alertAction) in
                //Call back fall when user clicked
                let index = titles.index(of: alertAction.title!)
                if index != nil {
                    handler(index!+1)
                }
                else {
                    handler(0)
                }
            })
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func showOkCancelAlertWithAction(_ msg: String, handler:@escaping (_ isOkAction: Bool) -> Void) {
        let alert = UIAlertController(title: Constant.kAPPNAME, message: msg, preferredStyle: .alert)
        let okAction =  UIAlertAction(title: "Ok", style: .default) { (action) -> Void in
            return handler(true)
        }
        let cancelAction = UIAlertAction(title: localized("Cancel"), style: .cancel) { (action) -> Void in
            return handler(false)
        }
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: *************** Extension NSDate ***************
extension Date{
    func convertToString(_ validDateFormatter:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = validDateFormatter //"dd MMM yyyy" //yyyy-mm-dd hh:mm 
        return dateFormatter.string(from: self as Date)
        
    }
        var age: Int {
            return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        }
    
    func dayOfWeek() -> String? {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self).capitalized
        }
    
    func yearsFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Year, fromDate: date, toDate: self, options: []).year
        //        let calendar = NSCalendar.current
        
        //        let components = Calendar.current.dateComponents([.year], from: date, to: self as Date)
        
        return Calendar.current.dateComponents([.year], from: date, to: self).year!
        
    }
    func monthsFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Month, fromDate: date, toDate: self, options: []).month
        return Calendar.current.dateComponents([.month], from: date as Date, to: self).month!
    }
    func weeksFrom(date:Date) -> Int{
        //return NSCalendar.currentCalendar.components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear!
    }
    func daysFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Day, fromDate: date, toDate: self, options: []).day
        return Calendar.current.dateComponents([.day], from: date, to: self).day!
    }
    func hoursFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Hour, fromDate: date, toDate: self, options: []).hour
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour!
    }
    func minutesFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Minute, fromDate: date, toDate: self, options: []).minute
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute!
    }
    func secondsFrom(date:Date) -> Int{
        //        return NSCalendar.currentCalendar.components(.Second, fromDate: date, toDate: self, options: []).second
        return Calendar.current.dateComponents([.second], from: date, to: self).second!
    }
    func offsetFrom(date:Date) -> String
    {
        
        //use mins----> m ( for timestamp)  and use hrs---> h
        if yearsFrom(date: date) > 0 {
            if yearsFrom(date: date) == 1{
                return "\(hoursFrom(date: date)) year"
            }
            return "\(yearsFrom(date: date)) years"
        }
        if monthsFrom(date: date) > 0 {
            if monthsFrom(date: date) == 1{
                return "\(hoursFrom(date: date)) months"
            }
            return "\(monthsFrom(date: date)) month"
        }
        if weeksFrom(date: date) > 0{
            if weeksFrom(date: date) == 1{
                return "\(weeksFrom(date: date)) week"
            }
            return "\(weeksFrom(date: date)) weeks"
        }
        if daysFrom(date: date) > 0 {
            if daysFrom(date: date) == 1{
                return "\(daysFrom(date: date)) day"
            }
            return "\(daysFrom(date: date)) days"
        }
        if hoursFrom(date: date) > 0 {
            if hoursFrom(date: date) == 1{
                return "\(hoursFrom(date: date)) hr"
            }
            return "\(hoursFrom(date: date)) hrs"
        }
        if minutesFrom(date: date) > 0 {
            if minutesFrom(date: date) == 1{
                return "\(minutesFrom(date: date)) min"
            }
            return "\(minutesFrom(date: date)) mins"
        }
        if secondsFrom(date: date) > 0 {
            return "\(secondsFrom(date: date)) sec"
        }
        return ""
    }
   
}

//MARK: *************** Extension CLLocation ***************

extension CLLocation{
    func getCityName(_ City:@escaping (_ city:String)->Void){
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(self, completionHandler: { (placemarks, error) -> Void in
            
            // Place details
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            
            // Address dictionary
            print(placeMark.addressDictionary ?? "")
            
            // Location name
            if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
                print(locationName)
            }
            
            // Street address
            if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
                print(street)
            }
            
            // City
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                City(city as String)
                print(city)
            }
            
            // Zip code
            if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
                print(zip)
            }
            
            // Country
            if let country = placeMark.addressDictionary!["Country"] as? NSString {
                print(country)
            }
        })
    }
    
}


//MARK: *************** Extension String ***************

extension String {
    func UTCToLocal(formate : String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formate
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let dt = dateFormatter.date(from: self)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = formate
        return dateFormatter.string(from: dt!)
    }
    
    
    func getDateInstance(validFormate:String)-> Date? {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = validFormate
        dateFormater.date(from:self)
        return dateFormater.date(from:self)
    }
    
    func hasSpecialCharacter() -> Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if self.rangeOfCharacter(from: characterset.inverted) != nil {
            return true
        }
        return false
    }
    
   
    
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var isContainAnyNumber : Bool{
        let decimalCharacters = CharacterSet.decimalDigits
        let decimalRange = self.rangeOfCharacter(from: decimalCharacters)
        if decimalRange != nil {
            return true
        }
        else{
            return false
        }
    }
    
    var isContainAnyAlfabits : Bool {
        let str1 = self
        let str2 = self
        let capitalizedLetters = CharacterSet.capitalizedLetters
        let lowercaseLetters   = CharacterSet.lowercaseLetters
        let capitalRange = str1.rangeOfCharacter(from: capitalizedLetters)
        let lowerRange = str2.rangeOfCharacter(from: lowercaseLetters)

        if capitalRange != nil{
            return true
        }
        else if  lowerRange != nil{
            return true
        }
        else{
            return false
        }
    }
    
    
    func fromBase64() -> String?{
        let sDecode = self.removingPercentEncoding
        return sDecode
    }
}

//MARK: *************** Extension UIView ***************
extension UIView
{
    class func fromNib<T : UIView>(xibName: String) -> T {
        return Bundle.main.loadNibNamed(xibName, owner: nil, options: nil )![0] as! T
    }
    
    func typeName(_ some: Any) -> String {
        return (some is Any.Type) ? "\(some)" : "\(type(of: some))"
    }
    
    func makeRounded(){
            self.layer.cornerRadius = self.frame.size.width/2
            self.clipsToBounds = true
    }
    
    func makeRoundCorner(_ radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    func makeRoundCorner(){
        self.layer.cornerRadius = self.frame.height/2
        self.clipsToBounds = true
    }
    
    func makeBorder(_ width:CGFloat,color:UIColor)
    {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.clipsToBounds = true
    }
    
    //give the border to UIView
    func border(radius : CGFloat,borderWidth : CGFloat,color :CGColor){
        self.layer.masksToBounds = true
        self.layer.cornerRadius  = radius
        self.layer.borderWidth   = borderWidth
        self.layer.borderColor   = color
    }
    
    //give the circle border to UIView
    func circleBorder(){
        let hight = self.layer.frame.height
        let width = self.layer.frame.width
        if hight < width{
            self.layer.cornerRadius = hight/2
            self.layer.masksToBounds = true
        }
        else{
            self.layer.cornerRadius  = width/2
            self.layer.masksToBounds = true
        }
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 3, scale: Bool = true) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func addShadow(radius: CGFloat){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
        self.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
    }
    
    func addShadowWithRoundCorner(roundRadius:CGFloat, shadowRadius: CGFloat, shadowColor:UIColor = UIColor.black, shadowOpacity:Float = 0.5, shadowWidth:CGFloat = 1.0, shadowHeight:CGFloat = 1.0, borderWidth:CGFloat = 1.0) {
        self.layer.cornerRadius = roundRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.masksToBounds = true
        
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath

    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, UIScreen.main.scale)
        self.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func addShadowWithRadius(radius: CGFloat ,cornerRadius: CGFloat ){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = radius
        layer.cornerRadius = cornerRadius
    }
 
}


//MARK: *************** Global Helper Method ***************


func CGSizeMake(_ x: CGFloat, _ y: CGFloat) -> CGSize{
    return CGSize(width: x, height: y)
}


func arrayHasAnyLandscape(arrImage: [UIImage])-> (Bool,Int) {
    for (index,image) in arrImage.enumerated() {
        if image.size.width > image.size.height {
            return (true,index)
        }
    }
    return (false,0)
}

func arrayHasAnyPortrait(arrImage: [UIImage])-> (Bool,Int) {
    for (index,image) in arrImage.enumerated() {
        if image.size.width < image.size.height {
            return (true,index)
        }
    }
    return (false,0)
}

func setLanguage(_ lang:String){
    let path    =   Bundle.main.path(forResource: lang, ofType: "lproj")
    if path == nil{
        myBundle  = Bundle.main
    }
    else{
        myBundle = Bundle(path:path!)
        if (myBundle == nil) {
            myBundle = Bundle.main
        }
    }
}

func localized(_ key:String) -> String{
    return NSLocalizedString(key, tableName: "English", bundle: Bundle.main, value: "", comment: "")
}

func setUserDefault(_ key:String,value:String){
    print_debug(value)
    print_debug(key)
    let defaults = UserDefaults.standard
    defaults.setValue(value, forKey: key)
}

func getUserDefault(_ key:String) ->String{
    print_debug(key)
    let defaults = UserDefaults.standard
    let val = defaults.value(forKey: key)
    if val != nil{
        return val! as! String 
    }
    else{
        return ""
    }
}

func removeUserDefault(_ key:String){
    let defaults = UserDefaults.standard
    defaults.removeObject(forKey: key)
}

func setDictUserDefault(_ detail:Dictionary<String,Any>){
    for (key,value) in detail{
        if(detail[key] != nil){
            print_debug("\(key)")
            setUserDefault(key, value: "\(value)")
        }
    }
}

func heightForLabel(_ text:String,width:CGFloat,font:UIFont) -> CGFloat{
    let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = NSLineBreakMode.byWordWrapping
    label.font = font
    label.text = text
    label.sizeToFit()
    return label.frame.height
}

func print_debug<T>(_ obj:T,file: String = #file, line: Int = #line, function: String = #function) {
    print("File:'\(file.description)' Line:'\(line)' Function:'\(function)' ::\(obj)")
}

func uniq<S: Sequence, E: Hashable>(_ source: S) -> [E] where E==S.Iterator.Element {
    var seen: [E:Bool] = [:]
    return source.filter { seen.updateValue(true, forKey: $0) == nil }
}

//MARK: *************** Helper Class ***************

class SGHelper: NSObject {
    static let viewLogo = UIView()
    
    static func isLogin()->Bool{
        if getUserDefault(Constant.kIS_LOGIN) == "true"{
            return true
        }else{
            return false
        }
    }
    
    struct Platform {
        static var isSimulator: Bool {
            return TARGET_OS_SIMULATOR != 0 // Use this line in Xcode 7 or newer
            //return TARGET_IPHONE_SIMULATOR != 0 // Use this line in Xcode 6
        }
    }
    class func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    class func getDictionary(_ detail: Any?) -> Dictionary<String, Any>
    {
        guard let dict = detail as? Dictionary<String, Any> else
        {
            return ["":"" as Any]
        }
        return dict
    }
    class func convertArrayToString(arr:Array<Any>)->String{
        var retStr = ""
        for str in arr{
            if retStr != ""{
                retStr = "\(retStr),\(str)"
            }
            else{
                retStr = "\(str)"
            }
        }
        
        return retStr
    }
    
    
    func UTCToLocal(date:String) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyy-MM-dd hh:mm:ss"
        return dateFormatter.string(from: dt!)
    }
    // Write text on Image

    
}

//MARK: ************* Extension UIDatePicker *************

extension UIDatePicker {
    /// Returns the date that reflects the displayed date clamped to the `minuteInterval` of the picker.
    /// - note: Adapted from [ima747's](http://stackoverflow.com/users/463183/ima747) answer on [Stack Overflow](http://stackoverflow.com/questions/7504060/uidatepicker-with-15m-interval-but-always-exact-time-as-return-value/42263214#42263214})
    public var clampedDate: Date {
        let referenceTimeInterval = self.date.timeIntervalSinceReferenceDate
        let remainingSeconds = referenceTimeInterval.truncatingRemainder(dividingBy: TimeInterval(minuteInterval*60))
        let timeRoundedToInterval = referenceTimeInterval - remainingSeconds
        return Date(timeIntervalSinceReferenceDate: timeRoundedToInterval)
    }
}



