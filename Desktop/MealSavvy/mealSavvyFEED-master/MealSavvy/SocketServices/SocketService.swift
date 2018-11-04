//
//  SocketService.swift
//  MealSavvy
//

import UIKit
import SocketIO
import ObjectMapper
import CoreLocation
import DateToolsSwift

class SocketService: NSObject {
    
    static let shared = SocketService ()
    private var manager: SocketManager!
    private var socket: SocketIOClient!
    private var ackQueues = [OnAckCallback]()
    
    var socketStatus: SocketIOStatus {
        get {
            return socket.status
        }
    }
    
    override init() {
        super.init()
        manager = SocketManager(socketURL: URL(string: SSConfig.URLs.socket)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
    }
    
    func connect () {
        socket.on(clientEvent: .connect) { (data, ack) in
            NotificationCenter.default.post(name: NotificationNames.socketConnected, object: nil)
        }
        socket.connect()
    }
    
    func disconnect () {
        socket.disconnect()
    }

    // MARK: - Auth Handler
    func checkEmailPhone (_ email: String, phone: String, completion: @escaping(UserModel?, String?) -> Void) {
        
        socket.once(SSConfig.EventNames.checkEmailPhone) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                        
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            }else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["email" : email,
                    "phone" : phone] as [String:Any]
        socket.emit(SSConfig.EventNames.checkEmailPhone, ["data" : data])
    }
    
    func signIn (_ fbToken: String, deviceToken: String, completion: @escaping(UserModel?, String?) -> Void) {
        socket.once(SSConfig.EventNames.signin) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["fb_token" : fbToken,
                    "deviceType" : "Ios",
                    "device_token" : deviceToken,
                    "user_agent" : ["os_version" : UIDevice.current.systemVersion,
                                    "mobile_timestamp" : Date().timeIntervalSinceNow * 1000
            ]
            ] as [String:Any]
        print(data)
        socket.emit(SSConfig.EventNames.signin, ["data" : data])
    }
    
    
    func signIn (_ hid: String, password: String, isEncrypted: Bool, deviceToken: String, completion: @escaping(UserModel?, String?) -> Void) {
        socket.once(SSConfig.EventNames.signin) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }

