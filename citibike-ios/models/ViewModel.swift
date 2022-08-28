//
//  ViewModel.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import Foundation
import CoreLocation
import CoreLocationUI

let defaultLatitude = 40.7203835
let defaultLongitude = -73.9548707

class ViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var lastUpdated: String = ""
    @Published var stations: [Station] = []
    
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var authorisationStatus: CLAuthorizationStatus = .notDetermined
    let locationManager = LocationManager()
    
    var latitude: Double {
        return location?.latitude ?? 40.7203835
    }
    
    var longitude: Double {
        return location?.longitude ?? -73.9548707
    }
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    public func fetchData() -> Void {
        fetchLocation()
    }
    
    public func fetchStations() -> Void {
        API().fetchStations(lat: latitude, lon: longitude) { result in
            switch result {
            case .success(let response):
                self.lastUpdated = response.shortDate
                self.stations = response.stations
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func fetchLocation() -> Void {
        locationManager.requestLocation()
    }
}

// MARK: Location Manager Delegate
extension ViewModel {
    public func requestAuthorisation(always: Bool = false) {
        if always {
            self.manager.requestAlwaysAuthorization()
        } else {
            self.manager.requestWhenInUseAuthorization()
        }
    }
    
    func requestLocation() {
        manager.requestLocation()
        
        // I think this fetches location anytime the phone goes outside of a certain bound
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        fetchStations()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            requestLocation()
        }
    }
}
