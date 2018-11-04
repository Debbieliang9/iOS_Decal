//
//  ReviewModel.swift
//  MealSavvy
//

import ObjectMapper

class ReviewModel: Mappable {
    
    var supplierId      : String!
    var name            : String!
    var address         : String!
    var serviceName     : String!
    var ratingType      : String!
    var image           : String!
    var bookingId       : String!
    var consumerName    : String!
    var consumerImage   : String!
    var consumerId      : String!
    var technicianName  : String!
    var technicianImage : String!
    var technicianHid   : String!
    var timeSlotStart   : String!
    var timeSlotEnd     : String!
    var baseServiceType : String!
    var quantity        : Int!
    var unitName        : String!
    var status          : String!
    var duration        : Int!
    var updatedAt       : Date!
    
    init() {
        supplierId      = ""
        name            = ""
        address         = ""
        serviceName     = ""
        ratingType      = ""
        image           = ""
        bookingId       = ""
        consumerName    = ""
        consumerImage   = ""
        consumerId      = ""
        technicianName  = ""
        technicianImage = ""
        technicianHid   = ""
        timeSlotStart   = ""
        timeSlotEnd     = ""
        baseServiceType = ""
        quantity        = 0
        unitName        = ""
        status          = ""
        duration        = 0
        updatedAt       = Date ()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        supplierId      <- map["supplier_id"]
        name            <- map["name"]
        address         <- map["address"]
        serviceName     <- map["service_name"]
        ratingType      <- map["rating_type"]
        image           <- map["image"]
        bookingId       <- map["booking_id"]
        consumerName    <- map["consumer_name"]
        consumerImage   <- map["consumer_image"]
        consumerId      <- map["consumer_id"]
        technicianName  <- map["technician_name"]
        technicianImage <- map["technician_image"]
        technicianHid   <- map["technician_hid"]
        timeSlotStart   <- map["time_slot_start"]
        timeSlotEnd     <- map["time_slot_end"]
        baseServiceType <- map["base_service_type"]
        quantity        <- (map["quantity"], TypeTransform.int)
        unitName        <- map["unit_name"]
        status          <- map["status"]
        duration        <- (map["duration"], TypeTransform.int)
        updatedAt       <- (map["updated_at"], DateTransform())
    }
}
