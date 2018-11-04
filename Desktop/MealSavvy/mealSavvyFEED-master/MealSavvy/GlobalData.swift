//
//  GlobalData.swift
//  MealSavvy
//

import CoreLocation

class GlobalData: NSObject {
    static let shared = GlobalData ()
    
    var me: UserModel? {
        didSet {
            UserDefaults.standard.setUser(me)
        }
    }
    
    var deviceToken: String = ""
    
  //  var userLocation: CLLocation = CLLocation(latitude: 29.942492, longitude: -90.130283)
      //var userLocation: CLLocation = CLLocation(latitude: -122.285241, longitude: 37.852145)
     var userLocation: CLLocation = CLLocation(latitude: 37.852145, longitude: -122.285241)
    
    override init() {
        super.init()
        me = UserDefaults.standard.user()
    }
}
