//
//  Station.swift
//  citibike-ios
//
//  Created by Harrison Borges on 8/27/22.
//

import Foundation
import CoreLocation

struct Station: Decodable, Identifiable {
	var id: String
	var name: String
	var bikeCount: String
	var bikes: [Bike]
	var lat: Float
	var lon: Float

	enum CodingKeys: String, CodingKey {
		case id
		case name
		case bikeCount
		case bikes
		case lat
		case lon
	}
	
	var coordinate: CLLocationCoordinate2D {
		CLLocationCoordinate2D(latitude: CLLocationDegrees(lat), longitude: CLLocationDegrees(lon))
	}
}
