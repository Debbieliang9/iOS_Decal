//
//  UserModel.swift
//  MealSavvy
//

import ObjectMapper

class UserModel: Mappable {
    
    var token              : String!
    var hid                : String!
    var authNum            : Int!
    var isSupplier         : Bool!
    var isTechnician       : Bool!
    var profile            : ProfileModel!
    var reviews            : [ReviewModel]!
    var cart               : [ServiceModel]!
    var currentVersion     : String!
    var ambassadorEditable : Bool!
    var totalPerson        : Int!
    var deviceTokenHid     : String!
    
    init() {
        token              = ""
        hid                = ""
        authNum            = 0
        isSupplier         = false
        isTechnician       = true
        profile            = ProfileModel()
        cart               = []
        reviews            = []
        currentVersion     = ""
        ambassadorEditable = false
        totalPerson        = 0
        deviceTokenHid     = ""
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        token               <- map["token"]
        hid                 <- map["hid"]
        authNum             <- (map["auth_num"], TypeTransform.int)
        isSupplier          <- (map["is_supplier"], TypeTransform.bool)
        isTechnician        <- (map["is_technician"], TypeTransform.bool)
        profile             <- map["profile"]
        reviews             <- map["reviews"]
        currentVersion      <- map["current_version"]
        ambassadorEditable  <- (map["ambassador_editable"], TypeTransform.bool)
        totalPerson         <- (map["total_person"], TypeTransform.int)
        deviceTokenHid      <- map["device_token_hid"]
    }
    
    func update (_ user: UserModel) {
//        if let _ = user.token {
//            self.token = user.token
//        }
//
//        if let _ = user.authNum {
//            self.authNum = user.authNum
//        }
        
        if let _ = user.isSupplier {
            self.isSupplier = user.isSupplier
        }

        if let _ = user.isTechnician {
            self.isTechnician = user.isTechnician
        }
        
        if let _ = user.profile {
            self.profile = user.profile
        }
        
//        if let _ = user.reviews {
//            self.reviews.removeAll()
//            self.reviews.append(contentsOf: user.reviews)
//        }

        if let _ = user.currentVersion {
            self.currentVersion = user.currentVersion
        }

        if let _ = user.ambassadorEditable {
            self.ambassadorEditable = user.ambassadorEditable
        }

        if let _ = user.totalPerson {
            self.totalPerson = user.totalPerson
        }

        if let _ = user.deviceTokenHid {
            self.deviceTokenHid = user.deviceTokenHid
        }
    }
}
