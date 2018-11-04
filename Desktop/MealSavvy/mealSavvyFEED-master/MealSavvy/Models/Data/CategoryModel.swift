//
//  CategoryModel.swift
//  MealSavvy
//

import ObjectMapper

class CategoryModel: Mappable {
    
    var tag      : String!
    var name     : String!
    var amount   : Int!
    var limit    : Int?
    var services : [ServiceModel]!
    
    init() {
        tag      = ""
        name     = ""
        amount   = 0
        limit    = 0
        services = []
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        tag      <- map["tag"]
        name     <- map["name"]
        amount   <- (map["amount"], TypeTransform.int)
        limit    <- (map["limit"], TypeTransform.int)
        services <- map["services"]
    }
}
