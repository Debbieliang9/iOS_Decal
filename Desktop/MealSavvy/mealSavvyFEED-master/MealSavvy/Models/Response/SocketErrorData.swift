//
//  SocketErrorData.swift
//  MealSavvy
//

import ObjectMapper

class SocketErrorData: Mappable {
    var data: String!
    var code: String!
    var message: String!

    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        data    <- map["data"]
        code    <- map["code"]
        message <- map["message"]
    }
}
