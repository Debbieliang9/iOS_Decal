//
//  ServiceModel.swift
//  MealSavvy
//

import ObjectMapper

class ServiceModel: Mappable {
    
    var allSold         : Bool!
    var baseServiceId   : String!
    var serviceId       : String!
    var distance        : Float!
    var timeWalking     : String!
    var name            : String!
    var normalPrice     : Float!
    var price           : Float!
    var supplierLatitude : Float!
    var supplierLongitude : Float!
    var rank            : Int!
    var tip             : String!
    var type            : String!
    var unitName        : String!
    var supplierName    : String!
    var supplierAddress : String!
    var supplierCity    : String!
    var supplierZip     : String!
    var supplierState   : String!
    var supplierImage   : String!
    var image           : String!
    var tokens          : String!
    var description     : String!
    
    init() {
        allSold         = false
        baseServiceId   = ""
        serviceId       = ""
        distance        = 0.0
        timeWalking     = ""
        name            = ""
        normalPrice     = 0.0
        price           = 0.0
        supplierLatitude = 0.0
        supplierLongitude = 0.0
        rank            = 0
        tip             = ""
        type            = ""
        unitName        = ""
        supplierName    = ""
        supplierAddress = ""
        supplierCity    = ""
        supplierZip     = ""
        supplierState   = ""
        supplierImage   = ""
        image           = ""
        tokens          = ""
        description     = ""
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        print(map.JSON)
        
        print(map.JSON["distance"])
        if map.JSON["time_walking"] != nil {
            print(map.JSON["time_walking"])
            let intTimeWalking = map.JSON["time_walking"] as? Int
            if intTimeWalking != nil {
                timeWalking = String(map.JSON["time_walking"] as! Int)
            }
        }
        
        if map.JSON["all_sold"] != nil {
            print(map.JSON["all_sold"])
            let intAllSold = map.JSON["all_sold"] as? Int
            if intAllSold != nil {
                if intAllSold == 1 {
                    allSold = true
                }
            }
        }
        
        baseServiceId   <- map["base_service_id"]
        serviceId       <- map["service_id"]
        distance        <- (map["distance"], TypeTransform.float)
        supplierLongitude <- (map["supplier_longitude"], TypeTransform.float)
        supplierLatitude <- (map["supplier_latitude"], TypeTransform.float)

//        timeWalking     <- dicTime_walking
        name            <- map["name"]
        
        if map.JSON["normal_price"] == nil {
            normalPrice     <- (map["min_price"], TypeTransform.float)
        }
        else {
            normalPrice     <- (map["normal_price"], TypeTransform.float)
        }
        
        if map.JSON["proxy_price"] == nil {
            price           <- (map["price"], TypeTransform.float)
        }
        else {
            price           <- (map["proxy_price"], TypeTransform.float)
        }
        rank            <- (map["rank"], TypeTransform.int)
        tip             <- map["tip"]
        type            <- map["type"]
        unitName        <- map["unit_name"]
        supplierName    <- map["supplier_name"]
        supplierAddress <- map["supplier_address"]
        supplierCity    <- map["supplier_city"]
        supplierZip     <- map["supplier_zip"]
        supplierState   <- map["supplier_state"]
        supplierImage   <- map["supplier_image"]
        print(map.JSON["image"])
        image           <- map["image"]
        tokens          <- map["tokens"]
        description     <- map["description"]
    }
}
