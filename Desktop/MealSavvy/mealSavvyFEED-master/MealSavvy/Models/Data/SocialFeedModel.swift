//
//  SocialFeedModel.swift
//  MealSavvy
//
//  Created by Chris  on 11/3/18.
//  Copyright © 2018 AppsInvo. All rights reserved.
//

import ObjectMapper

class SocialFeedModel: Mappable {
    
    var firstName        : String!
    var lastName         : String!
    var profilePicture   : [String]!
    var restaurant_name  : String!
    var likes            : [String]!
    //var comments         : [CommentModel]!
    var comments         : [[String: Any]]!
    var updatedAt        : Date!
    
    init() {
        firstName       = ""
        lastName        = ""
        restaurant_name = ""
        updatedAt       = Date()
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        firstName       <- map["firstName"]
        lastName        <- map["lastName"]
        profilePicture  <- map["profilePicture"]
        restaurant_name <- map["restaurant_name"]
        likes           <- map["likes"]
        comments        <- map["comments"]
        updatedAt       <- map["updatedAt"]
    }
    //start             <- (map["start"], DateTransform())
}
