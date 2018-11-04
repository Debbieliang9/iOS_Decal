//
//  SGServiceController.swift
//  SG
//
//  Created by Salman Ghumsani on 7/1/16.
//  Copyright © 2016 Salman Ghumsani All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


let BASE_URL = "https://api-prod-1.toolowapp.com:443"


class SGServiceController: NSObject {
    
    var BASE_URL = "https://api-prod-1.toolowapp.com:443/"
    
    
   //"http://appsinvo.com/startup_space/public/api/getModerateFeedsByZipcode"
    
    //MARK: ************* GET INSTANCE *************
    class func instance() -> SGServiceController {
        return SGServiceController()
    }
    
    //MARK: ************* GET IMAGE WITH URL *************
    func getImage(_ url:String,handler: @escaping (UIImage?)->Void) {
        print(url)
        Alamofire.request(url, method: .get).responseImage { response in
            if let data = response.result.value {
                handler(data)
            } else {
                handler(nil)
            }
        }
    }
    
    //MARK: ============= HIT GET SERVICE =============
    func hitGetService(_ strURL:String,handler: @escaping((Dictionary<String,Any>?)-> Void),unReachable:(() -> Void)) {
        print_debug(strURL)
        if networkReachable() == false {
            unReachable()
        }
        let encodeURL   =   strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if encodeURL == nil {
            print_debug("We can't hit please check url")
            return
        }
        Alamofire.request(encodeURL!).responseJSON { response in
            //print_debug("Request: \(String(describing: response.request))")   // original url request
            //print_debug("Response: \(String(describing: response.response))") // http url response
            //print_debug("Result: \(response.result)")                         // response serialization result
            switch response.result {
            case .success:
                print(response.result.value ?? "")
                
                if let jsonDict = response.result.value as? Dictionary<String,Any> {
                    print_debug("Json Response: \(jsonDict)") // serialized json response
                    handler(jsonDict)
                }else if let arr = response.result.value as? Array<Dictionary<String,Any>> {
                    handler(["data":arr])
                }
                else{
                    handler(nil)
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Server Response: \(utf8Text)") // original server data as UTF8 string
                }
                break
            case .failure(let error):
                handler(nil)
                print_debug(error)
                break
            }
        }
    }
    //MARK: ============= HIT GET SERVICE WITH HEADER =============
    func hitGetServiceWithHeader(_ strURL:String,user: String ,password : String,handler: @escaping((Dictionary<String,Any>?)-> Void),unReachable:(() -> Void)) {
        print_debug(strURL)
        if networkReachable() == false {
            unReachable()
        }
        let encodeURL   =   strURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if encodeURL == nil {
            print_debug("We can't hit please check url")
            return
        }
 
        let credentialData = "\(user):\(password)".data(using: String.Encoding.utf8)!
        let base64Credentials = credentialData.base64EncodedString(options: [])
        let headers = ["Authorization": "Basic \(base64Credentials)"]
        
        Alamofire.request(encodeURL!, method: .get, headers: headers).responseJSON { response in
            
            switch response.result {
            case .success:
                print(response.result.value as Any)
                
                if let jsonDict = response.result.value as? Dictionary<String,Any> {
                    print_debug("Json Response: \(jsonDict)") // serialized json response
                    handler(jsonDict)
                }else if let arr = response.result.value as? Array<Dictionary<String,Any>> {
                    handler(["data":arr])
                }
                else{
                    handler(nil)
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Server Response: \(utf8Text)") // original server data as UTF8 string
                }
                break
            case .failure(let error):
                handler(nil)
                print_debug(error)
                break
            }
        }
    }
    
    
    
