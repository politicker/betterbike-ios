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
    @Published var locationFailed: Bool = false
    @Published var fetchError: String = ""
    
    let manager = CLLocationManager()
    var location: CLLocationCoordinate2D?
    var authorisationStatus: CLAuthorizationStatus = .notDetermined
    let locationManager = LocationManager()
    
    var latitude: Double {
        return location?.latitude ?? defaultLatitude
    }
    
    var longitude: Double {
        return location?.longitude ?? defaultLongitude
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
                self.fetchError = ""
            case .failure(let error):
                switch error {
                case .serverError(let message):
                    self.fetchError = message.error
                case .unknownError(let message):
                    self.fetchError = message
                default:
                    self.fetchError = error.localizedDescription
                }
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
        self.locationFailed = true
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.authorisationStatus = status
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            self.locationFailed = false
            requestLocation()
        } else {
            self.locationFailed = true
        }
    }
}
