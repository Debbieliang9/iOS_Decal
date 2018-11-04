//
//  ProfileModel.swift
//  MealSavvy
//

import ObjectMapper

class ProfileModel: Mappable {
    
    var hid              : String!
    var ambassadorHid    : String!
    var ambassadorName   : String!
    var ambassadorAvatar : String!
    var countryCode      : String!
    var phone            : String!
    var email            : String!
    var password         : String!
    var sex              : String!
    var dobDay           : Int!
    var dobMonth         : Int!
    var dobYear          : Int!
    var firstName        : String!
    var lastName         : String!
    var address          : String!
    var address2         : String!
    var workAddress      : String!
    var city             : String!
    var state            : String!
    var zip              : String!
    var residenceCountry : String!
    var citizenCountry   : String!
    var timeZone         : String!
    var longitude        : Double!
    var latitude         : Double!
    var subscriber       : Bool!
    var subscriberInfo   : SubscriberModel!
    var creditCards      : [CreditCardModel]!
    var cashOutMethods   : [CashOutMethodModel]!
    var images           : [String]!
    var totalAmount      : Int!
    var availableAmount  : Int!
    var currencies       : [String]!
    
    init() {
        hid              = ""
        ambassadorHid    = ""
        ambassadorName   = ""
        ambassadorAvatar = ""
        countryCode      = ""
        phone            = ""
        email            = ""
        password         = ""
        sex              = "M"
        dobDay           = 0
        dobMonth         = 0
        dobYear          = 0
        firstName        = ""
        lastName         = ""
        address          = ""
        address2         = ""
        workAddress      = ""
        city             = ""
        state            = ""
        zip              = ""
        residenceCountry = ""
        citizenCountry   = ""
        timeZone         = ""
        longitude        = 0.0
        latitude         = 0.0
        subscriber       = false
        subscriberInfo   = SubscriberModel()
        creditCards      = []
        cashOutMethods   = []
        images           = []
        totalAmount      = 0
        availableAmount  = 0
        currencies       = []
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        hid              <- map["hid"]
        ambassadorHid    <- map["ambassador_hid"]
        ambassadorName   <- map["ambassador_name"]
        ambassadorAvatar <- map["ambassador_avatar"]
        countryCode      <- map["country_code"]
        phone            <- map["phone"]
        email            <- map["email"]
        password         <- map["password"]
        sex              <- map["sex"]
        dobDay           <- (map["dob_day"], TypeTransform.int)
        dobMonth         <- (map["dob_month"], TypeTransform.int)
        dobYear          <- (map["dob_year"], TypeTransform.int)
        firstName        <- map["first_name"]
        lastName         <- map["last_name"]
        address          <- map["address"]
        address2         <- map["address_2"]
        workAddress      <- map["work_address"]
        city             <- map["city"]
        state            <- map["state"]
        zip              <- map["zip"]
        residenceCountry <- map["residence_country"]
        citizenCountry   <- map["citizen_country"]
        timeZone         <- map["time_zone"]
        longitude        <- (map["longitude"], TypeTransform.double)
        latitude         <- (map["latitude"], TypeTransform.double)
        
        if map.JSON["subscriber"] != nil {            
            if map.JSON["subscriber"] as! Int == 1 {
                subscriber = true
            }
            else {
                subscriber = false
            }
        }
        else {
            subscriber = false
        }
      
//        subscriber       <- (map["subscriber"], TypeTransform.bool)
        subscriberInfo   <- map["subscriber_info"]
        print(map.JSON["credit_cards"])
        creditCards      <- map["credit_cards"]
        cashOutMethods   <- map["cash_out_methods"]
        images           <- map["images"]
        totalAmount      <- (map["total_amount"], TypeTransform.int)
        availableAmount  <- (map["available_amount"], TypeTransform.int)
        currencies       <- map["currencies"]
    }
}
