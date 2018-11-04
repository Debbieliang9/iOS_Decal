import ObjectMapper

class SupplierModel: Mappable {
    
    var reviews            : [ReviewModel]!
    var services            : [ServiceModel]!
    
    init() {
        reviews            = []
        services            = []
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        print(map.JSON["services"])

        services            <- map["services"]
        reviews             <- map["reviews"]
    }
}
