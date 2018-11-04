//
//  LegalEntityModel.swift
//  MealSavvy
//

import ObjectMapper

class LegalEntityModel: Mappable {
    
    var dob       : DobModel!
    var address   : AddressModel!
    var ssnLast4  : Int!
    var firstName : String!
    var lastName  : String!
    var email     : String!
    var type      : String!
    
    init() {
        dob       = DobModel()
        address   = AddressModel()
        ssnLast4  = 0
        firstName = ""
        lastName  = ""
        email     = ""
        type      = "personal"
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        dob       <- map["dob"]
        address   <- map["address"]
        ssnLast4  <- (map["ssn_last_4"], TypeTransform.int)
        firstName <- map["first_name"]
        lastName  <- map["last_name"]
        email     <- map["email"]
        type      <- map["type"]
    }
}