        let data = ["hid" : hid,
                    "password" : password,
                    "has_encrypted" : isEncrypted ? 1 : 0,
                    "deviceType" : "iOS",
                    "device_token" : deviceToken,
                    "user_agent" : ["os_version" : UIDevice.current.systemVersion,
                                    "mobile_timestamp" : Date().timeIntervalSinceNow * 1000
            ]
        ] as [String:Any]
        socket.emit(SSConfig.EventNames.signin, ["data" : data])
    }
    
    // MARK: - Signup
    
    func signUp (_ phone: String, email: String, password: String, first_name: String,last_name : String, deviceToken: String,address : String, images : Array<Data>,longitude : String,latitude : String ,isEncrypted: Bool ,completion: @escaping(UserModel?, String?) -> Void) {
        socket.once(SSConfig.EventNames.signup) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = [ "country_code"     : "",
                    "sex"              : "M",
                    "dob_day"          : 12,
                    "dob_month"        : 12,
                    "dob_year"         : 1991,
                    "ambassador_hid": "000-000-000-001", // required
                    "is_random_ambassador": 1,
                    "phone"          : phone,
                    "email"         : email,
                    "first_name"     : first_name,
                    "last_name"      : last_name,
                    "password"       : password,
                    "address"        : address,
                    "images"         : images,
                    "has_encrypted"  : isEncrypted ? 1 : 0,
                    "deviceType"     : "iOS",
                    "longitude"      : longitude,
                    "device_token"   : deviceToken,
                    "latitude"       : latitude,
                    "zip"            : "0031",
                    "user_agent"     : ["os_version" : UIDevice.current.systemVersion,
                                    "mobile_timestamp" : Date().timeIntervalSinceNow * 1000
            ]
            ] as [String:Any]
        socket.emit(SSConfig.EventNames.signup, ["data" : data])
    }
    
    // MARK: - Logout
    func logout (completion: @escaping(UserModel?, String?) -> Void) {
        socket.once(SSConfig.EventNames.logout) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                        
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = [ "token"     : (GlobalData.shared.me?.token)!,
                     "user_agent"     : ["os_version" : UIDevice.current.systemVersion,
                                "mobile_timestamp" : Date().timeIntervalSinceNow * 1000
            ]] as [String:Any]
        socket.emit(SSConfig.EventNames.logout, ["data" : data])
    }
    
    func doMealPlan (type:String, promocode:String, card:CreditCardModel, completion: @escaping(SubscriberModel?, String?) -> Void) {
        
        socket.on(SSConfig.EventNames.subscriptionMealPlan) {(data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    print(response.data)
                    if response.success {
                        if let subscription = Mapper<SubscriberModel>().map(JSON: response.data as! [String : Any]) {
                            completion(subscription, nil)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                    else {
                        completion(nil, SSConfig.Messages.invalidData)
                    }
                }
                else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            }
            else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let cardDetail = ["number":card.number,
                          "expiration":card.expiration,
                          "cvc":card.cvc!,
                          "last_name":card.lastName,
                          "first_name":card.firstName,
                          "postal_code":card.postalCode,
                          "default":"0",
                          "payment_type":"",
                          "payment_processor_type":"Authorize.net",
                          "is_update":"0",
                          ]

        
        let data = ["type" : type,
                    "token" : (GlobalData.shared.me?.token)!,
                    "promo_code" : promocode,
                    "credit_cards":cardDetail
                    ] as [String:Any]
        
        socket.emit(SSConfig.EventNames.subscriptionMealPlan, ["data" : data])
    }
    
    func updateUserInfo (_ hid: String, token: String, deviceToken: String, completion: @escaping(UserModel?, String?) -> Void) {
        
        socket.on(SSConfig.EventNames.updateUserInfo) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            print(response.data)
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        let profile:ProfileModel = (GlobalData.shared.me?.profile)!
        let cards:[CreditCardModel] = profile.creditCards
        let data = NSMutableDictionary()
        
        if (cards.count > 0) {
            let arrayCards = NSMutableArray()
            
            for card:CreditCardModel in cards {
                let dictCard = NSMutableDictionary()
                dictCard["cardNumberHash"] = card.cardNumberHash
                dictCard["number"] = card.number
                dictCard["expiration"] = card.expiration
                dictCard["cvc"] = card.cvc
                dictCard["first_name"] = card.firstName
                dictCard["last_name"] = card.lastName
                dictCard["token"] = card.token
                dictCard["default"] = 1
                dictCard["card_type"] = card.cardType
                dictCard["payment_type"] = card.paymentType
                dictCard["postal_code"] = card.postalCode
                dictCard["payment_processor_type"] = card.paymentProcessorType
                dictCard["isUpdate"] = 1
                arrayCards.add(dictCard)
            }
            data["credit_cards"] = arrayCards
        }
        data["token"] = token
        data["phone"] = profile.phone
        data["zip"] = profile.zip
        socket.emit(SSConfig.EventNames.updateUserInfo, ["data" : data])
        
        
//        let data = [
//                    "token" : token,
//                    "country_code"     : "",
//                    "sex"              : profile.sex,
//                    "dob_day"          : profile.dobDay,
//                    "dob_month"        : profile.dobMonth,
//                    "dob_year"         : profile.dobYear,
//                    "ambassador_hid": profile.ambassadorHid, // required
//                    "is_random_ambassador": 1,
//                    "phone"          : profile.phone,
//                    "email"         : profile.email            ,
//                    "first_name"     : profile.firstName,
//                    "last_name"      : profile.lastName,
//                    "password"       : profile.password,
//                    "address"        : profile.address,
//                    "images"         : profile.images,
//                    "has_encrypted"  : 1,
//                    "deviceType"     : "iOS",
//                    "longitude"      : profile.longitude,
//                    "device_token"   : deviceToken,
//                    "latitude"       : profile.latitude,
//                    "zip"            : profile.zip,
//                    "user_agent"     : ["os_version" : UIDevice.current.systemVersion,
//                                "mobile_timestamp" : Date().timeIntervalSinceNow * 1000],
//                    "credit_cards"  : [{
//                        "cardNumberHash" : "aadb3b16-33f2-4305-aac7-a57ed917f964",
//                        "number" : perCard.number!,
//                        "expiration" : perCard.expiration!,
//                        "cvc": perCard.cvc!,
//                        "first_name" : perCard.firstName!,
//                        "last_name" :perCard.lastName!,
//                        "token" : perCard.token!,
//                        "default": perCard.isDefault ? 1: 0,
//                        "card_type": perCard.cardType!,
//                        "payment_type": perCard.paymentType!,
//                        "postal_code" : perCard.postalCode!,
//                        "payment_processor_type" : perCard.paymentProcessorType!,
//                        "is_update" : 1
//                        }]
//                    ]
//        print(data)
//
//        socket.emit(SSConfig.EventNames.updateUserInfo, ["data" : data])
    }
    
    // MARK: - User Handler
    func getUserInfo (_ hid: String, token: String, deviceToken: String, completion: @escaping(UserModel?, String?) -> Void) {
        
        socket.on(SSConfig.EventNames.getUserInfo) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        if let user = Mapper<UserModel>().map(JSON: response.data as! [String : Any]) {
                            completion(user, nil)
                        } else {
                            completion(nil, "Cannot get user data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["hid" : hid,
                    "token" : token,
                    "device_token" : deviceToken] as [String:Any]
        
        socket.emit(SSConfig.EventNames.getUserInfo, ["data" : data])
    }
    
    // Get Supplier Detail
    func getSupplierDetail (_ supplierId: String, completion: @escaping([ServiceModel]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.supplierDetail) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        
                        var dataSupplier = response.data as! [String : Any]
                        
                        if let supplier = Mapper<SupplierModel>().map(JSON: dataSupplier["supplier"] as! [String:Any]) {
                            completion(supplier.services, nil)
                        } else {
                            completion(nil, "Cannot get restaurant data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let location = GlobalData.shared.userLocation
        
        let data = ["supplier_id" : supplierId,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude]
                    ] as [String:Any]
        print(data)
        socket.emit(SSConfig.EventNames.supplierDetail, ["data" : data])
    }
    
    // MARK: - Get Cuisines Handler
    func getCuisines (_ search: String, location: CLLocation, completion: @escaping([CuisineModel]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getCuisines) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let cuisines = response.data as? [[String : Any]] {
                            completion(Mapper<CuisineModel>().mapArray(JSONArray: cuisines), nil)
                            
                        } else {
                            completion(nil, "Cannot get cuisine data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "search" : search,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude],
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.getCuisines, ["data" : data])
    }
    
    // MARK: - Get Cuisines Handler
    func searchCuisines (_ search: String, location: CLLocation, completion: @escaping([CuisineModel]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.searchCuisines) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let cuisines = response.data as? [[String : Any]] {
                            completion(Mapper<CuisineModel>().mapArray(JSONArray: cuisines), nil)
                            
                        } else {
                            completion(nil, "Cannot get cuisine data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "search" : search,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude],
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.searchCuisines, ["data" : data])
    }
    
    func getDynamicSlot()-> [String: String] {
        let startTime = Date().hour
        let startMinut = Date().minute
        let endTime = startTime + 1
        print(["start":"\(startTime):\(startMinut)","end":"\(endTime):\(startMinut)","date":"\(Date().convertToString("YYYY-MM-dd"))"])
        return ["start":"\(startTime):\(startMinut)","end":"\(endTime):\(startMinut)","date":"\(Date().convertToString("YYYY-MM-dd"))"]
    }
    
    func checkBooking(_ book:BookModel, completion: @escaping(BookModel?, String?) -> Void) {
        socket.on(SSConfig.EventNames.bookingStatus) {(data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        
                        print(response.data)
                        
                        if let book = Mapper<BookModel>().map(JSON: response.data as! [String : Any]) {
                            completion(book, nil)
                        } else {
                            completion(nil, "Cannot get booking data!")
                        }
                    }
                    else {
                        completion(nil, SSConfig.Messages.invalidData)
                    }
                }
            }
            else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["booking_id" : book.booking_id,
                    "token" : (GlobalData.shared.me?.token)!
            ] as [String:Any]
        
        socket.emit(SSConfig.EventNames.bookingStatus, ["data" : data])
    }
    
    func cancelOrder(_ book:BookModel, status:String, completion: @escaping(BookModel?, String?) -> Void) {
        
        socket.on(SSConfig.EventNames.cancelOrder) {(data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        
                        if let book = Mapper<BookModel>().map(JSON: response.data as! [String : Any]) {
                            completion(book, nil)
                        } else {
                            completion(nil, "Cannot get booking data!")
                        }
                    }
                    else {
                        completion(nil, SSConfig.Messages.invalidData)
                    }
                }
            }
            else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["booking_id" : book.booking_id!,
                    "token" : (GlobalData.shared.me?.token)!,
                    "status" : status
            ] as [String:Any]
        print(data)
        socket.emit(SSConfig.EventNames.cancelOrder, ["data" : data])
    }
    
    func bookingService(_ services:[ServiceModel], comment:String, price:Float, technicianId:String, completion: @escaping(BookModel?, String?) -> Void) {
        
        socket.on(SSConfig.EventNames.serviceBooking) {(data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        
                        if let book = Mapper<BookModel>().map(JSON: response.data as! [String : Any]) {
                           completion(book, nil)
                        } else {
                            completion(nil, "Cannot get booking data!")
                        }
                    }
                    else {
                        print(response.data)
                        completion(nil, SSConfig.Messages.invalidData)
                    }
                }
            }
            else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        var serviceIds:[String] = []
        for perService:ServiceModel in services {
            serviceIds.append(perService.serviceId)
        }
        
        var cardNumberHash = ""
        
        if GlobalData.shared.me?.profile.creditCards.count != 0 {
            cardNumberHash = (GlobalData.shared.me?.profile.creditCards[0].cardNumberHash)!
        }
        else {
            cardNumberHash = ""
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "service_id" : serviceIds,
                    "comment": comment,
                    "price": price,
                    "technician_id" : technicianId,
                    "slot": getDynamicSlot(),
                    "is_balance": "0",
                    "cardNumberHash" : cardNumberHash,
                    "time" : Date().format(with: DateFormat.date)
            ] as [String:Any]
        print(data)
        socket.emit(SSConfig.EventNames.serviceBooking, ["data" : data])
    }
    
    func bookWithToken(_ services:[ServiceModel], comment:String, price:Float, technicianId:String, completion: @escaping(BookModel?, String?) -> Void) {
        
        socket.on(SSConfig.EventNames.serviceSubscriptionRedeem) {(data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        
                        if let book = Mapper<BookModel>().map(JSON: response.data as! [String : Any]) {
                            completion(book, nil)
                        } else {
                            completion(nil, "Cannot get booking data!")
                        }
                    }
                    else {
                        completion(nil, SSConfig.Messages.invalidData)
                    }
                }
            }
            else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        var serviceIds:[String] = []
        for perService:ServiceModel in services {
            serviceIds.append(perService.serviceId)
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "service_id" : serviceIds,
                    "comment": comment,
                    "price": price,
                    "technician_id" : technicianId,
                    "coupon_code":"",
                    "slot": getDynamicSlot(),
                    "time" : Date().format(with: DateFormat.date)
            ] as [String:Any]
        
        print(data)
        socket.emit(SSConfig.EventNames.serviceSubscriptionRedeem, ["data" : data])
    }

    
    // MARK: - CUISINE : GET_SUB
    func getSubCuisines (_ search: String,tag : String, location: CLLocation, completion: @escaping([SubCuisine]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getCuisinesSub) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        
                        if let cuisines = response.data as? [String : Any] {
                            print(cuisines)
                            let data = cuisines["categories"]
                            completion(Mapper<SubCuisine>().mapArray(JSONArray: data as! [[String : Any]]), nil)
                        } else {
                            completion(nil, "Cannot get cuisine data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "search" : search,
                    "tag"    : tag,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude],
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.getCuisinesSub, ["data" : data])
    }
    
    // MARK: - Get Restaurants Handler
    func getRestaurants (_ search: String, location: CLLocation, completion: @escaping([RestaurantModel]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getRestaurants) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let restaurants = response.data as? [[String : Any]] {
                            completion(Mapper<RestaurantModel>().mapArray(JSONArray: restaurants), nil)
                        } else {
                            completion(nil, "Cannot get restaurant data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "search" : search,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude],
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.getRestaurants, ["data" : data])
    }
    
    // MARK: - Get Restaurants Handler
    func getFavorites (_ search: String, location: CLLocation, completion: @escaping([RestaurantModel]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getFavoites) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let restaurants = response.data as? [[String : Any]] {
                            completion(Mapper<RestaurantModel>().mapArray(JSONArray: restaurants), nil)
                        } else {
                            completion(nil, "Cannot get restaurant data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "search" : search,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude],
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.getFavoites, ["data" : data])
    }
    
    func searchFavorites (_ search: String, location: CLLocation, completion: @escaping([RestaurantModel]?, String?) -> Void)  {
        socket.on(SSConfig.EventNames.searchFavorites) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let restaurants = response.data as? [[String : Any]] {
                            completion(Mapper<RestaurantModel>().mapArray(JSONArray: restaurants), nil)
                        } else {
                            completion(nil, "Cannot get restaurant data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "keyword" : search,
                    "location" : ["longitude" : location.coordinate.longitude,
                                  "latitude" : location.coordinate.latitude],
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.getCuisines, ["data" : data])
    }
    
    // MARK: - Forgate Password
    func forgotPassword(_ hid: String, completion: @escaping(Bool?, String?) -> Void) {
        socket.on(SSConfig.EventNames.forgotPassword) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                       completion(true,nil)
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        let data = ["hid" : hid]
        socket.emit(SSConfig.EventNames.forgotPassword, ["data" : data])
    }
    

    
    // MARK: - Forgate Password
    func forgotHumanID(_ email: String, completion: @escaping(Dictionary<String,Any>?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getProfileByEmail) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let profile  = response.data as? [String : Any] {
                            completion(profile, nil)
                        } else {
                            completion(nil, "Cannot get restaurant data!")
                        }
                        print(response.data)
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["email" : email]
        socket.emit(SSConfig.EventNames.getProfileByEmail, ["data" : data])
    }
    
    
    
    // MARK: - Time Slot  - > (Booking)
    func getTimeSlot (_ service_id  : String, completion: @escaping(String?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getTimeSlot) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        var dicData = response.data as! [String:Any]
                        if let slot = dicData["time_slots"] as? [[String:Any]], slot.count > 0 {
                            if let technicians = slot[0]["technicians"] as? [[String:Any]],technicians.count > 0 {
                                let id = technicians[0]["technician_id"] as? String ?? ""
                                completion(id, nil)
                            }
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "service_id" : service_id,
                    "date" : Date().format(with: DateFormat.date),
                    "current_time" : Date().format(with: DateFormat.dateTime)] as [String:Any]
        socket.emit(SSConfig.EventNames.getTimeSlot, ["data" : data])
    }
    

    // MARK: - getPaymentHistory
    func getPaymentHistory (completion: @escaping([PaymentHistoryModel]?, String?) -> Void) {
        socket.on(SSConfig.EventNames.getPaymentHistory) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        print(response.data)
                        let dataHistory = response.data as! [String : Any]
                        print(dataHistory["history_list"])
                        
                        completion(Mapper<PaymentHistoryModel>().mapArray(JSONArray: dataHistory["history_list"] as! [[String : Any]]), nil)

                        
//                        if let cuisines = Mapper<PaymentHistoryModel>().map(JSON: dataHistory["history_list"] as! [String:Any]) {
//                            completion(cuisines, nil)
//                        } else {
//                            completion(nil, "Cannot get  Time Slot data!")
//                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion(nil, errorData.message)
                        } else {
                            completion(nil, SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion(nil, SSConfig.Messages.invalidData)
                }
            } else {
                completion(nil, SSConfig.Messages.unkownError)
            }
        }
        
        let data = ["token" : (GlobalData.shared.me?.token)!,
                    "page_index" : "1",
                    "page_size" : "100",
//                    "supplier_id" : GlobalData.shared.me?.profile.hid,
                   ] as [String:Any]
        socket.emit(SSConfig.EventNames.getPaymentHistory, ["data" : data])
    }
    
    // MARK: - Help
    func getHelpText (completion:  @escaping(String, String?) -> Void) {
        socket.on(SSConfig.EventNames.getHelp) { (data, ack) in
            if data.count > 0 {
                if let json = data[0] as? [String : Any], let response = Mapper<SocketResponse>().map(JSON: json) {
                    if response.success {
                        if let cuisines = response.data as? [String : Any] {
                            completion(cuisines["message"] as? String ?? "", nil)
                        } else {
                            completion("", "Cannot get data!")
                        }
                    } else {
                        if let errorDict = response.data as? [String : Any], let errorJson = errorDict.values.first as? [String : Any], let errorData = Mapper<SocketErrorData>().map(JSON: errorJson) {
                            completion("", errorData.message)
                        } else {
                            completion("", SSConfig.Messages.invalidData)
                        }
                    }
                } else {
                    completion("", SSConfig.Messages.invalidData)
                }
            } else {
                completion("", SSConfig.Messages.unkownError)
            }
        }
    
        socket.emit(SSConfig.EventNames.getHelp, ["data" : []])
    }
    func getSocialFeed (completion:  @escaping([SocialFeedModel]?, String?) -> Void){
        
        let data = hardcoded_data
        completion(Mapper<SocialFeedModel>().mapArray(JSONArray: data as! [[String : Any]]), nil)
        
        
    }
}