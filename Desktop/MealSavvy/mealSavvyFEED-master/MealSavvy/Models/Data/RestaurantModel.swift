//
//  RestaurantModel.swift
//  MealSavvy
//

import ObjectMapper

class RestaurantModel: Mappable {
    /*address = "2041 Market Street";
     city = "San Francisco ";
     distance = "1923.33";
     hid = "086-000-841-425";
     image = "";
     name = "Salon Baobao";*/
    
    var address     : String!
    var city        : String!
    var description : String!
    var hid         : String!
    var image       : String!
    var name        : String!
    var distance    : Float!
    
    init() {
        address     = ""
        city        = ""
        description = ""
        hid         = ""
        image       = ""
        name        = ""
        distance    = 0.0
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        address     <- map["address"]
        city        <- map["city"]
        description <- map["description"]
        hid         <- map["hid"]
        image       <- map["image"]
        name        <- map["name"]
        distance    <- (map["distance"], TypeTransform.float)
    }
}
