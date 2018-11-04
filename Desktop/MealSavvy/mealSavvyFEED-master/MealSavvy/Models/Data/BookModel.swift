//
//  ReviewModel.swift
//  MealSavvy
//

import ObjectMapper

class BookModel: Mappable {
    
    var booking_id      : String!
    var charge_price    : String!
    var first_booking   : Int!
    var toolow_time     : String!
    var status          : String!
    var prep_time       : Int!
    var comment         : String!
    
    init() {
        booking_id      = ""
        charge_price    = ""
        comment         = ""
        toolow_time     = ""
        status          = ""
        first_booking   = 0
        prep_time       = 0
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        booking_id      <- map["booking_id"]
        comment      <- map["comment"]
        charge_price    <- map["charge_price"]
        toolow_time     <- map["toolow_time"]
        status          <- map["status"]
//        prep_time        <- (map["prep_time"], TypeTransform.int)
//        status          <- map["status"]
        first_booking        <- (map["first_booking"], TypeTransform.int)
    }
}
