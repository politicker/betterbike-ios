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
	
	override init() {
		super.init()
		
		cancelLocation = locationService
			.$location
			.sink { result in
				switch result {
					case .success(let coordinate):
						if self.location == nil {
							self.location = coordinate
							self.refresh(coordinate: coordinate)
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

	func requestLocationPermission() {
		locationService.requestAuthorisation()
	}
	
	func requestLocation() {
		locationService.requestLocation()
	}

	// TODO: use `async let` to spin these off concurrently
	func populateStationRoutes(_ stations: [Station]) -> Void {
		for station in stations {
			Task {
				logger.debug("calculating expected travel time for \(station.name)")
				var directions: MKDirections.Response?
				
				if let coordinate = location {
					directions = await Location(name: "", coordinate: coordinate)
						.calculateExpectedTravelTime(to: station)
				}
				
				guard let dirs = directions else {
					return
				}
				
				DispatchQueue.main.async {
					self.stationRoutes[station.id] = StationRoute(directions: dirs)
				}
			}
		}
	}
	
	func refresh(coordinate: CLLocationCoordinate2D) {
		Task {
			let response = await API().fetchStations(coordinate: coordinate)

			DispatchQueue.main.async {
				switch response {
					case .success(let data):
						self.stations = data.stations
						self.fetchError = ""

						self.populateStationRoutes(data.stations)

						if let lastUpdatedTimer = self.lastUpdatedTimer {
							lastUpdatedTimer.invalidate()
						}

						self.lastUpdatedTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
							self.lastUpdated = data.shortDate
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
	}
	
	func reset() {
		location = nil
	}
}

// MARK: Calculate station distance {
extension ViewModel {
}