    //MARK: ************* HIT POST SERVICE JSON FORM*************
    func hitPostServiceJsonForm(_ params:Dictionary<String,Any>,unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?) -> Void)) {
        if networkReachable() == false {
            unReachable()
        }
        BASE_URL = "\(BASE_URL)check_email_phone"
        var request = URLRequest(url: URL(string: BASE_URL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

        
        print_debug(BASE_URL)
        Alamofire.request(request).responseString { response in
            //print_debug("Request: \(String(describing: response.request))")   // original url request
            //print_debug("Response: \(String(describing: response.response))") // http url response
            print_debug("Result: \(response.result)")
         
            if let status = response.response?.statusCode
            {
                switch(status)
                {
                case 200:
                    print(response.response as Any)
                    print("example success")
                case 500:
                    print("The response failed")
                default:
                    print("error with response status: \(status)")
                }
            }
            
            
            
            // response serialization result
            switch response.result {
            case .success:
                print(response.result.value as Any )
                if let jsonDict = response.result.value as? Dictionary<String,Any> {
                    print_debug("Json Response: \(jsonDict)") // serialized json response
                    handler(jsonDict)
                }
                else{
                    handler(nil)
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Server Response: \(utf8Text)") // original server data as UTF8 string
                }
                break
            case .failure(let error):
                handler(nil)
                print_debug(error)
                break
            }
        }
    }

    //MARK: HIT MULTIPART WITH IMAGE ARRAY
    func hitMultipartWith(_ params:Dictionary<String,String>,arrImage:[Data],arrName:String, url:String = "",unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?) -> Void)) {
        if networkReachable() == false {
            unReachable()
        }
        BASE_URL = "\(BASE_URL)\(params[Constant.kMETHOD]!)"
        print_debug(params)
        Alamofire.upload(multipartFormData: { multipartFormData in
            // import image to request
            for imageData in arrImage {//documents[]
                multipartFormData.append(imageData, withName: "\(arrName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
            }
            for (key, value) in params {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: BASE_URL,
           encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    if let jsonDict = response.result.value as? Dictionary<String,Any> {
                        print_debug("Json Response: \(jsonDict)") // serialized json response
                        handler(jsonDict)
                    }
                    else{
                        if let jsonArr = response.result.value as? Array<Dictionary<String,Any>> {
                            handler(["data":jsonArr])
                        }else {
                            handler(nil)
                        }
                    }
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Server Response: \(utf8Text)") // original server data as UTF8 string
                    }
                }
            case .failure(let error):
                handler(nil)
                print(error)
            }
        })
    }
    
     func hitMultipartWithImageVideo(_ params:Dictionary<String,String>,imageDict:[String:Any],videoDict:[String:Any], url:String = "",unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?) -> Void)) {
        
        if networkReachable() == false {
            unReachable()
        }
        BASE_URL = "\(BASE_URL)\(params[Constant.kMETHOD]!)"
        print_debug(params)
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in params {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            for key in imageDict.keys {//documents[]
                if imageDict[key] as? UIImage != nil{
                    let data = UIImageJPEGRepresentation( imageDict[key] as! UIImage, 0.5)
                    multipartFormData.append(data!, withName: key, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                }
            }
            
            for key in videoDict.keys {//documents[]
                if videoDict[key] as? URL != nil{
                    let dat = videoDict[key] as! URL
                    let data : Data?
                    
                    do {
                        data = try Data(contentsOf: dat)
                        print(data as Any)
                        multipartFormData.append( data! , withName: key, fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
                    } catch {
                        print("Unable to load data: \(error)")
                    }
                    
                    //    let data = Data
                    
                }
                else{
                    print("empty")
                }
            }
            
        }, usingThreshold: UInt64.init(), to: BASE_URL, method: .post, headers: headers) { (result) in
            
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    if let jsonDict = response.result.value as? Dictionary<String,Any> {
                        print_debug("Json Response: \(jsonDict)") // serialized json response
                        handler(jsonDict)
                    }
                    else{
                        if let jsonArr = response.result.value as? Array<Dictionary<String,Any>> {
                            handler(["data":jsonArr])
                        }else {
                            handler(nil)
                        }
                    }
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        print("Server Response: \(utf8Text)") // original server data as UTF8 string
                    }
                }
            case .failure(let error):
                handler(nil)
                print(error)
            }
        }
    }
    
    
    
