//
//  LocationManager.swift
//

import Foundation
import CoreLocation

final class LocationManager:NSObject {
    typealias UserLocationCompletionHandler = (_ location:CLLocation) -> ()
    typealias ErrorCompletionHandler = (_ error:String) -> ()
    
    //MARK- Static
    static let shared = LocationManager()
    
    //MARK:- Private vars
    fileprivate let locationManager = CLLocationManager()
    fileprivate var locationBlock:UserLocationCompletionHandler?
    
    //MARK:- Public vars
    var currentLocation:CLLocation?
    
    //MARK:-Public Method
    func startMonitoringLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.delegate = self
        locationManager.distanceFilter = LocationManager.Constant.Distance_Filter
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation();
    }
    
    func restartMonitoringLocation() {
        locationManager.stopUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation();
    }
    
    func stopMonitorLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getUserCurrentLocation(handler: @escaping UserLocationCompletionHandler) {
        locationBlock = handler
        self.restartMonitoringLocation()
    }
}

//MARK:- Extension
extension LocationManager {
    struct Constant {
        static let Distance_Filter = 100.0
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        
        if let location = currentLocation {
            if let _ = locationBlock {
                self.locationBlock!(location)
            }
        }
    }
}
