//
//  Location.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/29/22.
//
import CoreLocation

struct Location: Identifiable {
		let id = UUID()
		let name: String
		let coordinate: CLLocationCoordinate2D
}
