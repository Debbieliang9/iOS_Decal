//
//  CreditCardModel.swift
//  MealSavvy
//

import ObjectMapper

class CreditCardModel: Mappable {
    
    var cardNumberHash       : String!
    var number               : String!
    var firstName            : String!
    var lastName             : String!
    var expiration           : String!
    var cvc                  : String?
    var token                : String!
    var isDefault            : Bool!
    var cardType             : String!
    var paymentType          : String!
    var postalCode           : String!
    var paymentProcessorType : String!
    
    init() {
        cardNumberHash       = ""
        number               = ""
        firstName            = ""
        lastName             = ""
        expiration           = ""
        cvc                  = ""
        token                = ""
        isDefault            = false
        cardType             = ""
        paymentType          = ""
        postalCode           = ""
        paymentProcessorType = ""
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cardNumberHash       <- map["cardNumberHash"]
        number               <- map["number"]
        firstName            <- map["first_name"]
        lastName             <- map["last_name"]
        expiration           <- map["expiration"]
        cvc                  <- map["cvc"]
        token                <- map["token"]
        isDefault            <- (map["default"], TypeTransform.bool)
        cardType             <- map["card_type"]
        paymentType          <- map["payment_type"]
        postalCode           <- map["postal_code"]
        paymentProcessorType <- map["payment_processor_type"]
    }
}
