//
//  ViewModel.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/28/22.
//

import Foundation
import CoreLocation
import CoreLocationUI
import MapKit
import os
import Combine

let defaultLatitude = 40.7203835
let defaultLongitude = -73.9548707

class ViewModel: NSObject, ObservableObject {
	let logger = Logger(subsystem: "com.politicker-better-bikes.ViewModel", category: "ViewModel")

	static let shared = ViewModel()

	@Published var lastUpdated: String = ""
	@Published var stations: [Station] = []
	@Published var locationFailed: Bool = false
	@Published var fetchError: String = ""
	@Published var stationRoutes: [String: StationRoute] = [:]
	
	var location: CLLocationCoordinate2D?
	var lastUpdatedTimer: Timer?
	var cancelLocation: AnyCancellable?
	let locationService = LocationService()
	
	var latitude: Double {
		return location?.latitude ?? 40.7203835
	}
	
	var longitude: Double {
		return location?.longitude ?? -73.9548707
	}
	
	override init() {
		super.init()
		
		cancelLocation = locationService.$location.sink { result in
			switch result {
			case .success(let coordinate):
				if self.location == nil {
					self.location = coordinate
					self.refresh()
				} else {
					self.location = coordinate
				}
			case .failure(let error):
				switch error {
				case .initial:
					self.locationFailed = false
				default:
					self.locationFailed = true
				}
			}
		}
	}
	
	func requestLocation() {
		locationService.requestLocation()
	}
	
	func fetchStations() async -> Void {
		logger.debug("fetching stations")
		let result = await API().fetchStations(lat: latitude, lon: longitude)
		
		DispatchQueue.main.async {
			switch result {
			case .success(let response):
				self.stations = response.stations
				self.fetchError = ""
				
				if let lastUpdatedTimer = self.lastUpdatedTimer {
					lastUpdatedTimer.invalidate()
				}
				
				self.lastUpdatedTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
					self.lastUpdated = response.shortDate
				}
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
	
	func populateStationRoutes() -> Void {
		for station in stations {
			Task {
				logger.debug("calculating expected travel time for \(station.name)")
				let expectedTravelTime = await calculateExpectedTravelTime(to: station)
				
				guard let expectedTravelTime = expectedTravelTime else {
					return
				}
				
				DispatchQueue.main.async {
					self.stationRoutes[station.id] = StationRoute(expectedTravelTime: expectedTravelTime)
				}
			}
		}
	}
	
	func refresh() {
		Task {
			await fetchStations()
			populateStationRoutes()
		}
	}
	
	func reset() {
		location = nil
	}
}

// MARK: Calculate station distance {
extension ViewModel {
	public func calculateExpectedTravelTime(to station: Station) async -> TimeInterval? {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(station.lat), longitude: CLLocationDegrees(station.lon)), addressDictionary: nil))
		request.transportType = .walking
		
		let directions = MKDirections(request: request)
		var response: MKDirections.Response?
		
		do {
			response = try await directions.calculate()
		} catch {
			return nil
		}
		
		guard let unwrappedResponse = response else {
			return nil
		}
		
		guard let expectedTravelTime = unwrappedResponse.routes.first?.expectedTravelTime else {
			return nil
		}
		
		return expectedTravelTime
	}
}
