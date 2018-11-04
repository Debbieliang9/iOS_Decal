//
//  CommentModel.swift
//  MealSavvy
//
//  Created by Chris  on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import ObjectMapper

class CommentModel: Mappable {
    var firstName        : String!
    var lastName         : String!
    var message          : String!
    var updatedAt        : Date!
    
    init() {
        firstName      = ""
        lastName       = ""
        message        = ""
        updatedAt      = Date()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName      <- map["firstName"]
        lastName       <- map["lastName"]
        message        <- map["message"]
        updatedAt      <- map["updatedAt"]
    }
}
