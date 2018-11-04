//
//  DobModel.swift
//  MealSavvy
//

import ObjectMapper

class DobModel: Mappable {
    
    var day   : Int!
    var month : Int!
    var year  : Int!
    
    init() {
        day   = 0
        month = 0
        year  = 0
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        day   <- (map["day"], TypeTransform.int)
        month <- (map["month"], TypeTransform.int)
        year  <- (map["year"], TypeTransform.int)
    }
}
