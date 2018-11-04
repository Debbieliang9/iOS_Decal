//
//  AddressModel.swift
//  MealSavvy
//

import ObjectMapper

class AddressModel: Mappable {
    
    var city       : String!
    var line1      : String!
    var postalCode : String!
    var state      : String!
    
    init() {
        city       = ""
        line1      = ""
        postalCode = ""
        state      = ""
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        city       <- map["city"]
        line1      <- map["line1"]
        postalCode <- map["postal_code"]
        state      <- map["state"]
    }
}
