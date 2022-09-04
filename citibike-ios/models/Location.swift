//
//  Location.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/29/22.
//

import Foundation
import CoreLocation
import CoreLocationUI
import MapKit
import os
import Combine

struct Location: Identifiable {
	let id = UUID()
	let name: String
	let coordinate: CLLocationCoordinate2D
	
	public func calculateExpectedTravelTime(to station: Station) async -> MKDirections.Response? {
		let request = MKDirections.Request()
		request.source = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
		request.destination = MKMapItem(placemark: MKPlacemark(coordinate: station.coordinate, addressDictionary: nil))
		request.transportType = .walking
		
		let directions = MKDirections(request: request)
		
		do {
			return try await directions.calculate()
		} catch {
			return nil
		}
	}
}
