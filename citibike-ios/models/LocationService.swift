//
//  LocationService.swift
//  default
//
//  Created by Quinn Shanahan on 9/3/22.
//

import Foundation
import CoreLocation
import CoreLocationUI

enum LocationError: Error {
	case updateFailed
	case failedWithError(Error)
	case authFailed
	case initial
}

class LocationService: NSObject, ObservableObject {
	let manager = CLLocationManager()
	@Published var location: Result<CLLocationCoordinate2D, LocationError> = .failure(.initial)

	override init() {
		super.init()
		manager.delegate = self
	}
	
	func requestAuthorisation(always: Bool = false) {
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
}

// MARK: Location Manager Delegate
extension LocationService: CLLocationManagerDelegate {
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

		if let coordinate = locations.first?.coordinate {
			location = .success(coordinate)
		} else {
			location = .failure(.updateFailed)
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		print("error:: \(error.localizedDescription)")
		location = .failure(.failedWithError(error))
	}
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse || status == .authorizedAlways {
			location = .failure(.initial)
			requestLocation()
		} else {
			location = .failure(.authFailed)
		}
	}
}
