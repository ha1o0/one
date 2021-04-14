//
//  LocationService.swift
//  one
//
//  Created by sidney on 2021/4/15.
//

import Foundation
import MapKit

class LocationService {
    static let shared = LocationService()
    let locationManager: CLLocationManager = CLLocationManager()
    
    private init() {
        
    }
    
    func requireLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            print("得到位置权限")
            locationManager.startUpdatingLocation()
        } else {
            print("拒绝位置权限")
        }
    }
    
}
