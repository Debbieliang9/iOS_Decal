//
//  CuisineModel.swift
//  MealSavvy
//

import ObjectMapper

//MARK:- CuisineModel
class CuisineModel: Mappable {

    var tag   : String!
    var name  : String!
    var image : String!
    
    init() {
        tag   = ""
        name  = ""
        image = ""
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        tag   <- map["tag"]
        name  <- map["name"]
        image <- map["image"]
    }
}


//MARK:- CuisineModel
class SubCuisine: Mappable {
    
    var tag   : String!
    var name  : String!
    var amount : String!
    var limit : String!
    var services  : [ServiceModel]!
    
    init() {
        tag   = ""
        name  = ""
        amount = ""
        limit = ""
        services = []
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        tag      <- map["tag"]
        name     <- map["name"]
        amount   <- map["amount"]
        limit    <- map["limit"]
        services <- map["services"]
    }
}


//MARK:- PaymentHistoryModel
class PaymentHistoryModel: Mappable {
    var transaction_hid   : String!
    var type  : String!
    var time : String!
    var tokens: String!
    var amount   : String!
    var currency  : String!
    var technician_name : String!
    var technician_image   : String!
    var service_hid  : String!
    var technician_hid : String!
    var service_name   : String!
    var service_duration  : String!
    var supplier_name : String!
    var quantity   : String!
    var unit_name  : String!
    var item_name : String!
    var payment_method   : String!
    var transaction_type  : String!
    var transaction_status : String!
    var transaction_description   : String!
    
    init() {
         transaction_hid    = ""
         type  = ""
         time = ""
         amount   = ""
         tokens = ""
         currency  = ""
         technician_name = ""
         technician_image  = ""
         service_hid = ""
         technician_hid = ""
         service_name   = ""
         service_duration  = ""
         supplier_name  = ""
         quantity   = ""
         unit_name = ""
         item_name = ""
         payment_method  = ""
         transaction_type  = ""
         transaction_status = ""
         transaction_description   = ""
       
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        transaction_hid   <- map["transaction_hid"]
        type  <- map["type"]
        tokens  <- map["tokens"]
        time <- map["time"]
        amount   <- map["amount"]
        currency  <- map["currency"]
        technician_name <- map["technician_name"]
        technician_image   <- map["technician_image"]
        service_hid  <- map["service_hid"]
        technician_hid <- map["technician_hid"]
        service_name   <- map["service_name"]
        service_duration  <- map["service_duration"]
        supplier_name <- map["supplier_name"]
        quantity   <- map["quantity"]
        unit_name  <- map["unit_name"]
        item_name <- map["item_name"]
        payment_method   <- map["payment_method"]
        transaction_type  <- map["transaction_type"]
        transaction_status <- map["transaction_status"]
        transaction_description   <- map["transaction_description"]
    }
}



