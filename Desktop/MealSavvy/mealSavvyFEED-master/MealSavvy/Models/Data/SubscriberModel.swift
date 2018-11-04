//
//  SubscriberModel.swift
//  MealSavvy
//

import ObjectMapper

class SubscriberModel: Mappable {
    
    var hid               : String!
    var name              : String!
    var type              : String!
    var price             : String!
    var remainingMeals    : Int!
    var start             : Date!
    var finish            : Date!
    var totalRedeems      : Int!
    var totalRedeemsPrice : Float!
    var remainingToken    : Int!
    var tokens            : Int!
    var referralCount     : Int!
    
    init() {
        hid               = ""
        name              = ""
        price             = ""
        remainingMeals    = 0
        start             = Date()
        finish            = Date()
        totalRedeems      = 0
        totalRedeemsPrice = 0
        remainingToken    = 0
        tokens            = 0
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        hid               <- map["hid"]
        name              <- map["name"]
        price             <- map["price"]
        type              <- map["type"]
        remainingMeals    <- (map["remainingMeals"], TypeTransform.int)
        
        start             <- (map["start"], DateTransform())        
        finish            <- (map["finsh"], DateTransform())
        totalRedeems      <- (map["totalRedeems"], TypeTransform.int)
        totalRedeemsPrice <- (map["totalRedeemsPrice"], TypeTransform.float)
        remainingToken    <- (map["remainingToken"], TypeTransform.int)
        tokens            <- (map["tokens"], TypeTransform.int)
        referralCount    <- (map["referralCount"], TypeTransform.int)
    }
}
