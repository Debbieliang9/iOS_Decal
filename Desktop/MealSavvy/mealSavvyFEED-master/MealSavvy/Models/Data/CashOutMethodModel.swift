//
//  CashOutMethodModel.swift
//  MealSavvy
//

import ObjectMapper

class CashOutMethodModel: Mappable {
    
    var cashOutMethodHash : String!
    var type              : String!
    var bankName          : String!
    var routingNumber     : String!
    var accountNumber     : String!
    var legalEntity       : LegalEntityModel!
    var fee               : Int!
    var isDefault            : Bool!
    
    init() {
        cashOutMethodHash = ""
        type              = ""
        bankName          = ""
        routingNumber     = ""
        accountNumber     = ""
        legalEntity       = LegalEntityModel()
        fee               = 0
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cashOutMethodHash <- map["cash_out_method_hash"]
        type              <- map["type"]
        bankName          <- map["bank_name"]
        routingNumber     <- map["routing_number"]
        accountNumber     <- map["account_number"]
        legalEntity       <- map["legal_entity"]
        fee               <- (map["fee"], TypeTransform.int)
    }
}
