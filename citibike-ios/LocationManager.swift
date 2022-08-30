//
//  LocationManager.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import CoreLocation
import CoreLocationUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    
    @Published var location: CLLocationCoordinate2D?
    @Published var authorisationStatus: CLAuthorizationStatus = .notDetermined
    
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    public func requestAuthorisation() {
            self.manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
        
        // I think this fetches location anytime the phone goes outside of a certain bound
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
        
        if status == .authorizedWhenInUse {
            requestLocation()
        }
    }
}