//    func hitMultipartWithImageVideo(_ params:Dictionary<String,String>,imageDict:[String:Any],videoDict:[String:Any], url:String = "",unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?) -> Void)) {
//        if networkReachable() == false {
//            unReachable()
//        }
//        BASE_URL = "\(BASE_URL)\(params[Constant.kMETHOD]!)"
//        print_debug(params)
//        Alamofire.upload(multipartFormData: { multipartFormData in
//            // import image to request
//            for key in imageDict.keys {//documents[]
//                if imageDict[key] as? UIImage != nil{
//                    let data = UIImageJPEGRepresentation( imageDict[key] as! UIImage, 0.5)
//                    multipartFormData.append(data!, withName: key, fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//                }
//            }
//
//            // import video to request
//            for key in videoDict.keys {//documents[]
//                if imageDict[key] != nil{
//                    let dat = imageDict[key] as! URL
//                    let data : Data?
//
//                    do {
//                        data = try Data(contentsOf: dat)
//                        multipartFormData.append( data! , withName: key, fileName: "\(Date().timeIntervalSince1970).mp4", mimeType: "video/mp4")
//                    } catch {
//                        print("Unable to load data: \(error)")
//                    }
//
//                //    let data = Data
//
//                }
//            }
//
//            // multipartFormData.append(imageData, withName: "\(arrName)[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//
//            for (key, value) in params {
//                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
//            }
//        }, to: BASE_URL,
//           encodingCompletion: { encodingResult in
//            switch encodingResult {
//            case .success(let upload, _, _):
//                upload.responseJSON { response in
//                    print(response)
//                    if let jsonDict = response.result.value as? Dictionary<String,Any> {
//                        print_debug("Json Response: \(jsonDict)") // serialized json response
//                        handler(jsonDict)
//                    }
//                    else{
//                        if let jsonArr = response.result.value as? Array<Dictionary<String,Any>> {
//                            handler(["data":jsonArr])
//                        }else {
//                            handler(nil)
//                        }
//                    }
//                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                        print("Server Response: \(utf8Text)") // original server data as UTF8 string
//                    }
//                }
//            case .failure(let error):
//                handler(nil)
//                print(error)
//            }
//        })
//    }
    
    
    
    //MARK: *********** HIT POST SERVICE ***********
    func hitPostService(_ params:Dictionary<String,String>,url:String = "",unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?) -> Void)) {
        if networkReachable() == false {
            unReachable()
        }
        BASE_URL = "\(BASE_URL)\(params[Constant.kMETHOD]!)"
        print_debug(params)
        print_debug(BASE_URL)
        Alamofire.request(BASE_URL, method: .post, parameters: params, encoding: URLEncoding.default).responseJSON { response in
            print_debug("Request: \(String(describing: response.request))")
            // original url request
            print_debug("Response: \(String(describing: response.response))")
            
            print_debug(response.data)
              print_debug(response.value)
            // http url response
            print_debug("Result: \(response.result)")
            // response serialization result
            switch response.result {
            case .success:
                if let jsonDict = response.result.value as? Dictionary<String,Any> {
                    print_debug("Json Response: \(jsonDict)")
                    handler(jsonDict)
                }
                else{
                    if let jsonArr = response.result.value as? Array<Dictionary<String,Any>> {
                        handler(["data":jsonArr])
                    }else {
                        handler(nil)
                    }
                }
                if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                    print("Server Response: \(utf8Text)")
                    // original server data as UTF8 string
                }
                break
            case .failure(let error):
                handler(nil)
                print_debug(error)
                break
            }
        }
        
    }
    
    //MARK: ************* MULTIPART SERVICES *************
    func hitMultipartForImage(_ params:Dictionary<String,String>,url:String = "",imageInfo:Dictionary<String,UIImage>,unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?,Int) -> Void)) {
       // let keyJson = "json".dataUsingEncoding(NSUTF8StringEncoding)!
        print_debug("Params:\(params)")
        BASE_URL = "\(BASE_URL)\(params[Constant.kMETHOD]!)"
      
        Alamofire.upload(
            
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if "appendURL" != key {
                        //print_debug("\(key) == \(value)")
                        multipartFormData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
                for (_,info) in imageInfo.enumerated() {
                    let imgData = UIImageJPEGRepresentation(info.value, 0.4)
                    if imgData != nil {
                        print_debug("img data available")
                        multipartFormData.append(imgData!, withName: info.key, fileName: "file.png", mimeType: "image/png")
                    }
                }
        },
            to: BASE_URL,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                   
                        switch response.result {
                        case .success:
                            if let jsonDict = response.result.value as? Dictionary<String,Any> {
                                print_debug("Json Response: \(jsonDict)") // serialized json response
                                handler(jsonDict,(response.response!.statusCode))
                            }
                            else{
                                handler(nil,(response.response!.statusCode))
                            }
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Server Response: \(utf8Text)") // original server data as UTF8 string
                            }
                            break
                        case .failure(let error):
                            handler(nil,(response.response!.statusCode))
                            print_debug(error)
                            break
                        }
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        }
        )
    }
    
    func hitMultipartOnlyParam(_ params:Dictionary<String,String>,unReachable:(() -> Void),handler:@escaping ((Dictionary<String,Any>?) -> Void))
    {
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if "method" != key {
                        //print_debug("\(key) == \(value)")
                        multipartFormData.append(value.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: key)
                    }
                }
        },
            to: "https://httpbin.org/post",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON  { response in
                        if let jsonDict = response.result.value as? Dictionary<String,Any> {
                            print_debug("Json Response: \(jsonDict)") // serialized json response
                            handler(jsonDict)
                        }
                        else{
                            handler(nil)
                        }
                        if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                            print("Server Response: \(utf8Text)") // original server data as UTF8 string
                        }
                    }
                    break
                case .failure(let encodingError):
                    handler(nil)
                    print_debug(encodingError)
                    break
                }
        }
        )
    }
}
//MARK: ************* CHECK NETWORK REACHABILITY *************
func networkReachable() -> Bool {
    return (NetworkReachabilityManager()?.isReachable)!
}

