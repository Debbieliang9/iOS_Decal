//
//  SocketResponse.swift
//  MealSavvy
//

import ObjectMapper

class SocketResponse: Mappable {
    var success: Bool!
    var data: Any!
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        success <- map["success"]
        data    <- map["data"]
    }
}
